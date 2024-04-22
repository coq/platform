#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020..2022 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CONTROL VARIABLES #####################

# The two lines below are used by the package selection script
COQ_PLATFORM_VERSION_TITLE="Coq 8.19.1 (released Mar 2024)"
COQ_PLATFORM_VERSION_SORTORDER=98

# The package list name is the final part of the opam switch name.
# It is usually either empty ot starts with ~.
# It might also be used for installer package names, but with ~ replaced by _
# It is also used for version specific file selections in the smoke test kit.
COQ_PLATFORM_PACKAGE_PICK_POSTFIX='~8.19~2024.01+beta1'

# The corresponding Coq development branch and tag
COQ_PLATFORM_COQ_BRANCH='v8.19'
COQ_PLATFORM_COQ_TAG='8.19.1'

# This controls if opam repositories for development packages are selected
COQ_PLATFORM_USE_DEV_REPOSITORY='N'

# This extended descriptions is used for readme files
COQ_PLATFORM_VERSION_DESCRIPTION='This version of Coq Platform 2024.01.0 includes Coq 8.19.1 from Mar 2024. '

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
PACKAGES="${PACKAGES} PIN.coq.8.19.1"

########## IDE PACKAGES ##########

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[iIfFxX] ]]
then
PACKAGES="${PACKAGES} coqide.8.19.1"
fi

########## "FULL" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[fFxX] ]]
then
  # Standard library extensions
  PACKAGES="${PACKAGES} coq-bignums.9.0.0+coq8.19"
  PACKAGES="${PACKAGES} coq-ext-lib.0.12.1"
  #PACKAGES="${PACKAGES} coq-stdpp.1.9.0" #does not build

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
  PACKAGES="${PACKAGES} coq-coqprime.1.5.0"
  PACKAGES="${PACKAGES} coq-coqprime-generator.1.1.1" #NOTE:THIS IS STILL TAGGED TO v8.14.1, SHOULD SOMETHING BE DONE?
  
  # Numerical mathematics
  PACKAGES="${PACKAGES} coq-flocq.4.1.4"
  PACKAGES="${PACKAGES} coq-interval.4.10.0"
  PACKAGES="${PACKAGES} coq-gappa.1.5.5"
  PACKAGES="${PACKAGES} gappa.1.4.1"

  # Constructive mathematics
  #PACKAGES="${PACKAGES} coq-math-classes.8.18.0" #DOES NOT BUILD
  #PACKAGES="${PACKAGES} coq-corn.8.18.0" #DOES NOT BUILD

  # Homotopy Type Theory (HoTT)
  PACKAGES="${PACKAGES} coq-hott.8.19"

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
  PACKAGES="${PACKAGES} coq-menhirlib.20231231 menhir.20231231"
  PACKAGES="${PACKAGES} coq-equations.1.3+8.19"
  PACKAGES="${PACKAGES} coq-aac-tactics.8.19.0"
  #PACKAGES="${PACKAGES} coq-unicoq.1.6+8.18" #DOES NOT BUILD
  #PACKAGES="${PACKAGES} coq-mtac2.1.4+8.18" #DOES NOT BUILD, DEPENDS ON UNICOQ
  PACKAGES="${PACKAGES} elpi.1.18.2 coq-elpi.2.1.0"
  PACKAGES="${PACKAGES} coq-hierarchy-builder.1.7.0"
  #PACKAGES="${PACKAGES} coq-quickchick.2.0.2" #DOES NOT BUILD ON WINDOWS
  PACKAGES="${PACKAGES} coq-hammer-tactics.1.3.2+8.19"
  if [[ "$OSTYPE" != cygwin ]]
  then
    # coq-hammer does not work on Windows because it heavily relies on fork
    PACKAGES="${PACKAGES} coq-hammer.1.3.2+8.19"
    PACKAGES="${PACKAGES} eprover.3.0"
    PACKAGES="${PACKAGES} z3_tptp.4.11.2"  # 4.12.2-1 has build issues on ARM macOS
  fi
  PACKAGES="${PACKAGES} coq-paramcoq.1.1.3+coq8.19"
  PACKAGES="${PACKAGES} coq-coqeal.2.0.2"
  #PACKAGES="${PACKAGES} coq-libhyps.2.0.8" #DOES NOT BUILD
  #PACKAGES="${PACKAGES} coq-itauto.8.19.0" #DOES NOT BUILD ON WINDOWS
  
  # General mathematics (which requires one of the above tools)
  PACKAGES="${PACKAGES} coq-mathcomp-analysis.1.1.0"
  PACKAGES="${PACKAGES} coq-mathcomp-algebra-tactics.1.2.3"
  PACKAGES="${PACKAGES} coq-relation-algebra.1.7.10"

  # Formal languages, compilers and code verification
  PACKAGES="${PACKAGES} coq-reglang.1.2.1"
  #PACKAGES="${PACKAGES} coq-iris.4.1.0" #DEPENDS ON coq-stdpp
  #PACKAGES="${PACKAGES} coq-iris-heap-lang.4.1.0" #DEPENDS on coq-iris
  if [[ "$OSTYPE" != cygwin ]]
  then
    # Windows: some issues with executable extensions (ott.opt instead of ott.exe)
    # Note: 0.32 does work on Windows!
    #PACKAGES="${PACKAGES} coq-ott.0.33" #DOES NOT BUILD
    PACKAGES="${PACKAGES} ott.0.33"
  fi
  PACKAGES="${PACKAGES} coq-mathcomp-word.3.0"
  
  case "$COQ_PLATFORM_COMPCERT" in
    [yY]) PACKAGES="${PACKAGES} coq-compcert.3.13.1" ;;
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_COMPCERT - aborting"; false ;;
  esac

  case "$COQ_PLATFORM_VST" in
    [yY])
      PACKAGES="${PACKAGES} coq-vst.2.14"
      true ;;
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_VST - aborting"; false ;;
  esac

  # # Proof analysis and other tools
  PACKAGES="${PACKAGES} coq-dpdgraph.1.0+8.19"
fi

########## EXTENDED" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[xX] ]]
then

  # Proof automation / generation / helpers
  PACKAGES="${PACKAGES} coq-deriving.0.2.0"
  if [ "${BITSIZE}" == "64" ]
  then
    PACKAGES="${PACKAGES} coq-metacoq.1.3.1+8.19"
  fi

  # General mathematic s
  PACKAGES="${PACKAGES} coq-extructures.0.4.0"

  # Gallina extensions
  PACKAGES="${PACKAGES} coq-reduction-effects.0.1.5"
  PACKAGES="${PACKAGES} coq-record-update.0.3.4"

  # Communication with coqtop
  if [[ "$OSTYPE" != cygwin ]]
  then
    # Windows: path length issues
    PACKAGES="${PACKAGES} coq-serapi.8.19.0+0.19.2"

  fi

  # fiat crypto, bedrock2, rupicola and dependencies
  if [ "${BITSIZE}" == "64" ]
  then
    case "$COQ_PLATFORM_FIATCRYPTO" in
      [yY])
        PACKAGES="${PACKAGES} coq-coqutil.0.0.5"
        PACKAGES="${PACKAGES} coq-rewriter.0.0.11"
        PACKAGES="${PACKAGES} coq-riscv.0.0.5"
        PACKAGES="${PACKAGES} coq-bedrock2.0.0.7"
        PACKAGES="${PACKAGES} coq-bedrock2-compiler.0.0.7"
        PACKAGES="${PACKAGES} coq-rupicola.0.0.9"
        if [ "$OSTYPE" != cygwin ]
        then
          # Windows: stack overflow
          PACKAGES="${PACKAGES} coq-fiat-crypto.0.1.2"
          true
        fi
        ;;
      [nN]) true ;;
      *) echo "Illegal value for COQ_PLATFORM_FIATCRYPTO - aborting"; false ;;
    esac
  fi
fi
