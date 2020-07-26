#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# GNU Lesser General Public License Version 2.1 or later
# See https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html

# Based on <coq>/dev/build/windows/makecoq_mingw.sh

# (C) 2016..2018 Intel Deutschland GmbH
# Author: Michael Soegtrop
#
# Released to the public by Intel under the
# GNU Lesser General Public License Version 2.1 or later
# See https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html

###################### Script safety and debugging settings ######################

set -o nounset
set -o errexit
set -x
# Print current wall time as part of the xtrace
export PS4='+\t '

# Set this to 1 if all module directories shall be removed before build (no incremental make)
RMDIR_BEFORE_BUILD=1

###################### ARCHITECTURES #####################

# The OS on which the build of the tool/lib runs
BUILD=$(gcc -dumpmachine)

# The OS on which the tool runs
# "`find /bin -name "*mingw32-gcc.exe"`" -dumpmachine
HOST=$TARGET_ARCH

# The OS for which the tool creates code/for which the libs are
TARGET=$TARGET_ARCH

# Cygwin uses different arch name for 32 bit than mingw/gcc
case $ARCH in
  x86_64) CYGWINARCH=x86_64 ;;
  i686)   CYGWINARCH=x86 ;;
  *)      false ;;
esac

###################### PATHS #####################

# Name and create some 'global' folders
PATCHES=/build/patches
BUILDLOGS=/build/buildlogs
FLAGFILES=/build/flagfiles
TARBALLS=/build/tarballs
FILELISTS=/build/filelists
BINSPECIAL=/build/bin_special

mkdir -p $BUILDLOGS
mkdir -p $FLAGFILES
mkdir -p $TARBALLS
mkdir -p $FILELISTS
mkdir -p $BINSPECIAL
cd /build

export PATH=/build/bin_special:$PATH

# Create source cache folder
mkdir -p "$SOURCE_LOCAL_CACHE_CFMT"

# sysroot prefix for the above /build/host/target combination
# This must be in MFMT (C:/.../) because the OCaml library path is based on it and OCaml is a MinGW application.
PREFIXMINGW=$CYGWIN_INSTALLDIR_MFMT/usr/$TARGET_ARCH/sys-root/mingw

mkdir -p "$PREFIXMINGW/bin"

###################### Copy Cygwin Setup Info #####################

# Copy Cygwin repo ini file and installed files db to tarballs folder.
# Both files together document the exact selection and version of cygwin packages.
# Do this as early as possible to avoid changes by other setups (the repo folder is shared).

# Escape URL to folder name
CYGWIN_REPO_FOLDER=${CYGWIN_REPOSITORY}/
CYGWIN_REPO_FOLDER=${CYGWIN_REPO_FOLDER//:/%3a}
CYGWIN_REPO_FOLDER=${CYGWIN_REPO_FOLDER//\//%2f}

# Copy files
cp "$CYGWIN_LOCAL_CACHE_WFMT/$CYGWIN_REPO_FOLDER/$CYGWINARCH/setup.ini" $TARBALLS
cp /etc/setup/installed.db $TARBALLS

###################### LOGGING #####################

# The folder which receives log files
mkdir -p buildlogs
LOGS=$(pwd)/buildlogs

# The current log target (first part of the log file name)
LOGTARGET=other

# For an explanation of ${COQREGTESTING:-N} search for ${parameter:-word} in
# http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html

if [ "${COQREGTESTING:-N}" == "Y" ] ; then
  # If COQREGTESTING, log to log files only
  # Log command output - take log target name from command name (like log1 make => log target is "<module>-make")
  log1() {
    { local -; set +x; } 2> /dev/null
    "$@" >"$LOGS/$LOGTARGET-$1_log.txt"  2>"$LOGS/$LOGTARGET-$1_err.txt"
  }

  # Log command output - take log target name from command name and first argument (like log2 make install => log target is "<module>-make-install")
  log2() {
    { local -; set +x; } 2> /dev/null
    "$@" >"$LOGS/$LOGTARGET-$1-$2_log.txt" 2>"$LOGS/$LOGTARGET-$1-$2_err.txt"
  }

  # Log command output - take log target name from command name and second argument (like log_1_3 ocaml setup.ml -configure => log target is "<module>-ocaml--configure")
  log_1_3() {
    { local -; set +x; } 2> /dev/null
    "$@" >"$LOGS/$LOGTARGET-$1-$3_log.txt" 2>"$LOGS/$LOGTARGET-$1-$3_err.txt"
  }

  # Log command output - log target name is first argument (like logn untar tar xvaf ... => log target is "<module>-untar")
  logn() {
    { local -; set +x; } 2> /dev/null
    LOGTARGETEX=$1
    shift
    "$@" >"$LOGS/$LOGTARGET-${LOGTARGETEX}_log.txt" 2>"$LOGS/$LOGTARGET-${LOGTARGETEX}_err.txt"
  }
else
  # If COQREGTESTING, log to log files and console
  # Log command output - take log target name from command name (like log1 make => log target is "<module>-make")
  log1() {
    { local -; set +x; } 2> /dev/null
    "$@" > >(tee "$LOGS/$LOGTARGET-$1_log.txt" | sed -e "s/^/$LOGTARGET-$1_log.txt: /") 2> >(tee "$LOGS/$LOGTARGET-$1_err.txt" | sed -e "s/^/$LOGTARGET-$1_err.txt: /" 1>&2)
  }

  # Log command output - take log target name from command name and first argument (like log2 make install => log target is "<module>-make-install")
  log2() {
    { local -; set +x; } 2> /dev/null
    "$@" > >(tee "$LOGS/$LOGTARGET-$1-$2_log.txt" | sed -e "s/^/$LOGTARGET-$1-$2_log.txt: /") 2> >(tee "$LOGS/$LOGTARGET-$1-$2_err.txt" | sed -e "s/^/$LOGTARGET-$1-$2_err.txt: /" 1>&2)
  }

  # Log command output - take log target name from command name and second argument (like log_1_3 ocaml setup.ml -configure => log target is "<module>-ocaml--configure")
  log_1_3() {
    { local -; set +x; } 2> /dev/null
    "$@" > >(tee "$LOGS/$LOGTARGET-$1-$3_log.txt" | sed -e "s/^/$LOGTARGET-$1-$3_log.txt: /") 2> >(tee "$LOGS/$LOGTARGET-$1-$3_err.txt" | sed -e "s/^/$LOGTARGET-$1-$3_err.txt: /" 1>&2)
  }

  # Log command output - log target name is first argument (like logn untar tar xvaf ... => log target is "<module>-untar")
  logn() {
    { local -; set +x; } 2> /dev/null
    LOGTARGETEX=$1
    shift
    "$@" > >(tee "$LOGS/$LOGTARGET-${LOGTARGETEX}_log.txt" | sed -e "s/^/$LOGTARGET-${LOGTARGETEX}_log.txt: /") 2> >(tee "$LOGS/$LOGTARGET-${LOGTARGETEX}_err.txt" | sed -e "s/^/$LOGTARGET-${LOGTARGETEX}_err.txt: /" 1>&2)
  }
fi

###################### UTILITY FUNCTIONS #####################

# ------------------------------------------------------------------------------
# Get a source tar ball, expand and patch it
# - get source archive from $SOURCE_LOCAL_CACHE_CFMT or online using wget
# - create build folder
# - extract source archive
# - patch source file if patch exists
#
# Parameters
# $1 file server name including protocol prefix
# $2 file name (without extension)
# $3 file extension
# $4 [optional] number of path levels to strip from tar (usually 1)
# $5 [optional] module name (if different from archive)
# $6 [optional] expand folder name (if different from module name)
# $7 [optional] module base name (used as 2nd choice for patches, defaults to $5)
# ------------------------------------------------------------------------------

function get_expand_source_tar {
  # Handle optional parameters
  if [ "$#" -ge 4 ] ; then
    strip=$4
  else
    strip=1
  fi

  if [ "$#" -ge 5 ] ; then
    name=$5
  else
    name=$2
  fi

  if [ "$#" -ge 6 ] ; then
    folder=$6
  else
    folder=$name
  fi

  if [ "$#" -ge 7 ] ; then
    basename=$7
  else
    basename=$name
  fi

  # Set logging target
  logtargetold=$LOGTARGET
  LOGTARGET=$name

  # Get the source archive either from the source cache or online
  if [ ! -f "$TARBALLS/$name.$3" ] ; then
    if [ -f "$SOURCE_LOCAL_CACHE_CFMT/$name.$3" ] ; then
      cp "$SOURCE_LOCAL_CACHE_CFMT/$name.$3" "$TARBALLS"
    else
      wget --progress=dot:giga "$1/$2.$3"
      if file -i "$2.$3" | grep text/html; then
        echo Download failed: "$1/$2.$3"
        echo The file wget downloaded is an html file:
        cat "$2.$3"
        exit 1
      fi
      if [ ! "$2.$3" == "$name.$3" ] ; then
        mv "$2.$3" "$name.$3"
      fi
      mv "$name.$3" "$TARBALLS"
      # Save the source archive in the source cache
      if [ -d "$SOURCE_LOCAL_CACHE_CFMT" ] ; then
        cp "$TARBALLS/$name.$3" "$SOURCE_LOCAL_CACHE_CFMT"
      fi
    fi
  fi

  # Remove build directory (clean build)
  if [ $RMDIR_BEFORE_BUILD -eq 1 ] ; then
    rm -f -r "$folder"
  fi

  # Create build directory and cd
  mkdir -p "$folder"
  cd "$folder"

  # Extract source archive
  if [ "$3" == "zip" ] ; then
    log1 unzip "$TARBALLS/$name.$3"
    if [ "$strip" == "1" ] ; then
      # move subfolders of root folders one level up
      find "$(ls)" -mindepth 1 -maxdepth 1 -exec mv -- "{}" . \;
    else
      echo "Unzip strip count not supported"
      exit 1
    fi
  else
    logn untar tar xvaf "$TARBALLS/$name.$3" --strip $strip
  fi

  # Patch if patch file exists
  # First try specific patch file name then generic patch file name
  # Note: set -o errexit does not work inside a function called in an if, so exit explicity.
  if [ -f "$PATCHES/$name.patch" ] ; then
    log1 patch -p1 -i "$PATCHES/$name.patch" || exit 1
  elif  [ -f "$PATCHES/$basename.patch" ] ; then
    log1 patch -p1 -i "$PATCHES/$basename.patch" || exit 1
  fi

  # Go back to base folder
  cd ..

  LOGTARGET=$logtargetold
}

# ------------------------------------------------------------------------------
# Prepare a module build
# - check if build is already done (name.finished file exists) - if so return 1
# - create name.started
# - get source archive from $SOURCE_LOCAL_CACHE_CFMT or online using wget
# - create build folder
# - cd to build folder and extract source archive
# - create bin_special subfolder and add it to $PATH
# - remember things for build_post
#
# Parameters
# $1 file server name including protocol prefix
# $2 file name (without extension)
# $3 file extension
# $4 [optional] number of path levels to strip from tar (usually 1)
# $5 [optional] module name (if different from archive)
# $6 [optional] module base name (used as 2nd choice for patches, defaults to $5)
# ------------------------------------------------------------------------------

function build_prep {
  # Handle optional parameters
  if [ "$#" -ge 4 ] ; then
    strip=$4
  else
    strip=1
  fi

  if [ "$#" -ge 5 ] ; then
    name=$5
  else
    name=$2
  fi

  if [ "$#" -ge 6 ] ; then
    basename=$6
  else
    basename=$name
  fi

  # Set installer section to not set by default
  installersection=

  # Check if build is already done
  if [ ! -f "$FLAGFILES/$name.finished" ] ; then
    BUILD_PACKAGE_NAME=$name
    BUILD_OLDPATH=$PATH
    BUILD_OLDPWD=$(pwd)
    LOGTARGET=$name

    touch "$FLAGFILES/$name.started"

    get_expand_source_tar "$1" "$2" "$3" "$strip" "$name" "$name" "$basename"

    cd "$name"

    # Create a folder and add it to path, where we can put special binaries
    # The path is restored in build_post
    mkdir bin_special
    PATH=$(pwd)/bin_special:$PATH

    return 0
  else
    return 1
  fi
}

# ------------------------------------------------------------------------------
# Finalize a module build
# - create name.finished
# - go back to base folder
# ------------------------------------------------------------------------------

function build_post {
  if [ ! -f "$FLAGFILES/$BUILD_PACKAGE_NAME.finished" ]; then
    cd "$BUILD_OLDPWD"
    touch "$FLAGFILES/$BUILD_PACKAGE_NAME.finished"
    PATH=$BUILD_OLDPATH
    LOGTARGET=other
    installer_addon_end
  fi
}

# ------------------------------------------------------------------------------
# Build and install a module using the standard configure/make/make install process
# - prepare build (as above)
# - configure
# - make
# - make install
# - finalize build (as above)
#
# parameters
# $1 file server name including protocol prefix
# $2 file name (without extension)
# $3 file extension
# $4 patch function to call between untar and configure (or true if none)
# $5.. extra configure arguments
# ------------------------------------------------------------------------------

function build_conf_make_inst {
  if build_prep "$1" "$2" "$3" ; then
    $4
    logn configure ./configure --build="$BUILD" --host="$HOST" --target="$TARGET" --prefix="$PREFIXMINGW" "${@:5}"
    # shellcheck disable=SC2086
    log1 make $MAKE_OPT
    log2 make install
    log2 make clean
    build_post
  fi
}

# ------------------------------------------------------------------------------
# Install all files given by a glob pattern to a given folder
#
# parameters
# $1 source path
# $2 pattern (in '')
# $3 target folder
# ------------------------------------------------------------------------------

function install_glob {
  SRCDIR=$(realpath -m $1)
  DESTDIR=$(realpath -m $3)
  ( cd "$SRCDIR" && find . -maxdepth 1 -type f -name "$2" -exec install -D -T  "$SRCDIR"/{} "$DESTDIR"/{} \; )
}

# ------------------------------------------------------------------------------
# Recursively Install all files given by a glob pattern to a given folder
#
# parameters
# $1 source path
# $2 pattern (in '')
# $3 target folder
# ------------------------------------------------------------------------------

function install_rec {
  SRCDIR=$(realpath -m $1)
  DESTDIR=$(realpath -m $3)
  ( cd "$SRCDIR" && find . -type f -name "$2" -exec install -D -T  "$SRCDIR"/{} "$DESTDIR"/{} \; )
}

# ------------------------------------------------------------------------------
# Write a file list of the target folder
# The file lists are used to create file lists for the windows installer
# Don't overwrite an existing file list
#
# parameters
# $1 name of file list
# ------------------------------------------------------------------------------

function list_files {
  if [ ! -e "/build/filelists/$1" ] ; then
    ( cd "$PREFIXCOQ" && find . -type f | sort > /build/filelists/"$1" )
  fi
}

# ------------------------------------------------------------------------------
# Write a file list of the target folder
# The file lists are used to create file lists for the windows installer
# Do overwrite an existing file list
#
# parameters
# $1 name of file list
# ------------------------------------------------------------------------------

function list_files_always {
  ( cd "$PREFIXCOQ" && find . -type f | sort > /build/filelists/"$1" )
}

# ------------------------------------------------------------------------------
# Compute the set difference of two file lists
#
# parameters
# $1 name of list A-B (set difference of set A minus set B)
# $2 name of list A
# $3 name of list B
# ------------------------------------------------------------------------------

function diff_files {
  # See http://www.catonmat.net/blog/set-operations-in-unix-shell/ for file list set operations
  comm -23 <(sort "/build/filelists/$2") <(sort "/build/filelists/$3") > "/build/filelists/$1"
}

# ------------------------------------------------------------------------------
# Filter a list of files with a regular expression
#
# parameters
# $1 name of output file list
# $2 name of input file list
# $3 name of filter regexp
# ------------------------------------------------------------------------------

function filter_files {
  grep -E "$3" "/build/filelists/$2" > "/build/filelists/$1"
}

# ------------------------------------------------------------------------------
# Convert a file list to NSIS installer format
#
# parameters
# $1 name of file list file (output file is the same with extension .nsi)
# ------------------------------------------------------------------------------

function files_to_nsis {
  # Split the path in the file list into path and filename and create SetOutPath and File instructions
  # Note: File /oname cannot be used, because it does not create the paths as SetOutPath does
  # Note: I didn't check if the redundant SetOutPath instructions have a bad impact on installer size or install time
  tr '/' '\\' < "/build/filelists/$1" | sed -r 's/^\.(.*)\\([^\\]+)$/SetOutPath $INSTDIR\\\1\nFile ${COQ_SRC_PATH}\\\1\\\2/' > "/build/filelists/$1.nsh"
}

# ------------------------------------------------------------------------------
# Create an nsis installer addon section
#
# parameters
# $1 identifier of installer section and base name of file list files
# $2 human readable name of section
# $3 description of section
# $4 flags (space separated list of keywords): off = default off
#
# $1 must be a valid NSIS identifier!
# ------------------------------------------------------------------------------

function installer_addon_section {
  installersection=$1
  list_files "addon_pre_$installersection"

  echo 'LangString' "DESC_$1" '${LANG_ENGLISH}' "\"$3\"" >> "/build/filelists/addon_strings.nsh"

  echo '!insertmacro MUI_DESCRIPTION_TEXT' '${'"Sec_$1"'}' '$('"DESC_$1"')' >> "/build/filelists/addon_descriptions.nsh"

  local sectionoptions=
  if [[ "$4" == *off* ]] ; then sectionoptions+=" /o" ; fi

  echo "Section $sectionoptions \"$2\" Sec_$1" >> "/build/filelists/addon_sections.nsh"
  echo 'SetOutPath "$INSTDIR\"' >> "/build/filelists/addon_sections.nsh"
  echo '!include "..\..\..\filelists\addon_'"$1"'.nsh"' >> "/build/filelists/addon_sections.nsh"
  echo 'SectionEnd' >> "/build/filelists/addon_sections.nsh"
}

# ------------------------------------------------------------------------------
# Start an installer addon dependency group
#
# parameters
# $1 identifier of the section which depends on other sections
# The parameters must match the $1 parameter of a installer_addon_section call
# ------------------------------------------------------------------------------

dependencysections=

function installer_addon_dependency_beg {
  installer_addon_dependency "$1"
  dependencysections="$1 $dependencysections"
}

# ------------------------------------------------------------------------------
# End an installer addon dependency group
# ------------------------------------------------------------------------------

function installer_addon_dependency_end {
  set -- $dependencysections
  shift
  dependencysections="$*"
}

# ------------------------------------------------------------------------------
# Create an nsis installer addon dependency entry
# This needs to be bracketed with installer_addon_dependencies_beg/end
#
# parameters
# $1 identifier of the section on which other sections might depend
# The parameters must match the $1 parameter of a installer_addon_section call
# ------------------------------------------------------------------------------

function installer_addon_dependency {
  for section in $dependencysections ; do
    echo '${CheckSectionDependency} ${Sec_'"$section"'} ${Sec_'"$1"'} '"'$section' '$1'" >> "/build/filelists/addon_dependencies.nsh"
  done
}

# ------------------------------------------------------------------------------
# Finish an installer section after an addon build
#
# This creates the file list files
#
# parameters: none
# ------------------------------------------------------------------------------

function installer_addon_end {
  if [ -n "$installersection" ]; then
    list_files "addon_post_$installersection"
    diff_files "addon_$installersection" "addon_post_$installersection" "addon_pre_$installersection"
    files_to_nsis "addon_$installersection"
  fi
}

# ------------------------------------------------------------------------------
# Set all timeouts in all .v files to 1000
# Since timeouts can lead to CI failures, this is useful
#
# parameters: none
# ------------------------------------------------------------------------------

function coq_set_timeouts_1000 {
  find . -type f -name '*.v' -print0 | xargs -0 sed -i 's/timeout\s\+[0-9]\+/timeout 1000/g'
}

###################### MODULE BUILD FUNCTIONS #####################

##### ARCH-pkg-config replacement #####

# cygwin replaced ARCH-pkg-config with a shell script, which doesn't work e.g. for dune on Windows.
# This builds a binary replacement for the shell script and puts it into the bin_special folder.
# This action builds and buts pkg-config in ./bin_special.
# This can be a local folder or a global folder.
# PATH must be set manually accordingly.

function make_arch_pkg_config {
  gcc -DARCH="$TARGET_ARCH" -o bin_special/pkg-config.exe $PATCHES/pkg-config.c
}

##### GTK-SOURCEVIEW3 #####

# Note: the cygwin package is version 3.24.6.1 which has a severe bug in DLL_MAIN
# Whenever a thread is closed, it deletes some global context objects which later leads to crashes

function make_gtk_sourceview3 {
  build_conf_make_inst  https://download.gnome.org/sources/gtksourceview/3.24  gtksourceview-3.24.11  tar.xz  make_arch_pkg_config
}

###################### TOP LEVEL BUILD #####################

### Manually built packages ###

# Build pkg_config globaly
export PATH=/build/bin_special/:$PATH
make_arch_pkg_config

# Cygwin gtksourceview is outdated and has very serious bugs
make_gtk_sourceview3

### Setup opam ###

export OPAMYES=yes
export OPAMCOLOR=never

if [ ! -d "$HOME/.opam" ]
then
  wget https://github.com/fdopen/opam-repository-mingw/releases/download/0.0.0.2/opam64.tar.xz
  tar -xf 'opam64.tar.xz'
  bash opam64/install.sh --prefix /usr/x86_64-w64-mingw32/sys-root/mingw
  which opam
  # Todo: give a nicer name to the switch
  opam init --disable-sandboxing default "https://github.com/fdopen/opam-repository-mingw.git#opam2" -c "ocaml-variants.4.07.1+mingw64c"
  opam repo add default-nowin "https://github.com/ocaml/opam-repository.git" --rank 2 
  opam repo add coq-released "https://coq.inria.fr/opam/released"
  opam repo add coq-core-dev "https://coq.inria.fr/opam/core-dev/"
  opam repo add coq-extra-dev "https://coq.inria.fr/opam/extra-dev/"
  opam repo add platform_patch "file://$CYGWIN_INSTALLDIR_MFMT/build/opam/"
  opam repo list
fi

### Update opam with possible changes in platform_patch ###

opam update platform_patch
opam upgrade

### Install opam packages ###

# lablgtk3 3.1.1 does not link with flexlink
opam pin lablgtk3 3.0.beta5
opam pin coq 8.12.0
opam install coqide
opam install coq-bignums coq-equations menhir coq-coquelicot coq-flocq coq-interval coq-quickchick coq-ext-lib coq-aac-tactics

# The standard set of mathcomp modules
# Plus two generally useful eextensions and their dependency
opam pin coq-mathcomp-ssreflect 1.11.0
opam install \
  coq-mathcomp-algebra \
  coq-mathcomp-character \
  coq-mathcomp-field \
  coq-mathcomp-fingroup \
  coq-mathcomp-solvable \
  \
  coq-mathcomp-real-closed \
  coq-mathcomp-finmap \
  coq-mathcomp-bigenough

# 8.12 incompatible: coq-mtac2 coq-compcert.3.7~coq-platform coq-vst coq-elpi coq-hierarchy-builder
# Failed: coq-menhirlib
# Requires external tools gappa
