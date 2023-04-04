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


case "$COQ_PLATFORM_PARALLEL" in
  [pP]) 
    echo "===== INSTALL PREREQUISITES (PARALLEL) ====="
    $COQ_PLATFORM_TIME opam ${COQ_PLATFORM_OPAM_DEPEXT_COMMAND} ${PACKAGES//PIN.}
    ;;
  [sS]) 
    echo "===== INSTALL PREREQUISITES (SEQUENTIAL) ====="
    for package in ${PACKAGES//PIN.}
    do
      echo PROCESSING $package
      $COQ_PLATFORM_TIME opam ${COQ_PLATFORM_OPAM_DEPEXT_COMMAND} $package
    done
    ;;
  *)
    echo "Illegal value for COQ_PLATFORM_PARALLEL - aborting"
    false
    ;;
esac
