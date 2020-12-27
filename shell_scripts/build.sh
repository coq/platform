#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### BUILD ALL PACKAGES USING OPAM ######################

# This is set by the windows batch file and conflicts with the use of variables e.g. in VST
unset ARCH

opam config set jobs $COQ_PLATFORM_JOBS

case "$COQ_PLATFORM_PARALLEL" in
  [pP]) 
    echo "===== INSTALL OPAM PACKAGES (PARALLEL) ====="
    if ! $COQ_PLATFORM_TIME opam install ${PACKAGES}
    then
      if [ "${COQREGTESTING:-n}" == y ]
      then
        for log in $(opam config var root)/log/*
        do
          echo $log; cat -n $log
        done
      fi
      exit 1
    fi
    ;;
  [sS]) 
    echo "===== INSTALL OPAM PACKAGES (SEQUENTIAL) ====="
    for package in ${PACKAGES}
    do
      if ! $COQ_PLATFORM_TIME opam install ${package}
      then
        if [ "${COQREGTESTING:-n}" == y ]
        then
          for log in $(opam config var root)/log/*
          do
            echo $log; cat -n $log
          done
        fi
        exit 1
      fi
    done
    ;;
  *)
    echo "Illegal value for COQ_PLATFORM_PARALLEL - aborting"
    false
    ;;
esac
