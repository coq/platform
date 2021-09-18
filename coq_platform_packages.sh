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

PACKAGES="coq.dev"

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[iIfF] ]]
then
PACKAGES="${PACKAGES} coqide.dev lablgtk3.3.1.1 lablgtk3-sourceview3.3.1.1"
fi

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[fF] ]]
then

# Some generally useful packages
PACKAGES="${PACKAGES} coq-unicoq.dev"
PACKAGES="${PACKAGES} coq-ext-lib.dev"
PACKAGES="${PACKAGES} coq-equations.dev"
PACKAGES="${PACKAGES} coq-bignums.dev"
PACKAGES="${PACKAGES} coq-aac-tactics.dev"
PACKAGES="${PACKAGES} coq-mtac2.dev"
PACKAGES="${PACKAGES} coq-simple-io.dev"
PACKAGES="${PACKAGES} coq-quickchick.dev"

# Analysis and numerics
PACKAGES="${PACKAGES} coq-flocq.3.dev"
PACKAGES="${PACKAGES} coq-coquelicot.dev"
PACKAGES="${PACKAGES} coq-gappa.dev"
# Disabled - does not compile currently
# PACKAGES="${PACKAGES} coq-interval.dev"

# Elpi, Coq-elpi and hierarchy builder
PACKAGES="${PACKAGES} coq-elpi.dev"
PACKAGES="${PACKAGES} coq-hierarchy-builder.dev"

# The standard set of mathcomp modules
PACKAGES="${PACKAGES} coq-mathcomp-ssreflect.dev"
PACKAGES="${PACKAGES} coq-mathcomp-fingroup.dev"
PACKAGES="${PACKAGES} coq-mathcomp-algebra.dev"
PACKAGES="${PACKAGES} coq-mathcomp-solvable.dev"
PACKAGES="${PACKAGES} coq-mathcomp-field.dev"
PACKAGES="${PACKAGES} coq-mathcomp-character.dev"
# Plus a few extra mathcomp modules
PACKAGES="${PACKAGES} coq-mathcomp-bigenough.dev"
PACKAGES="${PACKAGES} coq-mathcomp-finmap.dev"
PACKAGES="${PACKAGES} coq-mathcomp-real-closed.dev"

# Menhir, CompCert and Princeton VST - these take longer to compile !
PACKAGES="${PACKAGES} coq-menhirlib.dev menhir.dev"
# Todo: there is no mutex between coq platform and coq platform open source
case "$COQ_PLATFORM_COMPCERT" in
  [fF]) PACKAGES="${PACKAGES} coq-compcert.dev" ;;
  [oO]) "The open source variant of CompCert is notsupp orted in the master/dev branch"; exit 1 ;;
  [nN]) true ;;
  *) echo "Illegal value for COQ_PLATFORM_COMPCERT - aborting"; false ;;
esac

# case "$COQ_PLATFORM_VST" in
#   [yY]) PACKAGES="${PACKAGES} coq-vst.dev" ;;
#   [nN]) true ;;
#   *) echo "Illegal value for COQ_PLATFORM_VST - aborting"; false ;;
# esac

fi

# Note: there is some experimental evidence that the in a parallel build
# package given last is tried to build first (after its dependencies).
# Since VST takes longest, give it last.
