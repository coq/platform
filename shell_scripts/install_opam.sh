#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### INSTALL OPAM #####################

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
    $COQ_PLATFORM_TIME opam switch create $COQ_PLATFORM_SWITCH_NAME 'ocaml-variants.4.07.1+mingw64c'
    $COQ_PLATFORM_TIME opam repo add default-nowin "https://github.com/ocaml/opam-repository.git" --rank 2 
  else
    $COQ_PLATFORM_TIME opam switch create $COQ_PLATFORM_SWITCH_NAME 'ocaml-base-compiler.4.07.1'
  fi
  $COQ_PLATFORM_TIME opam repo add coq-released "https://coq.inria.fr/opam/released" || true
  # This repo shall always be specific to this switch - if it exists, fail
  $COQ_PLATFORM_TIME opam repo add "patch$COQ_PLATFORM_SWITCH_NAME" "file://$OPAMPACKAGES"
  touch "$HOME/.opam_update_timestamp"
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
  $COQ_PLATFORM_TIME opam update
  touch "$HOME/.opam_update_timestamp"
else
  $COQ_PLATFORM_TIME opam update "patch$COQ_PLATFORM_SWITCH_NAME"
fi

