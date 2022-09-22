#!/bin/bash

# This script creates a Windows NSIS MSI installer from the current set of installed opam Coq packages

set -o nounset
set -o errexit

##### Get the release and package pick of the Coq Platform #####

source shell_scripts/get_names_from_switch.sh

echo "##### Coq Platform release = ${COQ_PLATFORM_RELEASE} version = ${COQ_PLATFORM_PACKAGE_PICK_POSTFIX} #####" 

##### Files and folders #####

# The opam prefix - stripped from absolute paths to create relative paths
OPAM_PREFIX="$(opam conf var prefix)"

# The architecture
COQ_ARCH=$(uname -m)

# The folder for the windows installer stuff
DIR_TARGET=windows_installer
rm -rf "$DIR_TARGET"
mkdir -p "$DIR_TARGET"

# The NSIS include file for the visible installer sections
FILE_SEC_VISIBLE="$DIR_TARGET"/sections_visible.nsh
> "$FILE_SEC_VISIBLE"

# The NSIS include file for the hidden installer sections
FILE_SEC_HIDDEN="$DIR_TARGET"/sections_hidden.nsh
> "$FILE_SEC_HIDDEN"

# The NSIS include file for dependencies between user visible packages
FILE_DEP_VISIBLE="$DIR_TARGET"/dependencies_visible.nsh
> "$FILE_DEP_VISIBLE"

# The NSIS include file for dependencies between hidden packages
FILE_DEP_HIDDEN="$DIR_TARGET"/dependencies_hidden.nsh
> "$FILE_DEP_HIDDEN"

# a NSIS include file, which resets all hidden dependency selections
FILE_RES_HIDDEN="$DIR_TARGET"/reset_hidden.nsh
> $FILE_RES_HIDDEN

# a NSIS include file which selects dependents of visible sections
FILE_VISIBLE_SEL="$DIR_TARGET"/dependencies_visible_selection.nsh

# a NSIS include file which deselects dependents of visible sections
FILE_VISIBLE_DESEL="$DIR_TARGET"/dependencies_visible_deselection.nsh

# The NSIS include file for strings, e.g. section descriptions
FILE_STRINGS="$DIR_TARGET"/strings.nsh
> "$FILE_STRINGS"

# The NSIS include file for section descriptions
FILE_SEC_DESCRIPTIONS="$DIR_TARGET"/section_descriptions.nsh
> "$FILE_SEC_DESCRIPTIONS"

##### Utility functions #####

# Check if a newline searated list contains an item
# $1 = list
# $2 = item

function list_contains {
#   This variant does not work when $2 contains regexp chars like conf-g++
#   [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]]
    [[ $'\n'"$1"$'\n' == *$'\n'"$2"$'\n'* ]]
}

# Add dlls for an executable using ldd to find them
# $1 = executable name
# $2 = regexp filter (grep)
# $3 = file list file name

function add_dlls_using_ldd {
  if [ -f "$DIR_TARGET/$3.nsh" ]
  then
    echo "Adding DLLs for $1"
    echo 'SetOutPath $INSTDIR\bin' >> "$DIR_TARGET/$3.nsh"
    for file in $(ldd $(which "$1") | cut -d ' ' -f 3 | grep "$2" | sort -u)
    do
      echo -n "FILE "; cygpath -aw "$file";
    done >> "$DIR_TARGET/$3.nsh"
  fi
}

# Add files from a cygwin package using package name and grp filter
# $1 = cygwin package name
# $2 = regexp filter (grep)
# $3 = file list file name
# Note:
# This function strips common prefixes in the destination.
# Currently only one prefix is stripped:
#   /usr/${COQ_ARCH}-w64-mingw32/sys-root/mingw/
# In case there are additional prefixes to skip add them here.
# It doesn't make much sense to have a prefix parameter, because one
# package could have several prefixes

function add_files_using_cygwin_package {
  if [ -f "$DIR_TARGET/$3.nsh" ]
  then
    echo "Adding files from cygwin package $1"
    prevpath="--none--"
    for file in $(cygcheck -l "$1" | grep "$2" | sort -u)
    do
      relpath="${file#/usr/${COQ_ARCH}-w64-mingw32/sys-root/mingw/}"
      relpath="${relpath%/*}"
      if [ "$relpath" != "$prevpath" ]
      then
        echo 'SetOutPath $INSTDIR\'"$(cygpath -w "$relpath")"
        prevpath="$relpath"
      fi
      echo -n "FILE "; cygpath -aw "$file";
    done >> "$DIR_TARGET/$3.nsh"
  fi
}

# Add a folder recursively
# $1 = path prefix (absolute cygwin format, must end with /)
# $2 = relative path to $1 (must not start with /)
# $3 file list file name

function add_foler_recursively {
  if [ -f "$DIR_TARGET/$3.nsh" ]
  then
    echo "Adding files from folder $1/$2"
    prevpath="--none--"
    for file in $(find $1$2 -type f | sort -u)
    do
      relpath="${file#$1}"
      relpath="${relpath%/*}"
      if [ "$relpath" != "$prevpath" ]
      then
        echo 'SetOutPath $INSTDIR\'"$(cygpath -w "$relpath")"
        prevpath="$relpath"
      fi
      echo -n "FILE "; cygpath -aw "$file";
    done >> "$DIR_TARGET/$3.nsh"
  fi
}

# Add a single file
# $1 = path prefix (absolute cygwin format)
# $2 = relative path to $1
# $3 file list file name

function add_single_file {
  if [ -f "$DIR_TARGET/$3.nsh" ]
  then
    echo 'SetOutPath $INSTDIR\'"$(dirname "$(cygpath -w "$2")")" >> "$DIR_TARGET/$3.nsh"
    echo -n "FILE $(cygpath -aw "$1$2")" >> "$DIR_TARGET/$3.nsh"
  fi
}

###### Get filtered list of explicitly installed packages #####

echo "Create package list"

SELECTABLE_PACKAGES="$(opam list --installed-roots --short --columns=name | grep -v '^ocaml\|^opam\|^depext\|^conf\|^lablgtk\|^elpi')"

###### Associative array with package name -> file filter (regexp pattern) #####

# If not white list regexp is given it is "."
# If not black list list regexp is given it is "\.byte\.exe$"

declare -A OPAM_FILE_WHITELIST
declare -A OPAM_FILE_BLACKLIST

OPAM_FILE_WHITELIST[ocaml-variants]='.^' # this has the ocaml compiler in
OPAM_FILE_WHITELIST[base]='.^' # ocaml stdlib
OPAM_FILE_WHITELIST[ocaml-compiler-libs]='.^'

OPAM_FILE_WHITELIST[dune]='.^'
OPAM_FILE_WHITELIST[configurator]='.^'
OPAM_FILE_WHITELIST[sexplib0]='.^'
OPAM_FILE_WHITELIST[csexp]='.^'
OPAM_FILE_WHITELIST[ocamlbuild]='.^'
OPAM_FILE_WHITELIST[result]='.^'
OPAM_FILE_WHITELIST[cppo]='.^'

OPAM_FILE_WHITELIST[elpi]='.^' # linked in coq-elpi
OPAM_FILE_WHITELIST[camlp5]='.^' # linked in elpi
OPAM_FILE_WHITELIST[ppx_drivers]='.^' # linked in elpi
OPAM_FILE_WHITELIST[ppxlib]='.^' # linked in elpi
OPAM_FILE_WHITELIST[ppx_deriving]='.^' # linked in elpi
OPAM_FILE_WHITELIST[ocaml-migrate-parsetree]='.^' # linked in elpi
OPAM_FILE_WHITELIST[re]='.^' # linked in elpi

OPAM_FILE_WHITELIST[lablgtk3]="stubs.dll$" # we keep only the stublib DLL, the rest is linked in coqide
OPAM_FILE_WHITELIST[lablgtk3-sourceview3]="stubs.dll$" # we keep only the stublib DLL, the rest is linked in coqide
OPAM_FILE_WHITELIST[cairo2]="stubs.dll$" # we keep only the stublib DLL, the rest is linked in coqide

###### Function for analyzing one package

# Analyze one package
# - retrieve list of files and create NSIS include file
# - retrieve dependencies and create NSIS file for user visible and hidden dependencies
# $1 = package name
# $2 = dependency level

function analyze_package {
  echo "Analyzing package $1 ($2)"

  # Create section entry
  if list_contains "$SELECTABLE_PACKAGES" "$1"
  then
    # This is a user visible package which can be explicitly selected or deselected
    echo "Section \"$1\" Sec_${1//-/_}" >> "$FILE_SEC_VISIBLE"
    echo 'SetOutPath "$INSTDIR\"' >> "$FILE_SEC_VISIBLE"
    echo "!include \"files_$1.nsh\"" >> "$FILE_SEC_VISIBLE"
    echo "SectionEnd" >> "$FILE_SEC_VISIBLE"

    descr="$(opam show --field=synopsis "$1")"
    descr="${descr//\"/\'}"
    echo 'LangString DESC_'"${1//-/_}"' ${LANG_ENGLISH} "'"$descr"'"' >> "$FILE_STRINGS"
    echo '!insertmacro MUI_DESCRIPTION_TEXT ${Sec_'"${1//-/_}"'} $(DESC_'"${1//-/_}"')' >> "$FILE_SEC_DESCRIPTIONS"
  else
    # This is a hidden section which is selected automatically by dependency
    echo "Section \"-$1\" Sec_${1//-/_}" >> "$FILE_SEC_HIDDEN"
    echo 'SetOutPath "$INSTDIR\"' >> "$FILE_SEC_HIDDEN"
    echo "!include \"files_$1.nsh\"" >> "$FILE_SEC_HIDDEN"
    echo "SectionEnd" >> "$FILE_SEC_HIDDEN"
  fi

  # Create file list include file

  if [ ${OPAM_FILE_WHITELIST[$1]+_} ]
  then
    whitelist="${OPAM_FILE_WHITELIST[$1]}"
  else
    whitelist="." # take everything
  fi

  if [ ${OPAM_FILE_BLACKLIST[$1]+_} ]
  then
    blacklist="${OPAM_FILE_BLACKLIST[$1]}"
  else
    blacklist="(\.byte\.exe|\.cm[aioxt]|\.cmxa|\.cmti|\.o|\.a|\.glob|\.h)$" # exclude byte code and library stuff
  fi

  echo "# File list for $1 matching $whitelist excluding $blacklist" > "$DIR_TARGET"/files_$1.nsh
  files="$(opam show --list-files $1 | grep -E "$whitelist" | grep -E -v "$blacklist" )" || true
  reldir_win_prev="--none--"
  for file in $files
  do
    if [ -d "$file" ]
    then
      true # ignore directories
    elif [ -f "$file" ]
    then
      relpath="${file#$OPAM_PREFIX}"
      reldir="${relpath%/*}"

      file_win="${file//\//\\}"
      reldir_win="${reldir//\//\\}"

      if [ "$reldir_win" != "$reldir_win_prev" ]
      then
        echo SetOutPath "\$INSTDIR$reldir_win" >> "$DIR_TARGET"/files_$1.nsh
      fi
      echo FILE "$file_win" >> "$DIR_TARGET"/files_$1.nsh

      reldir_win_prev="$reldir_win"
    else
      echo "In package '$1' the file '$file' does not exist"
      exit 1
    fi
  done

  # handle dependencies
  # Note: the --installed is required cause of an opam bug.
  # See https://github.com/ocaml/opam/issues/4461
  dependencies="$(opam list --required-by=$1 --short --installed)"
  for dependency in $dependencies
  do
    # Check if dependency is visible or hidden and write dependency checker macro call in respective NSIS include file
    if list_contains "$SELECTABLE_PACKAGES" "$dependency"
    then
      # This is a user visible package which can be explicitly selected or deselected
      echo "${1//-/_}" "${dependency//-/_}" >> "$FILE_DEP_VISIBLE.in"
    else
      # This is a hidden dependency package
      echo "${1//-/_}" "${dependency//-/_}" >> "$FILE_DEP_HIDDEN.in"
    fi

    # Check if dependency is already in the list of known packages
    if ! list_contains "$PACKAGES" "$dependency"
    then
      PACKAGES="$PACKAGES"$'\n'"$dependency"
      analyze_package "$dependency" $(($2 + 1))
    fi
  done
}

###### Function for sorting a dependency list by level #####

# Sort a dependecy file by dependency level (leaves last)
# $1 input file name
# $2 check macro output file name
# $3 NSIS Check macro name
# $4 reset macro output file name
# $5 sort options (e.g. -r for reverse)

function sort_dependencies
{
  cat  "$1" | awk '
    BEGIN{n=0}
    { DepSrc[n]=$1; DepDest[n]=$2; n++; IsSrc[$1]=1; IsDest[$2]=1; }
    END{
      PROCINFO["sorted_in"] = "@ind_str_asc";
      for (pkg in IsDest) {
        if(!IsSrc[pkg]) DestLvl[pkg]=1
      }
      fnd=1;
      for(lvl=1; fnd; lvl++) {
        fnd=0;
        for (i=0; i<n; i++) {
          if (DestLvl[DepDest[i]]==lvl) {
            DestLvl[DepSrc[i]]=lvl+1;
            DepLvl[i]=lvl;
            fnd=1;
          }
        }
        if(lvl>=50) {
          print "The dependency tree has more than 50 levels - there are likely cyclic dependencies";
          exit 1;
        }
      }
      for (pkg in IsDest) {
        print "${UnselectSection}", "${Sec_"pkg"}" >> "'"$4"'"
      }
      for (i=0; i<n; i++) {
        print DepLvl[i], DepSrc[i], DepDest[i];
      }
    }' | sort $5 -n | awk "
    { print \"\${$3}\", \"\${Sec_\"\$2\"}\", \"\${Sec_\"\$3\"}\", \"'\"\$2\"'\", \"'\"\$3\"'\"; }" > "$2"
}

###### Go through selected packages and recursively analyze dependencies #####

# The initial list of packages is the list of top level packages
PACKAGES="$SELECTABLE_PACKAGES"

for package in $SELECTABLE_PACKAGES
do
  analyze_package "$package" 0
done

###### Add system DLLs to some packages #####

add_dlls_using_ldd "coqc" "/usr/${COQ_ARCH}-w64-mingw32/sys-root/" "files_coq"
add_dlls_using_ldd "coqide" "/usr/${COQ_ARCH}-w64-mingw32/sys-root/" "files_coqide"
add_dlls_using_ldd "gappa" "/usr/${COQ_ARCH}-w64-mingw32/sys-root/" "files_gappa"

###### Add GTK resources #####

### Adwaita icon theme

add_files_using_cygwin_package "mingw64-${COQ_ARCH}-adwaita-icon-theme"  \
"/\(16x16\|22x22\|32x32\|48x48\)/.*\("\
"actions/bookmark\|actions/document\|devices/drive\|actions/format-text\|actions/go\|actions/list\|"\
"actions/media\|actions/pan\|actions/process\|actions/system\|actions/window\|"\
"mimetypes/text\|places/folder\|places/user\|status/dialog\)"  \
"files_conf-adwaita-icon-theme"

### GTK compiled schemas

add_single_file "/usr/${COQ_ARCH}-w64-mingw32/sys-root/mingw/" "share/glib-2.0/schemas/gschemas.compiled" "files_dep-glib-compiled-schemas"

### GTK sourceview languag specs and styles (except coq itself)

# Not really everything is needed from this. These might suffice:
# language-specs/dev.lang
# language-specs/language.dtd
# language-specs/language.rng
# language-specs/language2.rng
# styles/classic.xml
# But since teh complete set is compressed not that large, we add the complete set

add_foler_recursively "/usr/${COQ_ARCH}-w64-mingw32/sys-root/mingw/" "share/gtksourceview-3.0" "files_dep-gtksourceview3"

###### Create dependency reset/selection/deselection include files #####

sort_dependencies "$FILE_DEP_HIDDEN.in" "$FILE_DEP_HIDDEN" 'CheckHiddenSectionDependency' "$FILE_RES_HIDDEN" -r
sort_dependencies "$FILE_DEP_VISIBLE.in" "$FILE_VISIBLE_SEL" 'SectionVisibleSelect' /dev/null -r
sort_dependencies "$FILE_DEP_VISIBLE.in" "$FILE_VISIBLE_DESEL" 'SectionVisibleDeSelect' /dev/null ""

###### Create the NSIS installer #####

cd $DIR_TARGET

# NSIS 2.51 has the bug that $0 is not set in .onSelChange, so use the latest version 3.06.1

wget --no-clobber --progress=dot:giga https://github.com/coq/prerequisites/releases/download/2021.02.2/nsis-3.06.1.zip
unzip -o nsis-3.06.1
# Unzipping this results in very strange permissions - fix this
chmod -R 700 nsis-3.06.1

# Enable the below lines to enable logging
# wget --no-clobber --progress=dot:giga http://downloads.sourceforge.net/project/nsis/NSIS%203/3.06.1/nsis-3.06.1-log.zip
# unzip -o nsis-3.06.1-log.zip -d nsis-3.06.1-log
# cp -rf nsis-3.06.1-log/* nsis-3.06.1

NSIS=$(pwd)/nsis-3.06.1/makensis.exe

chmod u+x "$NSIS"
cp ../windows/*.ns* .

# ToDo: we need a more elegant way to get this data via opam
wget https://github.com/coq/coq/raw/v8.13/ide/coqide/coq.ico
wget https://github.com/coq/coq/raw/v8.13/LICENSE
wget https://raw.githubusercontent.com/AbsInt/CompCert/v3.8/LICENSE -O coq-compcert-license.txt
wget https://raw.githubusercontent.com/PrincetonUniversity/VST/v2.7/LICENSE -O coq-vst-license.txt

echo "==============================================================================="
echo "NOTE: The creation of the installer can take 10 minutes"
echo "(cause of the CPU heavy but effective LZMA compression used)"
echo "==============================================================================="

"$NSIS" -DRELEASE="${COQ_PLATFORM_RELEASE}" -DVERSION="${COQ_PLATFORM_PACKAGE_PICK_POSTFIX}" -DARCH="$COQ_ARCH" Coq.nsi

echo "==============================================================================="
echo "Created installer:"
echo "$DIR_TARGET/Coq-Platform-release-${COQ_PLATFORM_RELEASE}-version${COQ_PLATFORM_PACKAGE_PICK_POSTFIX}-arch-${COQ_ARCH}.exe"
echo "==============================================================================="
cd ..
