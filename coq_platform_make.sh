#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### PARAMETER / SETTINGS #####################

COQ_PLATFORM_VERSION=8.12.0.alpha3
COQ_PLATFORM_SWITCH_NAME=_coq-platform_.$COQ_PLATFORM_VERSION

export OPAMYES=yes
export OPAMCOLOR=never

###################### SCRIPT INITIALIZATION #####################

cd "$(dirname "$0")"
source shell_scripts/init_safety_debug.sh
source shell_scripts/init_paths.sh
source shell_scripts/init_utilities.sh

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
