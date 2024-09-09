#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### BUILD ALL PACKAGES USING OPAM ######################

# This is set by the windows batch file and conflicts with the use of variables e.g. in VST
unset ARCH

function dump_opam_logs {
  if [ "${COQ_PLATFORM_DUMP_LOGS:-n}" == "y" ]
  then
    for log in $(opam config var root)/log/*
    do
      echo "==============================================================================="
      echo $log
      echo "==============================================================================="
      cat -n $log
    done
  fi
  return 1
}

opam config set jobs $COQ_PLATFORM_JOBS

# coq-fiat-crypto requires this - it sets the maximum stack size to 64MB
# Note that on MacOS the absolute maximum is ulimit -S -s 65520
# One can rise it as root on MacOS, but only for a root shell, not for the current shell
ulimit -S -s 65520

if ! $COQ_PLATFORM_TIME opam pin -n ocamlfind 1.9.5~relocatable; then dump_opam_logs; fi

if [[ "$OSTYPE" == cygwin ]]
then
    if ! $COQ_PLATFORM_TIME opam pin -n opam-client 2.1.0; then dump_opam_logs; fi # opam-clinet 2.2.0 doesn't want to compile on Windows
fi

if [[ "$OSTYPE" != cygwin ]]
then
    if ! $COQ_PLATFORM_TIME opam pin -n z3 4.11.2; then dump_opam_logs; fi # Installing z3 later will cause Tactician to be recompiled
    if ! $COQ_PLATFORM_TIME opam install z3; then dump_opam_logs; fi
fi

if ! $COQ_PLATFORM_TIME opam pin -n dune 3.15.3; then dump_opam_logs; fi
if ! $COQ_PLATFORM_TIME opam pin -n coq-tactician-dummy 8.17.dev; then dump_opam_logs; fi
if ! $COQ_PLATFORM_TIME opam pin -n coq-tactician 8.18.dev; then dump_opam_logs; fi
if ! $COQ_PLATFORM_TIME opam pin -n coq-core 8.18.0; then dump_opam_logs; fi
if ! $COQ_PLATFORM_TIME opam install dune coq-core coq-tactician-dummy coq-tactician ocamlfind; then dump_opam_logs; fi

opam switch
opam switch set ${COQ_PLATFORM_SWITCH_NAME}
opam switch
eval $(opam env --set-switch --switch ${COQ_PLATFORM_SWITCH_NAME})
opam switch

opam exec -- tactician inject

case "$COQ_PLATFORM_PARALLEL" in
    [pP]) 
        echo "===== INSTALL OPAM PACKAGES (PARALLEL) ====="
        if ! $COQ_PLATFORM_TIME opam install ${PACKAGES//PIN.}; then dump_opam_logs; fi
        for package in ${PACKAGES}
    do
      case $package in
      PIN.*)
        echo PINNING $package
        package_name="$(echo "$package" | cut -d '.' -f 2)"
        package_version="$(echo "$package" | cut -d '.' -f 3-)"
        if ! $COQ_PLATFORM_TIME opam pin --no-action ${package_name} ${package_version}; then dump_opam_logs; fi
        ;;
      esac
    done
    ;;
  [sS]) 
    echo "===== INSTALL OPAM PACKAGES (SEQUENTIAL) ====="
    for package in ${PACKAGES}
    do
      echo PROCESSING $package
      case $package in
      PIN.*)
        echo PROCESSING 1 $package
        package_name="$(echo "$package" | cut -d '.' -f 2)"
        package_version="$(echo "$package" | cut -d '.' -f 3-)"
        if ! $COQ_PLATFORM_TIME opam pin ${package_name} ${package_version}; then dump_opam_logs; fi
        ;;
      *)
        echo PROCESSING 2 $package
        if ! $COQ_PLATFORM_TIME opam install ${package}; then dump_opam_logs; fi
        ;;
      esac
    done
    ;;
  *)
    echo "Illegal value for COQ_PLATFORM_PARALLEL - aborting"
    false
    ;;
esac
