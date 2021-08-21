#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### PACKAGE SELECTION #####################

# HINT: Comment packages you do not want

# ATTENTION: The packages are given in an oeder so that dependencies are built
#            first - important fo sequential builds!

PACKAGES="coq.8.15.0.dev"

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[iIfF] ]]
then
PACKAGES="${PACKAGES} coqide.8.15.0.dev lablgtk3.3.1.1"
fi

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[fF] ]]
then

# Some generally useful packages
PACKAGES="${PACKAGES} coq-unicoq.1.5+8.13"
PACKAGES="${PACKAGES} coq-ext-lib.0.11.3"
PACKAGES="${PACKAGES} coq-equations.1.2.3+8.13"
PACKAGES="${PACKAGES} coq-bignums.8.13.0"
PACKAGES="${PACKAGES} coq-aac-tactics.8.13.0"
PACKAGES="${PACKAGES} coq-mtac2.1.4+8.13"
PACKAGES="${PACKAGES} coq-simple-io.1.5.0"
PACKAGES="${PACKAGES} coq-quickchick.1.5.0"

# Homotopy Type Theory (HoTT)
PACKAGES="${PACKAGES} coq-hott.8.13"

# Analysis and numerics
PACKAGES="${PACKAGES} coq-flocq.3.3.1"
PACKAGES="${PACKAGES} coq-coquelicot.3.1.0"
PACKAGES="${PACKAGES} coq-gappa.1.4.6 gappa.1.3.5"
PACKAGES="${PACKAGES} coq-interval.4.1.1"

# Elpi, Coq-elpi and hierarchy builder
PACKAGES="${PACKAGES} coq-elpi.1.8.1 elpi.1.12.0"
PACKAGES="${PACKAGES} coq-hierarchy-builder.1.0.0"

# The standard set of mathcomp modules
PACKAGES="${PACKAGES} coq-mathcomp-ssreflect.1.12.0"
PACKAGES="${PACKAGES} coq-mathcomp-fingroup.1.12.0"
PACKAGES="${PACKAGES} coq-mathcomp-algebra.1.12.0"
PACKAGES="${PACKAGES} coq-mathcomp-solvable.1.12.0"
PACKAGES="${PACKAGES} coq-mathcomp-field.1.12.0"
PACKAGES="${PACKAGES} coq-mathcomp-character.1.12.0"
# Plus a few extra mathcomp modules
PACKAGES="${PACKAGES} coq-mathcomp-bigenough.1.0.0"
PACKAGES="${PACKAGES} coq-mathcomp-finmap.1.5.1"
PACKAGES="${PACKAGES} coq-mathcomp-real-closed.1.1.2"

# Menhir, CompCert and Princeton VST - these take longer to compile !
PACKAGES="${PACKAGES} coq-menhirlib.20200624 menhir.20200624"
# Todo: there is no mutex between coq platform and coq platform open source
case "$COQ_PLATFORM_COMPCERT" in
  [fF]) PACKAGES="${PACKAGES} coq-compcert.3.8" ;;
  [oO]) echo "The open source variant of CompCert is not supported in 2021.02.1"; exit 1 ;;
  [nN]) true ;;
  *) echo "Illegal value for COQ_PLATFORM_COMPCERT - aborting"; false ;;
esac

case "$COQ_PLATFORM_VST" in
  [yY]) PACKAGES="${PACKAGES} coq-vst.2.7.1" ;;
  [nN]) true ;;
  *) echo "Illegal value for COQ_PLATFORM_VST - aborting"; false ;;
esac

fi

# Note: there is some experimental evidence that the in a parallel build
# package given last is tried to build first (after its dependencies).
# Since VST takes longest, give it last.
