#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### SCRIPT INITIALIZATION #####################

cd "$(dirname "$0")"
source shell_scripts/init_safety_debug.sh
source shell_scripts/init_paths.sh
source shell_scripts/init_utilities.sh

###################### SETTINGS #####################

COQ_PLATFORM_VERSION=8.12.0.alpha3
COQ_PLATFORM_SWITCH_NAME=_coq-platform_.$COQ_PLATFORM_VERSION

export OPAMYES=yes
export OPAMCOLOR=never

###################### PARAMETERS #####################

function print_usage {
cat <<"EOH"
coq_platform_make.sh [options]

Create a new opam switch named $COQ_PLATFORM_SWITCH_NAME
and make and install the Coq platform in this switch.

If no options are given each option is explained and asked for interactively.
Except for expert users this is the recommended way to run this script.

OPTIONS:
  -h                     Print this help message
  --help                 Print this help message
  --no-intro             Skip introduction message
  --parallel=p           Build several opam packages in parallel
  --parallel=s           Build opam packages sequentially
  --parallel-jobs=1..16  Number of make threads per package
  --compcert=f           Build full non-free version of CompCert
  --compcert=o           Build only open source part of CompCert
  --compcert=n           Do not build CompCert and VST
  --vst=y                Build Verified Software Toolchain
  --vst=n                Do not build Verified Software Toolchain
  --keep=k               In case the opam switch already exists, keep it
  --keep=d               In case the opam switch already exists, delete it

All argument values can be expressive values, say --compcert=open_source
as long as the first letter matches.
EOH
}

for arg in "$@"
do
  case "$arg" in
    --help|-h)         print_usage; false;;
    --no-intro)        COQ_PLATFORM_INTRO=n;;
    --parallel=*)      COQ_PLATFORM_PARALLEL="${arg#*=}";;
    --parallel-jobs=*) COQ_PLATFORM_PARALLEL_JOBS="${arg#*=}";;
    --compcert=*)      COQ_PLATFORM_COMPCERT="${arg#*=}";;
    --vst=*)           COQ_PLATFORM_VST="${arg#*=}";;
    --keep=*)          COQ_PLATFORM_SWITCH_KEEP="${arg#*=}";;
    *) echo "ERROR: Unknown command line argument $arg!"; print_usage; false;;
  esac
done

check_value_enumeraton "${COQ_PLATFORM_INTRO:-__unset__}"         "[yn]*"  "COQ_PLATFORM_INTRO"
check_value_enumeraton "${COQ_PLATFORM_PARALLEL:-__unset__}"      "[ps]*"  "--parallel/COQ_PLATFORM_PARALLEL"
check_value_range      "${COQ_PLATFORM_PARALLEL_JOBS:-__unset__}" 1 16     "--parallel-jobs/COQ_PLATFORM_PARALLEL_JOBS"
check_value_enumeraton "${COQ_PLATFORM_COMPCERT:-__unset__}"      "[fon]*" "--compcert/COQ_PLATFORM_COMPCERT"
check_value_enumeraton "${COQ_PLATFORM_VST:-__unset__}"           "[yn]*"  "--vst/COQ_PLATFORM_VST"
check_value_enumeraton "${COQ_PLATFORM_SWITCH_KEEP:-__unset__}"   "[kd]*"  "--keep/COQ_PLATFORM_SWITCH_KEEP"

###################### SYSTEM SANITY CHECKS #####################

source shell_scripts/check_system.sh
source shell_scripts/check_compiler.sh

###################### USER CHOICES #####################

# NOTE: These choices can be skipped by setting the environment variables
#       tested in the scripts.

# NOTE: If you comment some questions for a custom setup, please assign
#       the variable set in the script a default value.

source shell_scripts/ask_introduction.sh
source shell_scripts/ask_parallel_build.sh
source shell_scripts/ask_compcert_open_source.sh
source shell_scripts/ask_vst.sh
source shell_scripts/ask_delete_opam_switch.sh

###################### INSTALL/INIT OPAM #####################

source shell_scripts/install_opam.sh
source shell_scripts/check_opam_sandbox.sh

###################### INSTALL PREREQUISITES #####################

echo "===== INSTALL PREREQUISITES ====="

source shell_scripts/install_pkg-config.sh
source shell_scripts/install_prerequisites_coqide.sh
source shell_scripts/install_prerequisites_gappa.sh

###################### PACKAGE SELECTION #####################

source coq_platform_packages.sh

###################### BUILD ALL PACKAGES #####################

source shell_scripts/build.sh
