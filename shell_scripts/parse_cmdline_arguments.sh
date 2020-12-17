#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

function print_usage {
cat <<"EOH"
coq_platform_make.sh [options]

Create a new opam switch named $COQ_PLATFORM_SWITCH_NAME
and make and install the Coq platform in this switch.

If an option is not given, the option is explained and asked for interactively.
Except for expert users this is the recommended way to run this script.

OPTIONS:
  -h, -help    Print this help message
  -extent=p    Setup opam and build full Coq platform
  -extent=c    Just setup opam and build Coq
  -extent=i    Just setup opam and build Coq+CoqIDE
  -parallel=p  Build several opam packages in parallel
  -parallel=s  Build opam packages sequentially
  -jobs=1..16  Number of make threads per package
  -compcert=f  Build full non-free version of CompCert
  -compcert=o  Build only open source part of CompCert
  -compcert=n  Do not build CompCert and VST
  -vst=y       Build Verified Software Toolchain (takes a while)
  -vst=n       Do not build Verified Software Toolchain
  -switch=k    In case the opam switch already exists, keep it
  -switch=d    In case the opam switch already exists, delete it
EOH
}

for arg in "$@"
do
  case "$arg" in
    -help|-h)    print_usage; false;;
    -extent=*)   COQ_PLATFORM_EXTENT="${arg#*=}";;
    -parallel=*) COQ_PLATFORM_PARALLEL="${arg#*=}";;
    -jobs=*)     COQ_PLATFORM_JOBS="${arg#*=}";;
    -compcert=*) COQ_PLATFORM_COMPCERT="${arg#*=}";;
    -vst=*)      COQ_PLATFORM_VST="${arg#*=}";;
    -switch=*)   COQ_PLATFORM_SWITCH="${arg#*=}";;
    *) echo "ERROR: Unknown command line argument $arg!"; print_usage; false;;
  esac
done

check_value_enumeraton "${COQ_PLATFORM_EXTENT:-__unset__}"   "[fbi]" "-extent/COQ_PLATFORM_EXTENT"
check_value_enumeraton "${COQ_PLATFORM_PARALLEL:-__unset__}" "[ps]"  "-parallel/COQ_PLATFORM_PARALLEL"
check_value_range      "${COQ_PLATFORM_JOBS:-__unset__}"     1 16    "-jobs/COQ_PLATFORM_JOBS"
check_value_enumeraton "${COQ_PLATFORM_COMPCERT:-__unset__}" "[fon]" "-compcert/COQ_PLATFORM_COMPCERT"
check_value_enumeraton "${COQ_PLATFORM_VST:-__unset__}"      "[yn]"  "-vst/COQ_PLATFORM_VST"
check_value_enumeraton "${COQ_PLATFORM_SWITCH:-__unset__}"   "[kd]"  "-switch/COQ_PLATFORM_SWITCH"
