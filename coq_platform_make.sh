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

if [ ! -z ${COQPLATFORM_VERBOSE+x} ]
then
  set -x
  # Print current wall time as part of the xtrace
  export PS4='+\t '
fi

# Set this to 1 if all module directories shall be removed before build (no incremental make)
RMDIR_BEFORE_BUILD=1

###################### PARAMETER #####################

OPAM_SWITCH_NAME=_coq-platform_.8.12.0.alpha2

###################### ARCHITECTURES #####################

if [[ "$OSTYPE" == linux-gnu* ]]
then
    echo "Linux '$OSTYPE' detected"
    # On Linux, BUILD, HOST and TARGET are the same
    BUILD="$(gcc -dumpmachine)"
    HOST="$BUILD"
    TARGET="$BUILD"
    BUILDROOT="$HOME/coq-platform"
elif [[ "$OSTYPE" == darwin* ]]
then
    echo "OSX '$OSTYPE' detected"
    # On OSX, BUILD, HOST and TARGET are the same
    BUILD="$(gcc -dumpmachine)"
    HOST="$BUILD"
    TARGET="$BUILD"
    BUILDROOT="$HOME/coq-platform"
elif [[ "$OSTYPE" == cygwin ]]
then
    echo "Cygwin '$OSTYPE' detected"

    # check environment
    if [[ "$TARGET_ARCH" == "" ]]
    then
      echo "ERROR: TARGET_ARCH not set"
      exit 1
    fi
    if [[ "$ARCH" == "" ]]
    then
      echo "ERROR: ARCH not set"
      exit 1
    fi

    # The OS on which the build of the tool/lib runs
    BUILD=$(gcc -dumpmachine)

    # The OS on which the tool runs
    # $(find /bin -name "*mingw32-gcc.exe") -dumpmachine
    HOST=$TARGET_ARCH

    # The OS for which the tool creates code/for which the libs are
    TARGET=$TARGET_ARCH

    # Since the cygwin is especially setup for building coq-platform, we build in the global folder /build
    BUILDROOT="/build"

    # sysroot prefix for the above /build/host/target combination
    PREFIX=$(cygpath -m /)/usr/$TARGET/sys-root/mingw
    mkdir -p "$PREFIX/bin"

    # Cygwin uses different arch name for 32 bit than mingw/gcc
    case $ARCH in
      x86_64) CYGWINARCH=x86_64 ;;
      i686)   CYGWINARCH=x86 ;;
      *)      false ;;
    esac

    # The cygwin installation is missing a compiled schema for GTK (dialog resources and the like), so create it
    # Todo: this should be fixed upstream by a post install script
    glib-compile-schemas $PREFIX/share/glib-2.0/schemas/
else
    echo "ERROR: unsopported OS type '$OSTYPE'"
    exit 1
fi

###################### PATHS #####################

# The folder of this script
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Folders used by this shell script (on Windows this mean cygwin) only
BUILDLOGS="$BUILDROOT/buildlogs"
FLAGFILES="$BUILDROOT/flagfiles"
PATCHES="$BUILDROOT/patches"
TARBALLS="$BUILDROOT/tarballs"

# On Windows/Cygwin BINSPECIAL is used via PATH in MinGW programs, but cygwin takes care of adjusting PATH when calling non cygwin executables
# MinGW path format would not work for BINSPECIAL because it contains C: and posix PATH variables use : as separator
BINSPECIAL="$BUILDROOT/bin_special"

# On Windows/Cygwin OPAMPACKAGES is passed to MinGW opam, so it must be in MinGW format
if [[ "$OSTYPE" == cygwin ]]
then
  OPAMPACKAGES="$(cygpath -m "$SCRIPTDIR/opam")"
else
  OPAMPACKAGES="$SCRIPTDIR/opam"
fi

# Set SOURCECACHE only if it is not yet set
: "${SOURCECACHE:=$BUILDROOT/source_cache}"

mkdir -p "$BUILDROOT"
mkdir -p "$BUILDLOGS"
mkdir -p "$FLAGFILES"
mkdir -p "$BINSPECIAL"
mkdir -p "$PATCHES"
mkdir -p "$TARBALLS"
mkdir -p "$SOURCECACHE"
mkdir -p "$OPAMPACKAGES"
cd "$BUILDROOT"

export PATH="$BINSPECIAL":$PATH

###################### Copy Cygwin Setup Info #####################

# Copy Cygwin repo ini file and installed files db to tarballs folder.
# Both files together document the exact selection and version of cygwin packages.
# Do this as early as possible to avoid changes by other setups (the repo folder is shared).

# Escape URL to folder name
# CYGWIN_REPO_FOLDER=${CYGWIN_REPOSITORY}/
# CYGWIN_REPO_FOLDER=${CYGWIN_REPO_FOLDER//:/%3a}
# CYGWIN_REPO_FOLDER=${CYGWIN_REPO_FOLDER//\//%2f}

# Copy files
# cp "$CYGWIN_LOCAL_CACHE_WFMT/$CYGWIN_REPO_FOLDER/$CYGWINARCH/setup.ini" $TARBALLS
# cp /etc/setup/installed.db $TARBALLS

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
# Convert a version string in A.B.C.D format to a comparable number
# - the version string may have up to 4 components
# - each component may have up to 2 digits
#
# Parameters
# $1 version string
# ------------------------------------------------------------------------------

function version_to_number {
  printf "%d%02d%02d%02d" $(echo "$1" | tr '.' ' ');
}

# ------------------------------------------------------------------------------
# Check if a command is available
#
# Parameters
# $1 command ro check for, e.g. gcc, clang, curl
# ------------------------------------------------------------------------------

function check_command_available {
  if ! command -v "$1" &> /dev/null
  then
    echo "This script requires command '$1' to be installed."
    echo "Please install this command manually using your system's package manager!"
    exit 1
  fi
}

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
    if [ -f "$SOURCECACHE/$name.$3" ] ; then
      cp "$SOURCECACHE/$name.$3" "$TARBALLS"
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
      if [ -d "$SOURCECACHE" ] ; then
        cp "$TARBALLS/$name.$3" "$SOURCECACHE"
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
    logn configure ./configure --build="$BUILD" --host="$HOST" --target="$TARGET" --prefix="$PREFIX" "${@:5}"
    # shellcheck disable=SC2086
    log1 make $MAKE_OPT
    log2 make install
    log2 make clean
    build_post
  fi
}

###################### INSTALL OPAM #####################

# Note: use help <builtin> to get information on bash builtin commands like "command"

if ! command -v opam &> /dev/null
then
  echo "===== INSTALLING OPAM ====="
  if [[ "$OSTYPE" == linux-gnu* ]]
  then
    # On Linux use the opam install script - Linux has too many variants.
    check_command_available curl
    sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
  elif [[ "$OSTYPE" == darwin* ]]
  then
    # On macOS if a package manager is installed, use it - otherwise use the opam install script.
    # The advantage of using a package manager is that opam is updated automatically.
    if command -v port &> /dev/null
    then
      sudo port install opam
    elif command -v brew &> /dev/null
    then
      brew install opam
    else
      check_command_available curl
      sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
    fi
  elif [[ "$OSTYPE" == cygwin ]]
  then
    # Assume we want MinGW cross - this requires a special opam
    wget https://github.com/fdopen/opam-repository-mingw/releases/download/0.0.0.2/opam64.tar.xz
    tar -xf 'opam64.tar.xz'
    bash opam64/install.sh --prefix /usr/x86_64-w64-mingw32/sys-root/mingw
  else
      echo "ERROR: unsopported OS type '$OSTYPE'"
      exit 1
  fi
  echo "OPAM is now $(command -v opam) with version $(opam --version)"
else
  echo "===== CHECKING VERSION OF INSTALLED OPAM ====="
  # Note: on some OSes 2.0.5 is the latest available version and I am not aware that this does not work.
  # The script is mostly tested with opam 2.0.7
  # See https://opam.ocaml.org/doc/Install.html
  if [ $(version_to_number $(opam --version)) -lt $(version_to_number 2.0.5) ]
  then
    echo "Your installed opam version $(opam --version) is older than 2.0.5."
    echo "This version of opam is not supported."
    echo "If you ininstall opam, this script will install the latest version."
    exit 1
  else
    echo "Found opam $(opam --version) - good!"
  fi
fi

which opam

###################### INITIALIZE OPAM #####################

export OPAMYES=yes
export OPAMCOLOR=never

if ! opam var root &> /dev/null
then
  echo "===== INITIALIZING OPAM ====="
  if [[ "$OSTYPE" == cygwin ]]
  then
    # Init opam with windows specific default repo
    opam init --bare --shell-setup --enable-shell-hook --enable-completion --disable-sandboxing default 'https://github.com/fdopen/opam-repository-mingw.git#opam2'
  else
    opam init --bare --shell-setup --enable-shell-hook --enable-completion
  fi
else
  echo "===== opam already initialized ====="
fi

###################### CREATE OPAM SWITCH #####################

if ! opam switch $OPAM_SWITCH_NAME 2>/dev/null
then
  echo "===== CREATE OPAM SWITCH ====="
  if [[ "$OSTYPE" == cygwin ]]
  then
    opam switch create $OPAM_SWITCH_NAME 'ocaml-variants.4.07.1+mingw64c'
    opam repo add default-nowin "https://github.com/ocaml/opam-repository.git" --rank 2 
  else
    opam switch create $OPAM_SWITCH_NAME 'ocaml-base-compiler.4.07.1'
  fi
  opam repo add coq-released "https://coq.inria.fr/opam/released" || true
  opam repo add coq-core-dev "https://coq.inria.fr/opam/core-dev" || true
  opam repo add coq-extra-dev "https://coq.inria.fr/opam/extra-dev" || true
  # This repo shall always be specific to this switch - if it exists, fail
  opam repo add "patch$OPAM_SWITCH_NAME" "file://$OPAMPACKAGES"
else
  echo "===== opam switch already exists ====="
fi

###################### SELECT OPAM SWITCH #####################

opam switch $OPAM_SWITCH_NAME
eval $(opam env)

echo === OPAM REPOSITORIES ===
opam repo list
echo === OPAM PACKAGES ===
opam list

# Cleanup old build artifacts for current switch ###
# Note: this frequently proved to be required (build errors when doing experiments)
# Note: this keeps downloads and logs

opam clean --switch-cleanup

###################### Update opam ######################

opam update

###################### PREREQUISITES #####################

echo "===== INSTALLING PREREQUISITES ====="

# Install opam's extenral dependency manager depext
opam install depext

if [ "$OSTYPE" == cygwin ]
then
  # This is an executable replacement for the cygwin pkg-config shell script
  opam install dep-pkg-config-mingw
else

# Note: for each depext package we check upfront if it is there.
# This has the advantage that all stuff requring sudo is at the begining.
# Usually running one sudo command upfront is enough to keep the password for 15 minutes.

# install pkg-config if it is not there
if ! command -v pkg-config &> /dev/null
then
  opam depext conf-pkg-config
fi

# install gtk3 if not there
if ! pkg-config --short-errors --print-errors --atleast-version 3.18 gtk+-3.0
then
  opam depext conf-gtk3
fi

# install gtksourceview3 if not there
if ! pkg-config --short-errors --print-errors gtksourceview-3.0
then
  opam depext conf-gtksourceview3
fi

# install adwaita-icon-theme if not there
if ! pkg-config --short-errors --print-errors adwaita-icon-theme
then
  opam depext conf-gnome-icon-theme3
fi

###################### TOP LEVEL BUILD #####################

echo "===== INSTALLING OPAM PACKAGES ====="

### Install opam packages ###

# This conflicts with the use of variables e.g. in VST
unset ARCH

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

opam pin coq-menhirlib 20200624

opam install coq-compcert.3.7+8.12~coq_platform~open_source
opam install coq-vst.2.6

# 8.12 incompatible: coq-mtac2 coq-elpi coq-hierarchy-builder
# Requires external tools gappa
