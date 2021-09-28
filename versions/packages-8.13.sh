#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020..2021 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CONTROL VARIABLES #####################

# The two lines below are used by the package selection script
# DESCRIPTION Coq 8.13.2 04/2021 with updated/extended package pick 09/2021
# SORTORDER 1

# The package list name is the final part of the opam switch name.
# It is usually either empty ot starts with ~.
# It might also be used for installer package names, but with ~ replaced by _
# It is also used for version specific file selections in the smoke test kit.
COQ_PLATFORM_PACKAGELIST_NAME='~8.13'

# The corresponding Coq development branch and tag
COQ_PLATFORM_COQ_BRANCH='v8.13'
COQ_PLATFORM_COQ_TAG='8.13.2'

# This controls if opam repositories for development packages are selected
COQ_PLATFORM_USE_DEV_REPOSITORY='N'

###################### PACKAGE SELECTION #####################

PACKAGES=""

# - Comment out packages you do not want.
# - Packages with system dependencies should be given first.
#   This avoids multiple sudo password requests
# - Packages which take a long time to build should be given last.
#   There is some evidence that they are built early then.
# - The picking is as much as possible identical to the 8.14 picking
#   discussed in https://github.com/coq/platform/issues/139,
#   except for choosing 8.13 instead of 8.14 packages where applicable.
#   Exceptions are noted in comments below.

########## BASE PACKAGES ##########

# Build tools - this is selected early to avoid the version is changed later
# and everything has to be recompiled.
PACKAGES="${PACKAGES} dune.2.9.1"

# The Coq compiler coqc and the Coq standard library
PACKAGES="${PACKAGES} coq.8.13.2"

########## IDE PACKAGES ##########

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[iIfFxX] ]]
then
  PACKAGES="${PACKAGES} coqide.8.13.2 lablgtk3.3.1.1"
fi

########## "FULL" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[fFxX] ]]
then

  # General standard library extensions 
  PACKAGES="${PACKAGES} coq-bignums.8.13.0"
  PACKAGES="${PACKAGES} coq-ext-lib.0.11.4"
  PACKAGES="${PACKAGES} coq-stdpp.1.5.0"

  # General mathematics
  PACKAGES="${PACKAGES} coq-mathcomp-ssreflect.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-fingroup.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-algebra.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-solvable.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-field.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-character.1.12.0"
  PACKAGES="${PACKAGES} coq-mathcomp-bigenough.1.0.0"
  PACKAGES="${PACKAGES} coq-mathcomp-finmap.1.5.1"
  PACKAGES="${PACKAGES} coq-mathcomp-real-closed.1.1.2"
  PACKAGES="${PACKAGES} coq-coquelicot.3.2.0"

  # Number theory
  PACKAGES="${PACKAGES} coq-coqprime.1.0.6"

  # Numerical mathematics
  PACKAGES="${PACKAGES} coq-interval.4.3.0"
  PACKAGES="${PACKAGES} coq-flocq.3.4.2"
  PACKAGES="${PACKAGES} coq-gappa.1.5.0 gappa.1.4.0"

  # Constructive mathematics
  PACKAGES="${PACKAGES} coq-math-classes.8.13.0"
  PACKAGES="${PACKAGES} coq-corn.8.13.0"

  # Homotopy Type Theory (HoTT)
  PACKAGES="${PACKAGES} coq-hott.8.13"

  # Proof automation / generation / helpers
  PACKAGES="${PACKAGES} coq-equations.1.2.3+8.13"
  PACKAGES="${PACKAGES} coq-aac-tactics.8.13.0"
  PACKAGES="${PACKAGES} coq-unicoq.1.5+8.13"
  PACKAGES="${PACKAGES} coq-mtac2.1.4+8.13"
  PACKAGES="${PACKAGES} coq-elpi.1.11.1 elpi.1.13.7" # Note: coq-elpi 1.11.2 is >=8.14
  PACKAGES="${PACKAGES} coq-hierarchy-builder.1.2.0"
  PACKAGES="${PACKAGES} coq-quickchick.1.5.1"
  PACKAGES="${PACKAGES} coq-hammer-tactics.1.3.1+8.13"
  PACKAGES="${PACKAGES} coq-paramcoq.1.1.3+coq8.13"
  PACKAGES="${PACKAGES} coq-coqeal.1.0.6"
  PACKAGES="${PACKAGES} coq-libhyps.2.0.2"

  # Formal languages, compilers and code verification
  PACKAGES="${PACKAGES} coq-menhirlib.20210419 menhir.20210419"
  PACKAGES="${PACKAGES} coq-reglang.1.1.2"
  PACKAGES="${PACKAGES} coq-iris.3.4.0"
  PACKAGES="${PACKAGES} coq-iris-heap-lang.3.4.0"

  case "$COQ_PLATFORM_COMPCERT" in
    [yY]) PACKAGES="${PACKAGES} coq-compcert.3.9" ;;
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_COMPCERT - aborting"; false ;;
  esac

  case "$COQ_PLATFORM_VST" in
    [yY]) PACKAGES="${PACKAGES} coq-vst.2.8" ;;
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_VST - aborting"; false ;;
  esac

  # Code extraction
  PACKAGES="${PACKAGES} coq-simple-io.1.5.0"

fi

########## EXTENDED" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[xX] ]]
then

  # General mathematics
  PACKAGES="${PACKAGES} coq-mathcomp-analysis.0.3.10"
  PACKAGES="${PACKAGES} coq-mathcomp-multinomials.1.5.4"

  # Proof automation / generation / helpers
  PACKAGES="${PACKAGES} coq-deriving.0.1.0"

  # Gallina extensions
  PACKAGES="${PACKAGES} coq-reduction-effects.0.1.2"
  PACKAGES="${PACKAGES} coq-record-update.0.3.0"

  # Proof analysis and other tools
  PACKAGES="${PACKAGES} coq-dpdgraph.0.6.9"
  PACKAGES="${PACKAGES} coq-coq2html.1.2"

fi