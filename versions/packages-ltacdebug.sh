#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CONTROL VARIABLES #####################

# The two lines below are used by the package selection script
COQ_PLATFORM_VERSION_TITLE="Coq 8.14 with Ltac debugger (unreleased preview)"
COQ_PLATFORM_VERSION_SORTORDER=9100

# The package list name is the final part of the opam switch name.
# It is usually either empty ot starts with ~.
# It might also be used for installer package names, but with ~ replaced by _
# It is also used for version specific file selections in the smoke test kit.
COQ_PLATFORM_PACKAGELIST_NAME='~8.14~ltacdebug'

# The corresponding Coq development branch and tag
COQ_PLATFORM_COQ_BRANCH='v8.14'
COQ_PLATFORM_COQ_TAG='v8.14'

# This controls if opam repositories for development packages are selected
COQ_PLATFORM_USE_DEV_REPOSITORY='Y'

# This extended descriptions is used for readme files
COQ_PLATFORM_VERSION_DESCRIPTION='This version of Coq Platform 2021.11.0 includes a preview release for an interactive Ltac debugger in CoqIDE based on Coq 8.14.'

###################### PACKAGE SELECTION #####################

PACKAGES=""

# - Comment out packages you do not want.
# - Packages which take a long time to build should be given last.
#   There is some evidence that they are built early then.
# - Versions ending with ~flex are identical to the opam package without the
#   ~flex extension, except that version restrictions have been relaxed.
# - The picking tracker issue is https://github.com/coq/platform/issues/139

########## BASE PACKAGES ##########

# The Coq compiler coqc and the Coq standard library
PACKAGES="${PACKAGES} coq.8.14+ltacdebug"

########## IDE PACKAGES ##########

# GTK based IDE for Coq - alternatives are VSCoq and Proofgeneral for Emacs
if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[iIfFxX] ]]
then
PACKAGES="${PACKAGES} coqide.8.14+ltacdebug lablgtk3.3.1.1"
fi

########## "FULL" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[fFxX] ]]
then

  # Standard library extensions
  PACKAGES="${PACKAGES} coq-bignums.8.14.0"
  PACKAGES="${PACKAGES} coq-ext-lib.0.11.4"           # pick confirmed https://github.com/coq-community/coq-ext-lib/issues/116
  # PACKAGES="${PACKAGES} coq-stdpp.1.5.0"            # coq-stdpp.1.5.0~flex does not compile

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
  PACKAGES="${PACKAGES} coq-mathcomp-zify.1.1.0+1.12+8.13" # pick confirmed https://github.com/coq/opam-coq-archive/pull/1838
  PACKAGES="${PACKAGES} coq-mathcomp-analysis.0.3.10"
  PACKAGES="${PACKAGES} coq-mathcomp-multinomials.1.5.4"
  PACKAGES="${PACKAGES} coq-coquelicot.3.2.0"         # pick confirmed https://gitlab.inria.fr/coquelicot/coquelicot/-/issues/4

  # Number theory
  PACKAGES="${PACKAGES} coq-coqprime.1.1.0"           # pick confirmed https://github.com/thery/coqprime/issues/29 (TODO: CLOSE)

  # Numerical mathematics
  PACKAGES="${PACKAGES} coq-interval.4.3.0"           # pick confirmed https://gitlab.inria.fr/coqinterval/interval/-/issues/7
  PACKAGES="${PACKAGES} coq-flocq.3.4.2"              # pick confirmed https://gitlab.inria.fr/flocq/flocq/-/issues/17
  PACKAGES="${PACKAGES} coq-gappa.1.5.0 gappa.1.4.0"  # pick confirmed https://gitlab.inria.fr/gappa/coq/-/issues/9

  # Constructive mathematics
  PACKAGES="${PACKAGES} coq-math-classes.8.13.0"
  PACKAGES="${PACKAGES} coq-corn.8.13.0"

  # Homotopy Type Theory (HoTT)
  PACKAGES="${PACKAGES} coq-hott.8.14"                # pick confirmed https://github.com/HoTT/HoTT/issues/1581

  # Univalent Mathematics (UniMath)
  # Note: coq-unimath requires too much memory for 32 bit architectures
  if [ "${BITSIZE}" == "64" ]; then PACKAGES="${PACKAGES} coq-unimath.20210807"; fi

  # Proof automation / generation / helpers
  PACKAGES="${PACKAGES} coq-equations.1.3+8.14"       # pick confirmed https://github.com/mattam82/Coq-Equations/issues/427
  PACKAGES="${PACKAGES} coq-aac-tactics.8.14.0"       # pick confirmed https://github.com/coq-community/aac-tactics/issues/87
  PACKAGES="${PACKAGES} coq-unicoq.1.5+8.14"          # untagged pre release
  PACKAGES="${PACKAGES} coq-mtac2.1.4+8.14"           # pick confirmed https://github.com/Mtac2/Mtac2/issues/344
  PACKAGES="${PACKAGES} coq-elpi.1.11.2~ltacdebug elpi.1.13.7"  # Ltac Debug requires a patch, see https://github.com/LPCIC/coq-elpi/pull/248
  PACKAGES="${PACKAGES} coq-hierarchy-builder.1.2.0"  # pick confirmed https://github.com/math-comp/hierarchy-builder/issues/265
  PACKAGES="${PACKAGES} coq-quickchick.1.5.1"         # pick confirmed https://github.com/QuickChick/QuickChick/issues/236
  # PACKAGES="${PACKAGES} coq-hammer-tactics.1.3.1+8.13~flex" # coq-hammer-tactics.1.3.1+8.13~flex does not compile
  PACKAGES="${PACKAGES} coq-paramcoq.1.1.3+coq8.14"
  PACKAGES="${PACKAGES} coq-coqeal.1.0.6"
  # PACKAGES="${PACKAGES} coq-libhyps.2.0.3~flex"     # coq-libhyps.2.0.3~flex does not compile

  # Formal languages, compilers and code verification
  PACKAGES="${PACKAGES} coq-menhirlib.20210419 menhir.20210419" # pick confirmed https://gitlab.inria.fr/fpottier/menhir/-/issues/55
  PACKAGES="${PACKAGES} coq-reglang.1.1.2"            # TODO: update for mathcomp 1.13
  # PACKAGES="${PACKAGES} coq-iris.3.4.0"             # TODO: depends on coq-stdpp
  # PACKAGES="${PACKAGES} coq-iris-heap-lang.3.4.0"   # TODO: depends on coq-stdpp

  case "$COQ_PLATFORM_COMPCERT" in
    [yY]) PACKAGES="${PACKAGES} coq-compcert.3.9" ;;  # pick confirmed https://github.com/AbsInt/CompCert/issues/414
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_COMPCERT - aborting"; false ;;
  esac

  case "$COQ_PLATFORM_VST" in
    [yY]) PACKAGES="${PACKAGES} coq-vst.2.8" ;;
    [nN]) true ;;
    *) echo "Illegal value for COQ_PLATFORM_VST - aborting"; false ;;
  esac

  # Code extraction
  PACKAGES="${PACKAGES} coq-simple-io.1.6.0"          # pick confirmed https://github.com/Lysxia/coq-simple-io/issues/32

  # Proof analysis and other tools
  PACKAGES="${PACKAGES} coq-dpdgraph.1.0+8.14"        # pick confirmed https://github.com/coq-community/coq-dpdgraph/issues/88

fi

########## EXTENDED" COQ PLATFORM PACKAGES ##########

if  [[ "${COQ_PLATFORM_EXTENT}"  =~ ^[xX] ]]
then

  # Proof automation / generation / helpers
  PACKAGES="${PACKAGES} coq-deriving.0.1.0"

  # Gallina extensions
  PACKAGES="${PACKAGES} coq-reduction-effects.0.1.3"  # pick confirmed https://github.com/coq-community/reduction-effects/issues/12 (TODO: close)
  PACKAGES="${PACKAGES} coq-record-update.0.3.0"

  # Communication with coqtop
  PACKAGES="${PACKAGES} coq-serapi.8.14.0+0.14.0~ltacdebug"  # Ltac debug requires a patch, see https://github.com/ejgallego/coq-serapi/pull/259

fi
