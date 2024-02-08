#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020..2022 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CONTROL VARIABLES #####################

# The two lines below are used by the package selection script
COQ_PLATFORM_VERSION_TITLE="Coq 8.19.0 (released Jan 2024)"
COQ_PLATFORM_VERSION_SORTORDER=98

# The package list name is the final part of the opam switch name.
# It is usually either empty ot starts with ~.
# It might also be used for installer package names, but with ~ replaced by _
# It is also used for version specific file selections in the smoke test kit.
COQ_PLATFORM_PACKAGE_PICK_POSTFIX='~8.19-lsp'

# The corresponding Coq development branch and tag
COQ_PLATFORM_COQ_BRANCH='v8.19'
COQ_PLATFORM_COQ_TAG='8.19.0'

# This controls if opam repositories for development packages are selected
COQ_PLATFORM_USE_DEV_REPOSITORY='N'

# This extended descriptions is used for readme files
COQ_PLATFORM_VERSION_DESCRIPTION='This version of Coq Platform 2024.01.0 includes Coq 8.19.0 from Jan 2024. '

# The OCaml version to use for this pick (just the version number - options are elaborated in a platform dependent way)
COQ_PLATFORM_OCAML_VERSION='4.14.1'

###################### PACKAGE SELECTION #####################

PACKAGES=""

# - Comment out packages you do not want.
# - Packages which take a long time to build should be given last.
#   There is some evidence that they are built early then.
# - Versions ending with ~flex are identical to the opam package without the
#   ~flex extension, except that version restrictions have been relaxed.
# - The picking tracker issue is https://github.com/coq/platform/issues/193

########## BASE PACKAGES ##########

# Coq needs a patched ocamlfind to be relocatable by installers
PACKAGES="${PACKAGES} PIN.ocamlfind.1.9.5~relocatable"  # TODO port patch to 1.9.6
# Since dune does support Coq, it is explicitly selected
PACKAGES="${PACKAGES} dune.3.11.1"
PACKAGES="${PACKAGES} dune-configurator.3.10.0"
# The Coq compiler coqc and the Coq standard library
PACKAGES="${PACKAGES} PIN.coq.8.19.0"

########## Coq Language Server ##########
PACKAGES="${PACKAGES} coq-serapi.8.19.0+0.19.0"
PACKAGES="${PACKAGES} coq-lsp.0.1.8+8.19"

########## IDE PACKAGES ##########

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[iIfFxX] ]]
then
PACKAGES="${PACKAGES} coqide.8.19.0"
fi

########## "FULL" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[fFxX] ]]
then
  # Standard library extensions
  PACKAGES="${PACKAGES} coq-bignums.9.0.0+coq8.19"
  PACKAGES="${PACKAGES} coq-ext-lib.0.12.0"
  #PACKAGES="${PACKAGES} coq-stdpp.1.9.0" does not build

  # General mathematics
  PACKAGES="${PACKAGES} coq-mathcomp-ssreflect.2.2.0"
  PACKAGES="${PACKAGES} coq-mathcomp-fingroup.2.2.0"
  PACKAGES="${PACKAGES} coq-mathcomp-algebra.2.2.0"
  PACKAGES="${PACKAGES} coq-mathcomp-solvable.2.2.0"
  PACKAGES="${PACKAGES} coq-mathcomp-field.2.2.0"
  PACKAGES="${PACKAGES} coq-mathcomp-character.2.2.0"
  PACKAGES="${PACKAGES} coq-mathcomp-bigenough.1.0.1"
  PACKAGES="${PACKAGES} coq-mathcomp-finmap.2.1.0"
  PACKAGES="${PACKAGES} coq-mathcomp-real-closed.2.0.0"
  PACKAGES="${PACKAGES} coq-mathcomp-zify.1.5.0+2.0+8.16"
  PACKAGES="${PACKAGES} coq-mathcomp-multinomials.2.2.0"
  PACKAGES="${PACKAGES} coq-coquelicot.3.4.1"

  # Number theory
  # PACKAGES="${PACKAGES} coq-coqprime.1.4.0"
  # PACKAGES="${PACKAGES} coq-coqprime-generator.1.1.1" #NOTE:THIS IS STILL TAGGED TO v8.14.1, SHOULD SOMETHING BE DONE?

  # Numerical mathematics
  # PACKAGES="${PACKAGES} coq-flocq.4.1.4"
  #PACKAGES="${PACKAGES} coq-interval.4.9.0" #DOES NOT BUILD
  #PACKAGES="${PACKAGES} coq-gappa.1.5.4" #DOES NOT BUILD
  # PACKAGES="${PACKAGES} gappa.1.4.1"

  # Constructive mathematics
  #PACKAGES="${PACKAGES} coq-math-classes.8.18.0" #DOES NOT BUILD
  #PACKAGES="${PACKAGES} coq-corn.8.18.0" #DOES NOT BUILD

  # Homotopy Type Theory (HoTT)
  # PACKAGES="${PACKAGES} coq-hott.8.18"

  # Code extraction
  PACKAGES="${PACKAGES} coq-simple-io.1.8.0"

  # Proof automation / generation / helpers
  # PACKAGES="${PACKAGES} coq-menhirlib.20231231 menhir.20231231"
  PACKAGES="${PACKAGES} coq-equations.1.3+8.19"
  PACKAGES="${PACKAGES} coq-aac-tactics.8.19.0"

  PACKAGES="${PACKAGES} elpi.1.18.1 coq-elpi.2.0.1"
  PACKAGES="${PACKAGES} coq-hierarchy-builder.1.7.0"

  # BROKEN in CI
  # PACKAGES="${PACKAGES} coq-quickchick.2.0.2"

  PACKAGES="${PACKAGES} coq-paramcoq.1.1.3+coq8.19"
  PACKAGES="${PACKAGES} coq-coqeal.2.0.1"
  PACKAGES="${PACKAGES} coq-libhyps.2.0.8"
  # BROKEN in CI
  # PACKAGES="${PACKAGES} coq-itauto.8.19.0"

  # General mathematics (which requires one of the above tools)
  PACKAGES="${PACKAGES} coq-mathcomp-analysis.1.0.0"
  PACKAGES="${PACKAGES} coq-mathcomp-algebra-tactics.1.2.3"

fi
