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

source shell_scripts/init_safety_debug.sh
source shell_scripts/init_paths.sh
source shell_scripts/init_utilities.sh

###################### SYSTEM SANITY CHECKS #####################

source shell_scripts/check_system.sh
source shell_scripts/check_compiler.sh

###################### USER CHOICES #####################

# NOTE: These choices can be skipped by
# setting the environment variables tested in the scripts

source shell_scripts/ask_introduction.sh
source shell_scripts/ask_parallel_build.sh
source shell_scripts/ask_compcert_open_source.sh
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

# HINT: comment packages you do not want

echo "===== SELECT OPAM PACKAGES ====="

PACKAGES="coq.8.12.0"

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
# Note: lablgtk3 3.1.1 does not link with flexlink on MinGW
PACKAGES="${PACKAGES} coqide.8.12.0 lablgtk3.3.0.beta5"

# Some generally useful quick to compile packages
PACKAGES="${PACKAGES} coq-aac-tactics.8.12.0"
PACKAGES="${PACKAGES} coq-bignums.8.12.0"
PACKAGES="${PACKAGES} coq-coquelicot.3.1.0"
PACKAGES="${PACKAGES} coq-elpi.1.5.1 elpi.1.11.4"
PACKAGES="${PACKAGES} coq-equations.1.2.3+8.12"
PACKAGES="${PACKAGES} coq-ext-lib.0.11.2"
PACKAGES="${PACKAGES} coq-flocq.3.3.1"
PACKAGES="${PACKAGES} coq-gappa.1.4.4 gappa.1.3.5"
PACKAGES="${PACKAGES} coq-hierarchy-builder.0.10.0"
PACKAGES="${PACKAGES} coq-interval.4.0.0"
PACKAGES="${PACKAGES} coq-menhirlib.20200624 menhir.20200624"
PACKAGES="${PACKAGES} coq-mtac2.1.3+8.12"
PACKAGES="${PACKAGES} coq-quickchick.1.4.0"
PACKAGES="${PACKAGES} coq-unicoq.1.5+8.12"

# The standard set of mathcomp modules
PACKAGES="${PACKAGES} coq-mathcomp-ssreflect.1.11.0"
PACKAGES="${PACKAGES} coq-mathcomp-algebra.1.11.0"
PACKAGES="${PACKAGES} coq-mathcomp-character.1.11.0"
PACKAGES="${PACKAGES} coq-mathcomp-field.1.11.0"
PACKAGES="${PACKAGES} coq-mathcomp-fingroup.1.11.0"
PACKAGES="${PACKAGES} coq-mathcomp-solvable.1.11.0"
# Plus two generally useful eextensions and their dependency
PACKAGES="${PACKAGES} coq-mathcomp-real-closed.1.1.1"
PACKAGES="${PACKAGES} coq-mathcomp-finmap.1.5.0"
PACKAGES="${PACKAGES} coq-mathcomp-bigenough.1.0.0"

# CompCert and Princeton VST - these take longer to compile !
if [ "$COQ_PLATFORM_COMPCERT" == "f" ]
then
  # Todo: there is no mutex between coq platform and coq platform open source
  PACKAGES="${PACKAGES} coq-compcert.3.7+8.12~coq_platform"
else
  PACKAGES="${PACKAGES} coq-compcert.3.7+8.12~coq_platform~open_source"
fi
PACKAGES="${PACKAGES} coq-vst.2.6"

# Note: there is some experimental evidence that the in a parallel build
# package given last is tried to build first (after its dependencies).
# Since VST takes longest, give it last.

###################### BUILD ALL PACKAGES #####################

source shell_scripts/build.sh
