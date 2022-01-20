#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020..2022 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CONTROL VARIABLES #####################

# The two lines below are used by the package selection script
COQ_PLATFORM_VERSION_TITLE="Coq 8.15.0 (released Jan 2022) with preview package pick"
COQ_PLATFORM_VERSION_SORTORDER=9000

# The package list name is the final part of the opam switch name.
# It is usually either empty ot starts with ~.
# It might also be used for installer package names, but with ~ replaced by _
# It is also used for version specific file selections in the smoke test kit.
COQ_PLATFORM_PACKAGE_PICK_POSTFIX='~8.15.preview~2022.01'

# The corresponding Coq development branch and tag
COQ_PLATFORM_COQ_BRANCH='v8.15'
COQ_PLATFORM_COQ_TAG='8.15.0'

# This controls if opam repositories for development packages are selected
COQ_PLATFORM_USE_DEV_REPOSITORY='N'

# This extended descriptions is used for readme files
COQ_PLATFORM_VERSION_DESCRIPTION='This version of Coq Platform 2022.01.0 includes Coq 8.15.0 from  01/2022. '
COQ_PLATFORM_VERSION_DESCRIPTION+='This is **preview release** of Coq Platform for Coq 8.15.0 mostly intended for package maintainers. '

###################### PACKAGE SELECTION #####################

PACKAGES=""

# - Comment out packages you do not want.
# - Packages which take a long time to build should be given last.
#   There is some evidence that they are built early then.
# - Versions ending with ~flex are identical to the opam package without the
#   ~flex extension, except that version restrictions have been relaxed.
# - The picking tracker issue is https://github.com/coq/platform/issues/193

########## BASE PACKAGES ##########

# The Coq compiler coqc and the Coq standard library
PACKAGES="${PACKAGES} coq.8.15.0"

########## IDE PACKAGES ##########

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[iIfFxX] ]]
then
PACKAGES="${PACKAGES} coqide.8.15.0 lablgtk3.3.1.2"
fi

########## "FULL" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[fFxX] ]]
then
  # Some dependencies for which we need specific versions
  PACKAGES="${PACKAGES} PIN.ppxlib.0.15.0" # coq-serapi requires this old version

  # Standard library extensions
  PACKAGES="${PACKAGES} coq-bignums.8.15.0"
  PACKAGES="${PACKAGES} coq-ext-lib.0.11.5"
  # PACKAGES="${PACKAGES} coq-stdpp.1.6.0" # requires 8.14, build error with version patch

  # General mathematics
  PACKAGES="${PACKAGES} coq-mathcomp-ssreflect.1.13.0"
  PACKAGES="${PACKAGES} coq-mathcomp-fingroup.1.13.0"
  PACKAGES="${PACKAGES} coq-mathcomp-algebra.1.13.0"
  PACKAGES="${PACKAGES} coq-mathcomp-solvable.1.13.0"
  PACKAGES="${PACKAGES} coq-mathcomp-field.1.13.0"
  PACKAGES="${PACKAGES} coq-mathcomp-character.1.13.0"
  PACKAGES="${PACKAGES} coq-mathcomp-bigenough.1.0.1"
  PACKAGES="${PACKAGES} coq-mathcomp-finmap.1.5.1"
  PACKAGES="${PACKAGES} coq-mathcomp-real-closed.1.1.2"
  PACKAGES="${PACKAGES} coq-mathcomp-zify.1.2.0+1.12+8.13"
  PACKAGES="${PACKAGES} coq-mathcomp-multinomials.1.5.5"
  PACKAGES="${PACKAGES} coq-coquelicot.3.2.0"

  # Number theory
  PACKAGES="${PACKAGES} coq-coqprime.1.1.1"
  PACKAGES="${PACKAGES} coq-coqprime-generator.1.1.1"
  
  # Numerical mathematics
  PACKAGES="${PACKAGES} coq-flocq.3.4.3"
  PACKAGES="${PACKAGES} coq-interval.4.4.0"
  # PACKAGES="${PACKAGES} coq-gappa.1.5.0 gappa.1.4.0" # requires 8.14, build error with version patch

  # Constructive mathematics
  # PACKAGES="${PACKAGES} coq-math-classes.8.13.0" # requires 8.14, build error with version patch
  # PACKAGES="${PACKAGES} coq-corn.8.13.0" # requires 8.14 and coq-math-classes

  # Homotopy Type Theory (HoTT)
  # PACKAGES="${PACKAGES} coq-hott.8.14" # requires 8.14, build error with version patch

  # Univalent Mathematics (UniMath)
  # Note: coq-unimath requires too much memory for 32 bit architectures
  if [ "${BITSIZE}" == "64" ]
  then
    PACKAGES="${PACKAGES} coq-unimath.20210807"
  fi 

  # Code extraction
  PACKAGES="${PACKAGES} coq-simple-io.1.6.0" # works with 8.14 version patch

  # Proof automation / generation / helpers
  PACKAGES="${PACKAGES} coq-menhirlib.20211230 menhir.20211230"
  PACKAGES="${PACKAGES} coq-equations.1.3+8.15"
  PACKAGES="${PACKAGES} coq-aac-tactics.8.15.0"
  PACKAGES="${PACKAGES} coq-unicoq.1.6+8.15"
  # PACKAGES="${PACKAGES} coq-mtac2.1.4+8.14" # requires 8.14 and coq-unicoq
  PACKAGES="${PACKAGES} coq-elpi.1.12.0 elpi.1.13.8"
  PACKAGES="${PACKAGES} coq-hierarchy-builder.1.2.1"
  PACKAGES="${PACKAGES} coq-quickchick.1.6.0" # works with 8.14 version patch
  # PACKAGES="${PACKAGES} coq-hammer-tactics.1.3.1+8.13~flex" # coq-hammer-tactics.1.3.1+8.13~flex does not compile
  PACKAGES="${PACKAGES} coq-paramcoq.1.1.3+coq8.15"
  PACKAGES="${PACKAGES} coq-coqeal.1.1.0"
  PACKAGES="${PACKAGES} coq-libhyps.2.0.4" # works with 8.14 version patch

  # General mathematics (which requires one of the above tools)
  # PACKAGES="${PACKAGES} coq-mathcomp-analysis.0.3.12" # requires 8.14, build error with version patch

  # Formal languages, compilers and code verification
  PACKAGES="${PACKAGES} coq-reglang.1.1.2" # works with 8.14 version patch
  # PACKAGES="${PACKAGES} coq-iris.3.5.0" # requires 8.14 and coq-stdpp
  # PACKAGES="${PACKAGES} coq-iris-heap-lang.3.5.0" # requires 8.14 and coq-iris

#   case "$COQ_PLATFORM_COMPCERT" in # requires 8.14, build error with version patch
#     [yY]) PACKAGES="${PACKAGES} coq-compcert.3.9" ;;
#     [nN]) true ;;
#     *) echo "Illegal value for COQ_PLATFORM_COMPCERT - aborting"; false ;;
#   esac

#   case "$COQ_PLATFORM_VST" in # requires 8.14 and coq-compcert
#     [yY]) PACKAGES="${PACKAGES} coq-vst.2.8" ;;
#     [nN]) true ;;
#     *) echo "Illegal value for COQ_PLATFORM_VST - aborting"; false ;;
#   esac

  # Proof analysis and other tools
  # PACKAGES="${PACKAGES} coq-dpdgraph.1.0+8.14"  # requires 8.14

fi

########## EXTENDED" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[xX] ]]
then

  # Proof automation / generation / helpers
  PACKAGES="${PACKAGES} coq-deriving.0.1.0"  # works with 8.14 version patch

  # Gallina extensions
  PACKAGES="${PACKAGES} coq-reduction-effects.0.1.3"
  PACKAGES="${PACKAGES} coq-record-update.0.3.0"  # works with 8.14 version patch

  # Communication with coqtop
  PACKAGES="${PACKAGES} coq-serapi.8.15.0+0.15.0"

fi
