#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CONTROL VARIABLES #####################

# The two lines below are used by the package selection script
COQ_PLATFORM_VERSION_TITLE="Coq 8.13.2 (released Apr 2021) with the first package pick from Feb 2021"
COQ_PLATFORM_VERSION_SORTORDER=5

# The package list name is the final part of the opam switch name.
# It is usually either empty ot starts with ~.
# It might also be used for installer package names, but with ~ replaced by _
# It is also used for version specific file selections in the smoke test kit.
COQ_PLATFORM_PACKAGE_PICK_POSTFIX='~8.13~2021.02'

# The corresponding Coq development branch and tag
COQ_PLATFORM_COQ_BRANCH='v8.13'
COQ_PLATFORM_COQ_TAG='8.13.2'

# This controls if opam repositories for development packages are selected
COQ_PLATFORM_USE_DEV_REPOSITORY='N'

# This extended descriptions is used for readme files
COQ_PLATFORM_VERSION_DESCRIPTION='This version of Coq Platform 2023.03.1 includes Coq 8.13.2 from 04/2021. '
COQ_PLATFORM_VERSION_DESCRIPTION+='There are three package picks for Coq 8.13.2: the original from 02/2021, a substantially extended one from 09/2021 and an updated one from 11/2021. '
COQ_PLATFORM_VERSION_DESCRIPTION+='This is the original package pick for Coq 8.13 from 02/2021. '
COQ_PLATFORM_VERSION_DESCRIPTION+='The 02/2021 and 09/2021 package picks are provided for compatibility and it is recommended to use the 11/2021 pick - or Coq 8.14.0.'

# The OCaml version to use for this pick (just the version number - options are elaborated in a platform dependent way)
COQ_PLATFORM_OCAML_VERSION='4.10.2'

###################### PACKAGE SELECTION #####################

# - Comment out packages you do not want.
# - Packages which take a long time to build should be given last.
#   There is some evidence that they are built early then.

PACKAGES="PIN.coq.8.13.2"

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[iIfFxX] ]]
then
PACKAGES="${PACKAGES} coqide.8.13.2 lablgtk3.3.1.1"
fi

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[fFxX] ]]
then

# Some generally useful packages
PACKAGES="${PACKAGES} coq-unicoq.1.5+8.13"
PACKAGES="${PACKAGES} coq-ext-lib.0.11.3"
PACKAGES="${PACKAGES} coq-equations.1.2.3+8.13"
PACKAGES="${PACKAGES} coq-bignums.8.13.0"
PACKAGES="${PACKAGES} coq-aac-tactics.8.13.0"
PACKAGES="${PACKAGES} coq-mtac2.1.4+8.13"
PACKAGES="${PACKAGES} coq-simple-io.1.5.0"

# Analysis and numerics
PACKAGES="${PACKAGES} coq-flocq.3.3.1"
PACKAGES="${PACKAGES} coq-gappa.1.4.6 gappa.1.3.5"

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

# Packages depending on mathcomp
PACKAGES="${PACKAGES} coq-coquelicot.3.1.0"
PACKAGES="${PACKAGES} coq-interval.4.1.1"
if [[ "$OSTYPE" != cygwin ]]
then
  # coq-quickchick does not work on Windows because it requires ocamlc and other tools
  PACKAGES="${PACKAGES} coq-quickchick.1.5.0"
fi

# Homotopy Type Theory (HoTT)
PACKAGES="${PACKAGES} coq-hott.8.13"

# Menhir, CompCert and Princeton VST - these take longer to compile !
PACKAGES="${PACKAGES} coq-menhirlib.20200624 menhir.20200624"

case "$COQ_PLATFORM_COMPCERT" in
  [yY]) PACKAGES="${PACKAGES} coq-compcert.3.8" ;;
  [nN]) true ;;
  *) echo "Illegal value for COQ_PLATFORM_COMPCERT - aborting"; false ;;
esac

case "$COQ_PLATFORM_VST" in
  [yY]) PACKAGES="${PACKAGES} coq-vst.2.7.1" ;;
  [nN]) true ;;
  *) echo "Illegal value for COQ_PLATFORM_VST - aborting"; false ;;
esac

fi
