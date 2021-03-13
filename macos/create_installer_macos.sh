#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CREATE MAC DMG INSTALLER ######################

# Options:
# -quick|-q   : disable ZIP compression of DMG file (much faster to create and install for tests)
# -install|-i : install package to /Application after creating it
# -otooldump  : provide the output of otool -L for all executables

###################### PRELIMINARIES ######################

echo "##### Building Mac DMG installer #####"

###### Script safety ######

set -o nounset
set -o errexit

###### Parse command line ######

ZIPCOMPR=9
INSTALL='N'
OTOOLDUMP='N'

for arg in "$@"
do
  case "${arg}" in
    -quick|-q) ZIPCOMPR=0 ;;
    -install|-i) INSTALL='Y' ;;
    -otooldump) OTOOLDUMP='Y' ;;
    *) echo "ERROR: Unknown command line argument ${arg}!"; false;;
  esac
done

###### Check if required system utilities are installed #####

if ! command -v port  &> /dev/null
then
  echo "This script assumes that system dependencies have been installed via MacPorts."
  echo "If you are using Homebrew, please adjust add_files_using_macports_package."
  exit 1
fi

command -v gfind &> /dev/null || ( echo "Install gfind (eg. sudo port install findutils)" ; exit 1)
command -v grealpath &> /dev/null || ( echo "Install gfind (eg. sudo port install coreutils)" ; exit 1)
command -v macpack  &> /dev/null || ( echo "Install macpack (eg. sudo port install py38-pip; port select --set pip3 pip38; pip3 install macpack)" ; exit 1)

###### Create working folder and cd #####

rm -rf macos_installer/
mkdir macos_installer/
cd macos_installer/
mkdir logs

###### Get the Coq sourcees from opam #####

# Get installed version of coq (otherwise opam source gives the latest)
coqpackagefull=$(opam list --installed-roots --short --columns=name,version coq | sed 's/ /./')
opam source --dir=coq/ ${coqpackagefull}

##### Get the version of Coq #####

COQ_VERSION=$(coqc --print-version | cut -d ' ' -f 1)

# The MacOS version needs to be purely numeric (no +beta) and is set separately in configure.ml
COQ_VERSION_MACOS=$(egrep -o 'coq_macos_version *= *"[0-9.]+"' coq/configure.ml | cut -d '=' -f 2 | tr -d ' "')

echo "##### Coq version = ${COQ_VERSION} (Mac app version=${COQ_VERSION_MACOS}) #####"

##### Create DMG package folder structure #####

# Folder and image names

APP_NAME="Coq_${COQ_VERSION}.app"
DMG_NAME="coq-${COQ_VERSION}-installer-macos"
APP_ABSDIR="_dmg/${APP_NAME}"
RSRC_ABSDIR="${APP_ABSDIR}/Contents/Resources"
BIN_ABSDIR="$RSRC_ABSDIR/bin"
DYNLIB_ABSDIR="$RSRC_ABSDIR/lib/dylib"

# Sub folders

mkdir -p ${APP_ABSDIR}
mkdir ${APP_ABSDIR}/Contents/
mkdir ${APP_ABSDIR}/Contents/MacOS  # The top level executable shown in launcher
mkdir -p ${RSRC_ABSDIR}             # Most files go here
mkdir -p ${DYNLIB_ABSDIR}           # System shared libraries

##### Opam folder variables #####

# The opam prefix - stripped from absolute paths to create relative paths
OPAM_PREFIX="$(opam conf var prefix)"

##### MacPorts folder variables #####

# If someone knows a better way to find out where port is installed, please let me know!

PORTCMD="$(which port)"
PORTDIR="${PORTCMD%bin/port}"

###################### UTILITY FUNCTIONS ######################

# Check if a newline searated list contains an item
# $1 = list
# $2 = item

function list_contains {
#   This variant does not work when $2 contains regexp chars like conf-g++
#   [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]]
    [[ $'\n'"$1"$'\n' == *$'\n'"$2"$'\n'* ]]
}

# Find shared library dependencies and patch one binary using macpack
# $1 full path to binary
# $3 relative path from binary to "${RSRC_ABSDIR}" filder

> logs/macpack.log

function add_dylibs_using_macpack {
  type="$(file -b $1)"
  if [ "${type}" == 'Mach-O 64-bit executable x86_64' ] || [ "${type}" == 'Mach-O 64-bit bundle x86_64' ]
  then
    echo "Copying shared libraries for $1 ..."
    macpack -v -d "$2"/lib/dylib $1 >> logs/macpack.log
  else
    echo "INFO: File '$1' with type '${type}' ignored."
  fi
}

# Add files from a MacPorts package using package name and grp filter
# $1 = MacPorts package name
# $2 = regexp filter (grep)
# Note:
# This function strips the install path of the "port" command

function add_files_using_macports_package {
  echo "Copying files from MacPorts package $1 ..."
  for file in $(port contents "$1" | grep "$2" | sort -u)
  do
    relpath="${file#${PORTDIR}}"
    reldir="${relpath%/*}"
    mkdir -p "$RSRC_ABSDIR/$reldir"
    cp "$file" "$RSRC_ABSDIR/$reldir/"
  done
}

# Add a folder recursively
# $1 = path prefix (absolute)
# $2 = relative path to $1 and ${RSRC_ABSDIR} (must not start with /)

function add_foler_recursively {
  echo "Copying files from folder $1/$2 ..."
  mkdir -p "${RSRC_ABSDIR}/$2/"
  cp -R "$1/$2/" "${RSRC_ABSDIR}/$2/"
}

# Add a single file
# $1 = path prefix (absolute)
# $2 = relative path to $1 and ${RSRC_ABSDIR}
# $3 = file name

function add_single_file {
  echo "Copying single file $1/$2/$3"
  mkdir -p "${RSRC_ABSDIR}/$2"
  cp "$1/$2/$3" "${RSRC_ABSDIR}/$2/"
}

###### Get filtered list of explicitly installed packages #####

# Note: since both positive and negative filtering makes sense, we do both and require that the result is identical.
# This ensures people get what they expect.

echo "Create package list"

packages_pos="$(opam list --installed-roots --short --columns=name | grep '^coq\|^menhir\|^gappa')"
packages_neg="$(opam list --installed-roots --short --columns=name | grep -v '^ocaml\|^opam\|^depext\|^conf\|^lablgtk\|^elpi')"

if [ "$packages_pos" != "$packages_neg" ]
then
  echo "The positive and negative list of opam packages differs. Please adjust the package filters!"
  echo "Positive list = $packages_pos"
  echo "Negative list = $packages_neg"
  exit 1
fi

PRIMARY_PACKAGES="$packages_pos"

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

# Lits of packages to ignore - separated by and starting with $'\n'
IGNORED_PACKAGES=$'\n'"ocaml-secondary-compiler"

###### Function for analyzing one package

# Analyze one package
# - retrieve list of files and copy to ${RSRC_ABSDIR}
# - retrieve dependencies and add to list of dependent packages
# $1 = package name
# $2 = dependency level

function process_package {
  echo "Copying package $1 ($2) ..."

  # Copy files

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
    blacklist="(\.byte|\.cm[aiox]|\.cmxa|\.o|\.a)$" # exclude byte code and library stuff
  fi

  files="$(opam show --list-files $1 | grep -E "$whitelist" | grep -E -v "$blacklist" )" || true
  for file in $files
  do
    if [ -d "$file" ]
    then
      true # ignore directories
    elif [ -f "$file" ]
    then
      relpath="${file#$OPAM_PREFIX}"
      reldir="${relpath%/*}"
      mkdir -p "$RSRC_ABSDIR/$reldir"
      cp "$file" "$RSRC_ABSDIR/$reldir/"
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
    # Check if dependency is already in the list of known packages
    if ! list_contains "$PACKAGES" "$dependency"
    then
      PACKAGES="$PACKAGES"$'\n'"$dependency"
      process_package "$dependency" $(($2 + 1))
    fi
  done
}

###################### TOP LEVEL FILE GATHERING ######################

###### Go through selected packages and recursively analyze dependencies #####

echo '##### Copy Opam packages #####'

# The initial list of already or otherwise processed packages is the list of top level packages
# plus packages we don't want
PACKAGES="$PRIMARY_PACKAGES$IGNORED_PACKAGES"

for package in $PRIMARY_PACKAGES
do
  process_package "$package" 0
done

##### Find system shared libraries the installed binaries depend on #####

echo '##### Copy system shared libraries #####'

# Copy dynamically loaded (invisible for 'otool') shared libraries for GDK and GTK

PIXBUF_LOADER_ABSDIR="$RSRC_ABSDIR/lib/gdk-pixbuf-2.0/2.10.0/loaders"
mkdir -p "$PIXBUF_LOADER_ABSDIR"
PIXBUF_LOADER_RELDIR="$(grealpath --relative-to="$PIXBUF_LOADER_ABSDIR" "$RSRC_ABSDIR")"
for file in $(gdk-pixbuf-query-loaders | grep pixbufloader | sed s/\"//g); do
  cp ${file} "$PIXBUF_LOADER_ABSDIR/"
done

IMMODULES_ABSDIR="$RSRC_ABSDIR/lib/gtk-3.0/3.0.0/immodules"
mkdir -p "$IMMODULES_ABSDIR"
IMMODULES_RELDIR="$(grealpath --relative-to="$IMMODULES_ABSDIR" "$RSRC_ABSDIR")"
for file in $(gtk-query-immodules-3.0 | grep /im- | sed s/\"//g); do
  cp ${file} "$IMMODULES_ABSDIR"
done

for file in $(find "${BIN_ABSDIR}" -type f)
do
  add_dylibs_using_macpack "${file}" ".."
done

for file in $(find "$PIXBUF_LOADER_ABSDIR" -type f)
do
  add_dylibs_using_macpack "${file}" "$PIXBUF_LOADER_RELDIR"
done

for file in $(find "$IMMODULES_ABSDIR" -type f)
do
  add_dylibs_using_macpack "${file}" "$IMMODULES_RELDIR"
done

# Dynamic library debug output

if [ "$OTOOLDUMP" == 'Y' ]
then
  > logs/otool.log
  for file in $BIN_ABSDIR/* $DYNLIB_ABSDIR/* $PIXBUF_LOADER_ABSDIR/* $IMMODULES_ABSDIR/*
  do
    otool -L $file >> logs/otool.log
  done
fi

##### Add files from additional macports packages #####

### Adwaita icon theme

add_files_using_macports_package "adwaita-icon-theme"  \
"/\(16x16\|22x22\|32x32\|48x48\)/.*\("\
"actions/bookmark\|actions/document\|devices/drive\|actions/format-text\|actions/go\|actions/list\|"\
"actions/media\|actions/pan\|actions/process\|actions/system\|actions/window\|"\
"mimetypes/text\|places/folder\|places/user\|status/dialog\)"  \
"files_conf-adwaita-icon-theme"

### GTK compiled schemas

add_single_file "${PORTDIR}" "share/glib-2.0/schemas" "gschemas.compiled"

### GTK sourceview languag specs and styles (except coq itself)

# Not really everything is needed from this. These might suffice:
# language-specs/dev.lang
# language-specs/language.dtd
# language-specs/language.rng
# language-specs/language2.rng
# styles/classic.xml
# But since the complete set is compressed not that large, we add the complete set

add_foler_recursively "${PORTDIR}" "share/gtksourceview-3.0"

##### MacOS DMG installer specific files #####

# Create Info.plist file

sed -e "s/VERSION/${COQ_VERSION_MACOS}/g" coq/ide/coqide/MacOS/Info.plist.template > \
    ${APP_ABSDIR}/Contents/Info.plist

# Create a shell script to start CoqIDE with correct environmant

cat> ${APP_ABSDIR}/Contents/MacOS/coqide <<'EOT'
#!/bin/sh
HERE=$(cd $(dirname $0); pwd)
export PATH="${HERE}/../Resources/bin/:${PATH}"
export LD_LIBRARY_PATH="${HERE}"
export DYLD_LIBRARY_PATH="${HERE}"
exec coqide
EOT
chmod a+x ${APP_ABSDIR}/Contents/MacOS/coqide

# Icons

cp coq/ide/coqide/MacOS/*.icns ${RSRC_ABSDIR}

# Create a link to the 'Applications' folder, so that one can drag and drop the application there

ln -sf /Applications _dmg/Applications

###################### CREATE INSTALLER ######################

##### Create DMG image from folder #####

echo '##### Create DMG image #####'

hdi_opts=(-volname "${DMG_NAME}"
          -srcfolder _dmg
          -ov # overwrite existing file
          -format UDZO
          -imagekey "zlib-level=${ZIPCOMPR}"

          # needed for backward compat since macOS 10.14 which uses APFS by default
          # see discussion in #11803
          -fs hfs+
         )
hdiutil create "${hdi_opts[@]}" "${DMG_NAME}.dmg"

echo "##### Finished installer '${DMG_NAME}.dmg' #####"

##### Simply copy the folder over to the Applications folder #####

if [ "${INSTALL}" == 'Y' ]
then
  echo '##### Copying to /Applications folder #####'
  rm -rf "/Applications/${APP_NAME}"
  cp -r "${APP_ABSDIR}" '/Applications/'
fi
