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

source coq_platform_switch_name.sh

export OPAMYES=yes
export OPAMCOLOR=never

###################### PARAMETERS #####################

function print_usage {
cat <<"EOH"
coq_platform_make.sh [options]

Create a new opam switch named $COQ_PLATFORM_SWITCH_NAME
and make and install the Coq platform in this switch.

If an option is not given, the option is explained and asked for interactively.
Except for expert users this is the recommended way to run this script.

OPTIONS:
  -h, -help    Print this help message
  -intro=n     Skip introduction message
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
    -intro=*)    COQ_PLATFORM_INTRO="${arg#*=}";;
    -parallel=*) COQ_PLATFORM_PARALLEL="${arg#*=}";;
    -jobs=*)     COQ_PLATFORM_JOBS="${arg#*=}";;
    -compcert=*) COQ_PLATFORM_COMPCERT="${arg#*=}";;
    -vst=*)      COQ_PLATFORM_VST="${arg#*=}";;
    -switch=*)   COQ_PLATFORM_SWITCH="${arg#*=}";;
    *) echo "ERROR: Unknown command line argument $arg!"; print_usage; false;;
  esac
done

check_value_enumeraton "${COQ_PLATFORM_INTRO:-__unset__}"    "[yn]"  "COQ_PLATFORM_INTRO"
check_value_enumeraton "${COQ_PLATFORM_PARALLEL:-__unset__}" "[ps]"  "-parallel/COQ_PLATFORM_PARALLEL"
check_value_range      "${COQ_PLATFORM_JOBS:-__unset__}"     1 16    "-jobs/COQ_PLATFORM_JOBS"
check_value_enumeraton "${COQ_PLATFORM_COMPCERT:-__unset__}" "[fon]" "-compcert/COQ_PLATFORM_COMPCERT"
check_value_enumeraton "${COQ_PLATFORM_VST:-__unset__}"      "[yn]"  "-vst/COQ_PLATFORM_VST"
check_value_enumeraton "${COQ_PLATFORM_SWITCH:-__unset__}"   "[kd]"  "-switch/COQ_PLATFORM_SWITCH"

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
source shell_scripts/install_opam_depext.sh

###################### INSTALL PREREQUISITES #####################

echo "===== INSTALL PREREQUISITES ====="

source shell_scripts/install_pkg-config.sh
source shell_scripts/install_prerequisites_coqide.sh
source shell_scripts/install_prerequisites_gappa.sh

###################### PACKAGE SELECTION #####################

source coq_platform_packages.sh

###################### BUILD ALL PACKAGES #####################

source shell_scripts/build.sh
