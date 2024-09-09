#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020..2022 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CONTROL VARIABLES #####################

# The two lines below are used by the package selection script
COQ_PLATFORM_VERSION_TITLE="Coq 8.18.0 (released Sep 2023) with the first package pick from Nov 2023"
COQ_PLATFORM_VERSION_SORTORDER=1

# The package list name is the final part of the opam switch name.
# It is usually either empty ot starts with ~.
# It might also be used for installer package names, but with ~ replaced by _
# It is also used for version specific file selections in the smoke test kit.
COQ_PLATFORM_PACKAGE_PICK_POSTFIX='~8.18~2023.11'

# The corresponding Coq development branch and tag
COQ_PLATFORM_COQ_BRANCH='v8.18'
COQ_PLATFORM_COQ_TAG='8.18.0'

# This controls if opam repositories for development packages are selected
COQ_PLATFORM_USE_DEV_REPOSITORY='Y'

# This extended descriptions is used for readme files
COQ_PLATFORM_VERSION_DESCRIPTION='This version of Coq Platform 2023.11.0 includes Coq 8.18.0 from Sep 2023. '
COQ_PLATFORM_VERSION_DESCRIPTION+='This is the **latest release version** of the Coq Platform and recommended for general application. '

# The OCaml version to use for this pick (just the version number - options are elaborated in a platform dependent way)
COQ_PLATFORM_OCAML_VERSION='4.14.2'

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
PACKAGES="${PACKAGES} PIN.dune.3.15.3"
PACKAGES="${PACKAGES} PIN.dune-configurator.3.15.3"
# The Coq compiler coqc and the Coq standard library
PACKAGES="${PACKAGES} PIN.coq.8.18.0"

########## IDE PACKAGES ##########

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[iIfFxX] ]]
then
PACKAGES="${PACKAGES} coqide.8.18.0"
fi

########## "FULL" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[fFxX] ]]
then
  # Standard library extensions
  PACKAGES="${PACKAGES} coq-bignums.9.0.0+coq8.18"
  PACKAGES="${PACKAGES} coq-ext-lib.0.11.8"
  PACKAGES="${PACKAGES} coq-stdpp.1.9.0"

  # General mathematics
  PACKAGES="${PACKAGES} coq-mathcomp-ssreflect.1.18.0"
  PACKAGES="${PACKAGES} coq-mathcomp-fingroup.1.18.0"
  PACKAGES="${PACKAGES} coq-mathcomp-algebra.1.18.0"
  PACKAGES="${PACKAGES} coq-mathcomp-solvable.1.18.0"
  PACKAGES="${PACKAGES} coq-mathcomp-field.1.18.0"
  PACKAGES="${PACKAGES} coq-mathcomp-character.1.18.0"
  PACKAGES="${PACKAGES} coq-mathcomp-bigenough.1.0.1"
  PACKAGES="${PACKAGES} coq-mathcomp-finmap.1.5.2"
  PACKAGES="${PACKAGES} coq-mathcomp-real-closed.1.1.4"
  PACKAGES="${PACKAGES} coq-mathcomp-zify.1.3.0+1.12+8.13"
  PACKAGES="${PACKAGES} coq-mathcomp-multinomials.1.6.0"
  PACKAGES="${PACKAGES} coq-coquelicot.3.4.0"

  # Number theory
  PACKAGES="${PACKAGES} coq-coqprime.1.4.0"
  PACKAGES="${PACKAGES} coq-coqprime-generator.1.1.1"
  
  # Numerical mathematics
  PACKAGES="${PACKAGES} coq-flocq.4.1.3"
  PACKAGES="${PACKAGES} coq-interval.4.8.1"
  PACKAGES="${PACKAGES} coq-gappa.1.5.4"
  PACKAGES="${PACKAGES} gappa.1.4.1"

  # Constructive mathematics
  PACKAGES="${PACKAGES} coq-math-classes.8.18.0"
  PACKAGES="${PACKAGES} coq-corn.8.18.0"

  # Homotopy Type Theory (HoTT)
  PACKAGES="${PACKAGES} coq-hott.8.18"

  # Univalent Mathematics (UniMath)
  # Note: coq-unimath requires too much memory for 32 bit architectures
  if [ "${BITSIZE}" == "64" ]
  then
    case "$COQ_PLATFORM_UNIMATH" in
    [yY]) PACKAGES="${PACKAGES} coq-unimath.20231010" ;;
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_UNIMATH - aborting"; false ;;
    esac
  fi 

  # Code extraction
  PACKAGES="${PACKAGES} coq-simple-io.1.8.0"

  # Proof automation / generation / helpers
  PACKAGES="${PACKAGES} coq-menhirlib.20230608 menhir.20230608"
  PACKAGES="${PACKAGES} coq-equations.1.3+8.18"
  PACKAGES="${PACKAGES} coq-aac-tactics.8.18.0"
  PACKAGES="${PACKAGES} coq-unicoq.1.6+8.18"
  PACKAGES="${PACKAGES} coq-mtac2.1.4+8.18"
  PACKAGES="${PACKAGES} elpi.1.17.4 coq-elpi.1.19.3"
  PACKAGES="${PACKAGES} coq-hierarchy-builder.1.6.0"
  PACKAGES="${PACKAGES} coq-quickchick.2.0.1"
  PACKAGES="${PACKAGES} coq-hammer-tactics.1.3.2+8.18"
  if [[ "$OSTYPE" != cygwin ]]
  then
    # coq-hammer does not work on Windows because it heavily relies on fork
    PACKAGES="${PACKAGES} coq-hammer.1.3.2+8.18"
    PACKAGES="${PACKAGES} eprover.3.0"
    PACKAGES="${PACKAGES} z3_tptp.4.11.2"  # 4.12.2-1 has build issues on ARM macOS
  fi
  PACKAGES="${PACKAGES} coq-paramcoq.1.1.3+coq8.18"
  PACKAGES="${PACKAGES} coq-coqeal.1.1.3"
  PACKAGES="${PACKAGES} coq-libhyps.2.0.8"
  PACKAGES="${PACKAGES} coq-itauto.8.18.0"
  
  # General mathematics (which requires one of the above tools)
  PACKAGES="${PACKAGES} coq-mathcomp-analysis.0.6.6"
  PACKAGES="${PACKAGES} coq-mathcomp-algebra-tactics.1.1.1"
  PACKAGES="${PACKAGES} coq-relation-algebra.1.7.10"

  # Formal languages, compilers and code verification
  PACKAGES="${PACKAGES} coq-reglang.1.1.3"
  PACKAGES="${PACKAGES} coq-iris.4.1.0"
  PACKAGES="${PACKAGES} coq-iris-heap-lang.4.1.0"
  PACKAGES="${PACKAGES} coq-ott.0.33"
  PACKAGES="${PACKAGES} ott.0.33"
  PACKAGES="${PACKAGES} coq-mathcomp-word.2.1" # Note: 3.0 is incompatible with mathcomp 1.X
  
  case "$COQ_PLATFORM_COMPCERT" in
    [yY]) PACKAGES="${PACKAGES} coq-compcert.3.13.1" ;;
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_COMPCERT - aborting"; false ;;
  esac

  case "$COQ_PLATFORM_VST" in
    [yY])
      PACKAGES="${PACKAGES} coq-vst.2.13"
      true ;;
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_VST - aborting"; false ;;
  esac

  # # Proof analysis and other tools
  PACKAGES="${PACKAGES} coq-dpdgraph.1.0+8.18"
fi

########## EXTENDED" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[xX] ]]
then

  # Proof automation / generation / helpers
  PACKAGES="${PACKAGES} coq-deriving.0.1.1"
  if [ "${BITSIZE}" == "64" ]
  then
    PACKAGES="${PACKAGES} coq-metacoq.1.2.1+8.18"
  fi

  # General mathematics
  PACKAGES="${PACKAGES} coq-extructures.0.3.1"

  # Gallina extensions
  PACKAGES="${PACKAGES} coq-reduction-effects.0.1.5"
  PACKAGES="${PACKAGES} coq-record-update.0.3.3"

  # Communication with coqtop
  PACKAGES="${PACKAGES} coq-serapi.8.18.0+0.18.1"

  # fiat crypto, bedrock2, rupicola and dependencies
  if [ "${BITSIZE}" == "64" ]
  then
    case "$COQ_PLATFORM_FIATCRYPTO" in
      [yY])
        PACKAGES="${PACKAGES} coq-coqutil.0.0.4"
        PACKAGES="${PACKAGES} coq-rewriter.0.0.9"
        PACKAGES="${PACKAGES} coq-riscv.0.0.4"
        PACKAGES="${PACKAGES} coq-bedrock2.0.0.6"
        PACKAGES="${PACKAGES} coq-bedrock2-compiler.0.0.6"
        PACKAGES="${PACKAGES} coq-rupicola.0.0.8"
        if [ "$OSTYPE" != cygwin ]
        then
          # Windows: stack overflow
          PACKAGES="${PACKAGES} coq-fiat-crypto.0.0.24"
          true
        fi
        ;;
      [nN]) true ;;
      *) echo "Illegal value for COQ_PLATFORM_FIATCRYPTO - aborting"; false ;;
    esac
  fi
fi
