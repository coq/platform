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
  if [[ "$OSTYPE" == linux* ]]
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
    # We want MinGW cross - this requires a special opam
    wget https://github.com/fdopen/opam-repository-mingw/releases/download/0.0.0.2/opam$BITSIZE.tar.xz -O "opam$BITSIZE.tar.xz"
    tar -xf "opam$BITSIZE.tar.xz"
    bash opam$BITSIZE/install.sh --prefix "/usr/$(uname -m)-w64-mingw32/sys-root/mingw"
  else
      echo "ERROR: unsopported OS type '$OSTYPE'"
      return 1
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
    return 1
  else
    echo "Found opam $(opam --version) - good!"
  fi
fi

which opam

###################### CHECK SYSTEM SANDBOX VERSION #####################

ENABLE_SANDOX=Y
COQ_PLATFORM_OPAM_INIT_EXTRA=""

if [[ "$OSTYPE" == linux* ]]
then
  if ! command -v bwrap &> /dev/null
  then
    echo "========================= BUBBLEWRAP SYSTEM SANDBOX ========================="
    echo "You do not have the sandbox system 'bubblewrap' installed."
    ENABLE_SANDOX=N
  else
    # This is the bwrap version on Ununtu 18.04 LTS, which seems to work
    if [ $(version_to_number $(bwrap --version | cut -f 2 -d ' ')) -lt $(version_to_number 0.2.1) ]
    then
      echo "========================= BUBBLEWRAP SYSTEM SANDBOX ========================="
      echo "Your version of the sandbox system 'bubblewrap' is too old."
      echo "You have version $(bwrap --version | cut -f 2 -d ' ') but we need at least 0.2.1"
      ENABLE_SANDOX=N
    fi
  fi
  if [ $ENABLE_SANDOX == N ]
  then
cat <<EOH

Updating or installing the bubblewrap sandbox on your system might be
difficult. Opam uses bubblewrap to make sure that make files access their
clocal build folders only, so that a gone wild "cd .. && rm -rf" in a
"make clean" does not erase your home folder. This is an extra sefety measure
and it is not strictly required. You have probably run "make" in some open
source software build folder before without using a sandbox. Opam has this
extra measure because it runs a lot of builds for many software packages,
which increases the risk.
You can either cancel and try to install or upgrade bubblewrap to at least
version 0.2.1, or you can run opam without sandbox.
========================= BUBBLEWRAP SYSTEM SANDBOX =========================
EOH
    ask_user_opt1_cancel "Disable sandbox (d) or cancel (c)?" dD "dsiable sandbox"
    COQ_PLATFORM_OPAM_INIT_EXTRA=--disable-sandboxing
  fi
fi

###################### INITIALIZE OPAM #####################

if ! opam var root &> /dev/null
then
  echo "===== INITIALIZING OPAM ====="
  if [[ "$OSTYPE" == cygwin ]]
  then
    # Init opam with windows specific default repo
    opam init --bare --shell-setup --enable-shell-hook --enable-completion --disable-sandboxing default 'https://github.com/fdopen/opam-repository-mingw.git#opam2'
  else
    opam init --bare --shell-setup --enable-shell-hook --enable-completion $COQ_PLATFORM_OPAM_INIT_EXTRA
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
    if [ "`uname -m`" = "x86_64" ]; then
      COQ_PLATFORM_OCAML_VERSION="ocaml-variants.4.07.1+mingw64c"
    else
      COQ_PLATFORM_OCAML_VERSION="ocaml-variants.4.07.1+mingw32c"
    fi
  else
    COQ_PLATFORM_OCAML_VERSION='ocaml-base-compiler.4.07.1'
  fi
  # Register switch specific repo
  # This repo shall always be specific to this switch - so delete it if it exists
  $COQ_PLATFORM_TIME opam repo remove --all "patch$COQ_PLATFORM_SWITCH_NAME" || true
  $COQ_PLATFORM_TIME opam repo add --dont-select "patch$COQ_PLATFORM_SWITCH_NAME" "file://$OPAMPACKAGES"

  # Add the Coq repo - not a repo can be added many times as long as the URL is the same
  $COQ_PLATFORM_TIME opam repo add --dont-select coq-released "https://coq.inria.fr/opam/released"

  # Create switch with the patch repo registered right away in case we need to patch OCaml
  $COQ_PLATFORM_TIME opam switch create $COQ_PLATFORM_SWITCH_NAME $COQ_PLATFORM_OCAML_VERSION --repositories="patch$COQ_PLATFORM_SWITCH_NAME",coq-released,default
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

###################### HACK OPAM ARCHITECTURE ON 32 BIT CYGWIN #####################

# Note: opam running on 32 bit cygwin on 64 bit windows has arch x86_64

if [ "$OSTYPE" == cygwin ] && [ "$BITSIZE" == 32 ] && [ "$(opam var arch)" != i686 ]
then
  conf_file="$(opam var prefix)"/.opam-switch/switch-config
  # Search for "variables {", print it, print an additional variable assignment and continue with next line
  # For everything else (condition 1) do the default action of print $0
  awk '/^variables \{/ {print $0; print "  arch: \"i686\""; next} 1' "$conf_file" > "$conf_file.tmp"
  mv "$conf_file.tmp" "$conf_file"
fi

###################### Update opam ######################

echo "===== UPDATE OPAM REPOSITORIES ====="

if [ ! -f "$HOME/.opam_update_timestamp" ] || [ $(find "$HOME/.opam_update_timestamp" -mmin +60 -print) ]
then
  $COQ_PLATFORM_TIME opam update
  touch "$HOME/.opam_update_timestamp"
else
  $COQ_PLATFORM_TIME opam update "patch$COQ_PLATFORM_SWITCH_NAME"
fi

