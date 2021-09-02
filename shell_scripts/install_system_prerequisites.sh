#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### INSTALL system prerequisites #####################

# The main purpose of this script is to install all system prerequisites in
# in one go, so that:
# - repeated questions for the sudo password are avoided
# - there are no conflicts between required system packages

echo "===== INSTALL PREREQUISITES ====="

# Install pkg-config upfront - it is required for some of the below checks

if ! command -v pkg-config &> /dev/null
then
  $COQ_PLATFORM_TIME opam ${COQ_PLATFORM_OPAM_DEPEXT_COMMAND} conf-pkg-config
fi

# Collect list of required opam system packages

COQ_PLATFORM_SYSTEM_PACKAGES=''

# System packages required by Coq

if ! pkg-config --short-errors --print-errors gmp
then
  COQ_PLATFORM_SYSTEM_PACKAGES="${COQ_PLATFORM_SYSTEM_PACKAGES} conf-gmp"
fi

# System packages required by CoqIDE

if  [[ "${PACKAGES}"  =~ ' coqide.' ]]
then
  # check if gtk3 is there (CoqIDE)
  if ! pkg-config --short-errors --print-errors --atleast-version 3.18 gtk+-3.0
  then
    COQ_PLATFORM_SYSTEM_PACKAGES="${COQ_PLATFORM_SYSTEM_PACKAGES} conf-gtk3"
  fi

  # check if gtksourceview3 is there (CoqIDE)
  if ! pkg-config --short-errors --print-errors gtksourceview-3.0
  then
    COQ_PLATFORM_SYSTEM_PACKAGES="${COQ_PLATFORM_SYSTEM_PACKAGES} conf-gtksourceview3"
  fi

  # install adwaita-icon-theme if not there (CoqIDE)
  if ! pkg-config --short-errors --print-errors adwaita-icon-theme
  then
    COQ_PLATFORM_SYSTEM_PACKAGES="${COQ_PLATFORM_SYSTEM_PACKAGES} conf-adwaita-icon-theme"
  fi
fi

# System packages required by Gappa

if  [[ "${PACKAGES}"  =~ ' gappa.' ]]
then
  # there is no good way to ask for the gappa prerequisites, so we check if gappa itself is already installed
  if [ $(opam var "gappa:installed") == "false" ]
  then
    COQ_PLATFORM_SYSTEM_PACKAGES="${COQ_PLATFORM_SYSTEM_PACKAGES} gappa"
  fi
fi

if [ -n "${COQ_PLATFORM_SYSTEM_PACKAGES}" ]
then
  echo "opam system pre-requisites to install: ${COQ_PLATFORM_SYSTEM_PACKAGES}"
  $COQ_PLATFORM_TIME opam ${COQ_PLATFORM_OPAM_DEPEXT_COMMAND} ${COQ_PLATFORM_SYSTEM_PACKAGES}
fi
