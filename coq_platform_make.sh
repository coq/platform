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

OPAM_SWITCH_NAME=_coq-platform_.8.12.0.alpha3test

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

echo "===== UPDATE OPAM REPOSITORIES ====="

if [ ! -f "$HOME/.opam_update_timestamp" ] || [ $(find "$HOME/.opam_update_timestamp" -mmin +60 -print) ]
then
  opam update
  touch "$HOME/.opam_update_timestamp"
else
  opam update "patch$OPAM_SWITCH_NAME"
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

PACKAGES=""

PACKAGES="${PACKAGES} coq.8.12.0"

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
PACKAGES="${PACKAGES} coq-interval.4.0.0"
PACKAGES="${PACKAGES} coq-hierarchy-builder.0.10.0"
PACKAGES="${PACKAGES} coq-menhirlib.20200624 menhir.20200624"
PACKAGES="${PACKAGES} coq-quickchick.1.4.0"

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
if [ ! -z ${COQPLATFORM_NONOPEN+x} ]
then
  # Todo: there is no mutex between coq platform and coq platform open source
  PACKAGES="${PACKAGES} coq-compcert.3.7+8.12~coq_platform"
else
  PACKAGES="${PACKAGES} coq-compcert.3.7+8.12~coq_platform~open_source"
fi
PACKAGES="${PACKAGES} coq-vst.2.6"

###################### TOP LEVEL BUILD #####################

echo "===== INSTALL OPAM PACKAGES ====="

# This conflicts with the use of variables e.g. in VST
unset ARCH

# Note: it is more efficient to install all modules in parallel
# opam can then make best use of parallelism
# In case you run into memory issues, it is better to do this sequentially
opam install ${PACKAGES}

# 8.12 incompatible: coq-mtac2
# Requires external tools gappa
