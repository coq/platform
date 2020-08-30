#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

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

COQ_PLATFORM_VERSION=8.12.0.alpha3
COQ_PLATFORM_SWITCH_NAME=_coq-platform_.$COQ_PLATFORM_VERSION

###################### PATHS #####################

# The folder of this script
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ "$OSTYPE" == cygwin ]]
then
  OPAMPACKAGES=$(cygpath -ma "$SCRIPTDIR/opam")
else
  OPAMPACKAGES="$SCRIPTDIR/opam"
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
# Ask a y/cacnel question
#
# $1 message
# ------------------------------------------------------------------------------

function ask_user_yes_cancel {
  while true; do
    read -p "$1 (y/c + enter) " answer
    case $answer in
        [Yy]* ) ANSWER=Y; return 0 ;;
        [Cc]* ) exit 1 ;;
        * ) echo "Please answer 'y' or 'c' to cancel/exit.";;
    esac
  done
}

# ------------------------------------------------------------------------------
# Ask a y/n/cancel question
#
# $1 message
# ------------------------------------------------------------------------------

function ask_user_yes_no_cancel {
  while true; do
    read -p "$1 (y/n/c + enter) " answer
    case $answer in
        [Yy]* ) ANSWER=Y; return 0 ;;
        [Nn]* ) ANSWER=N; return 0 ;;
        [Cc]* ) exit 1 ;;
        * ) echo "Please answer 'y' or 'n' or 'c' to cancel/exit.";;
    esac
  done
}

# ------------------------------------------------------------------------------
# Ask for a number
#
# $1 message
# $2 lower
# $3 upper
# ------------------------------------------------------------------------------

function ask_user_mumber {
  while true; do
    read -p "$1 (number in $2..$3) " answer
    if [ "$2" -le "$answer" ] && [ "$answer" -le "$3" ]
    then
      ANSWER="$answer"
      return 0
    else
      "Please enter a number between $2 and $3"
    fi
  done
}

# ------------------------------------------------------------------------------
# Determine the total and available RAM in kbyte
#
# results are stored in MEM_TOTAL and MEM_AVAIL
# ------------------------------------------------------------------------------

function get_memory_info {
  if [[ "$OSTYPE" == linux-gnu* ]]
  then
      echo "TODO: unimplemented"
    exit 1
  elif [[ "$OSTYPE" == darwin* ]]
  then
    MEM_TOTAL=$(echo $(sysctl hw.memsize | awk '{print $2}') / 1024 | bc)
    MEM_AVAIL=$(echo '(' $(sysctl vm.page_free_count | awk '{print $2}') '+' $(sysctl vm.page_speculative_count | awk '{print $2}') ') * 4' | bc)
  elif [[ "$OSTYPE" == cygwin ]]
  then
      echo "TODO: unimplemented"
    exit 1
  else
      echo "ERROR: unsopported OS type '$OSTYPE'"
      exit 1
  fi
}

###################### User choices #####################

# NOTE: These choices can be skipped by setting the environment variables

# introduction

if [ ! "${COQ_PLATFORM_INTRO:-Y}" = "N" ]
then
cat <<EOH
============================== 1/3 INTRODUCTION ==============================
This script installs the Coq platform version $COQ_PLATFORM_VERSION, that is:

- the Coq compiler and Coq's standard library
- CoqIDE, a GTK3 based graphical user interface
- various widely used libraries and plugins

The script uses opam, the OCaml package manager, to do all the work.
In case opam is not yet installed, it will install opam.
A new opam switch named $COQ_PLATFORM_SWITCH_NAME will be created.

The script compiles everything from sources, which might takes less than one
hour on a fast machine with lot's of RAM, or several hours with little RAM.

The script is tested on these platforms:
- Windows 10 with cygwin installed by coq_platform_make_windows.bat
- macOS Catalina 10.15.4
- Ubuntu 18.04 LTS
In case you have issues, please report a bug at:
https://github.com/MSoegtropIMC/coq-platform/issues
============================== 1/3 INTRODUCTION ==============================
EOH
ask_user_yes_cancel "Continue with compiling and installing the Coq platform?"
fi

# parallel or sequential build

if [ -z "${COQ_PLATFORM_PARALLEL:+x}" ]
then
cat <<EOH
============================= 2/3 PARALLEL BUILD =============================
The Coq platform opam build has two levels of parallelism:

- parallel build of (independent) opam packages
- parallel build inside the make of each opam package

Since a single coqc call can take more than 1 GB of RAM and since the two
above kinds of parallelism multiply, the total amount of memory can be large.
But it is not as bad as one might expect: test show that a full parallel
build takes less than 14GB of RAM with 15 parallel make jobs.

With 32 GB or RAM a parallel package build with 16 make jobs is recommended.
With 16 GB of RAM a parallel package build with 4 make jobs is recommended.
With 8 GB of RAM a sequential package build with 4 make jobs is recommended.
With 4 GB+1GB swap a sequential packahge build with 1 make job is recommended.
With less RAM, you might have to remove failing packages, e.g. VST.
In order to remove packages, just edit this script at "PACKAGE SELECTION".

In case these recommendations don't work for you, please report an issue at:
https://github.com/MSoegtropIMC/coq-platform/issues
============================= 2/3 PARALLEL BUILD =============================
EOH
  ask_user_yes_no_cancel "Build opam packages parallel (y) or sequential (n)?"
  COQ_PLATFORM_PARALLEL=$ANSWER
  ask_user_mumber "Number of parallel make jobs" 1 16
  COQ_PLATFORM_PARALLEL_JOBS=$ANSWER
fi

# CompCert open source or full

if [ -z "${COQ_PLATFORM_COMPCERT_FULL:+x}" ]
then
cat <<EOH
================================ 3/3 COMPCERT ================================
The Coq platform installs the formally verified C compiler CompCert.

CompCert is *not* free / open source software, but may be used for research and
evaluation purposes. Please clarify the license at:

https://github.com/AbsInt/CompCert/blob/master/LICENSE

Parts of CompCert are required for the Princeton C verification tool VST.
Some parts of CompCert are open source and for exploring or learning VST
using the supplied example programs, this open source part is sufficient.
If you want to use VST with your own C code, you need the non open source
variant of CompCert. before you install the full version of CompCert,
please make sure that your intended usage conforms to the above license.

You can also change this later using opam commands.
================================ 3/3 COMPCERT ================================
EOH
  ask_user_yes_no_cancel "Install full (y) or open source (n) version of CompCert?"
  COQ_PLATFORM_COMPCERT_FULL=$ANSWER
fi

# Delete opam switch

if command -v opam &> /dev/null && opam switch $COQ_PLATFORM_SWITCH_NAME >/dev/null 2>&1
then
cat <<EOH
================================ OPAM SWITCH =================================
The Coq platform creates the opam switch $COQ_PLATFORM_SWITCH_NAME.

Apparently this switch already exists. It is recommended to delete the switch,
so that you get a clean and well defined result.

For incremental builds after a failure, e.g. cause of RAM size issues, it is
no problem to keep the switch.
================================ OPAM SWITCH =================================
EOH
  ask_user_yes_no_cancel "Shall the existing switch be kept (y) or deleted (n) ?"
  if $ANSWER == N
  then
    opam switch remove $COQ_PLATFORM_SWITCH_NAME
  fi
fi

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

if ! opam switch $COQ_PLATFORM_SWITCH_NAME 2>/dev/null
then
  echo "===== CREATE OPAM SWITCH ====="
  if [[ "$OSTYPE" == cygwin ]]
  then
    opam switch create $COQ_PLATFORM_SWITCH_NAME 'ocaml-variants.4.07.1+mingw64c'
    opam repo add default-nowin "https://github.com/ocaml/opam-repository.git" --rank 2 
  else
    opam switch create $COQ_PLATFORM_SWITCH_NAME 'ocaml-base-compiler.4.07.1'
  fi
  opam repo add coq-released "https://coq.inria.fr/opam/released" || true
  # This repo shall always be specific to this switch - if it exists, fail
  opam repo add "patch$COQ_PLATFORM_SWITCH_NAME" "file://$OPAMPACKAGES"
else
  echo "===== opam switch already exists ====="
fi

###################### SELECT OPAM SWITCH #####################

opam switch $COQ_PLATFORM_SWITCH_NAME
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

echo "===== UPDATE OPAM REPOSITORIES ====="

if [ ! -f "$HOME/.opam_update_timestamp" ] || [ $(find "$HOME/.opam_update_timestamp" -mmin +60 -print) ]
then
  opam update
  touch "$HOME/.opam_update_timestamp"
else
  opam update "patch$COQ_PLATFORM_SWITCH_NAME"
fi

###################### PREREQUISITES #####################

echo "===== INSTALL PREREQUISITES ====="

# Install opam's extenral dependency manager depext
opam install depext

if [ "$OSTYPE" == cygwin ]
then
  # This is an executable replacement for the cygwin pkg-config shell script
  opam install dep-pkg-config-mingw
fi

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

###################### PACKAGE SELECTION #####################

# Uncomment packages you do not want

echo "===== SELECT OPAM PACKAGES ====="

PACKAGES="coq.8.12.0"

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
# Note: lablgtk3 3.1.1 does not link with flexlink on MinGW
PACKAGES="${PACKAGES} coqide.8.12.0 lablgtk3.3.0.beta5"

# Some generally useful quick to compile packages
PACKAGES="${PACKAGES} coq-aac-tactics.8.12.0"
PACKAGES="${PACKAGES} coq-bignums.8.12.0"
PACKAGES="${PACKAGES} coq-coquelicot.3.1.0"
PACKAGES="${PACKAGES} coq-elpi.1.5.1 elpi.1.11.4"
PACKAGES="${PACKAGES} coq-equations.1.2.3+8.12"
PACKAGES="${PACKAGES} coq-ext-lib.0.11.2"
PACKAGES="${PACKAGES} coq-flocq.3.3.1"
PACKAGES="${PACKAGES} coq-gappa.1.4.4 gappa.1.3.5"
PACKAGES="${PACKAGES} coq-hierarchy-builder.0.10.0"
PACKAGES="${PACKAGES} coq-interval.4.0.0"
PACKAGES="${PACKAGES} coq-menhirlib.20200624 menhir.20200624"
PACKAGES="${PACKAGES} coq-mtac2.1.3+8.12"
PACKAGES="${PACKAGES} coq-quickchick.1.4.0"
PACKAGES="${PACKAGES} coq-unicoq.1.5+8.12"

# The standard set of mathcomp modules
PACKAGES="${PACKAGES} coq-mathcomp-ssreflect.1.11.0"
PACKAGES="${PACKAGES} coq-mathcomp-algebra.1.11.0"
PACKAGES="${PACKAGES} coq-mathcomp-character.1.11.0"
PACKAGES="${PACKAGES} coq-mathcomp-field.1.11.0"
PACKAGES="${PACKAGES} coq-mathcomp-fingroup.1.11.0"
PACKAGES="${PACKAGES} coq-mathcomp-solvable.1.11.0"
# Plus two generally useful eextensions and their dependency
PACKAGES="${PACKAGES} coq-mathcomp-real-closed.1.1.1"
PACKAGES="${PACKAGES} coq-mathcomp-finmap.1.5.0"
PACKAGES="${PACKAGES} coq-mathcomp-bigenough.1.0.0"

# CompCert and Princeton VST
# These take longer to compile !
if [ "$COQ_PLATFORM_COMPCERT_FULL" == "Y" ]
then
  # Todo: there is no mutex between coq platform and coq platform open source
  PACKAGES="${PACKAGES} coq-compcert.3.7+8.12~coq_platform"
else
  PACKAGES="${PACKAGES} coq-compcert.3.7+8.12~coq_platform~open_source"
fi
PACKAGES="${PACKAGES} coq-vst.2.6"

# Note: there is some experimental evidence that the package given last is tried to build first
# (after its dependencies). Since VST takes longest, give it last.

###################### TOP LEVEL BUILD #####################

# This conflicts with the use of variables e.g. in VST
unset ARCH

opam config set jobs $COQ_PLATFORM_PARALLEL_JOBS

if [ "$COQ_PLATFORM_PARALLEL" == "Y" ]
then
  echo "===== INSTALL OPAM PACKAGES (PARALLEL) ====="
  opam install ${PACKAGES}
else
  echo "===== INSTALL OPAM PACKAGES (SEQUENTIAL) ====="
  for package in ${PACKAGES}
  do
    opam install ${package}
  done
fi

