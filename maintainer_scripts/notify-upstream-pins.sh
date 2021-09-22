
#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Enrico Tassi
# (C) 2021 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### Notify Coq Platform Maintainers ######################

# This script interactively creates upstream issues to notify coq platform
# package maintainers that we need a tag for a new Coq Platform release

# $1: Path of Coq Platform package list file

set -o nounset
set -o errexit

case $BASH_VERSION in
  1*|2*|3*)
    echo "Bash version 4 or greater required"
    exit 1
  ;;
esac

##### Settings #####

EXT_PRE="+rc1"
DATE_PRE="Septamber 17, 2021"
DATE_FINAL="October 31, 2021"
#CC="CC: https://github.com/coq/coq/issues/12334"
#CC="\n@coqbot column:...."
REASON="bundled in the Coq Platform"

##### Shell functions for translating Coq Platform (Opam) package names to Coq CI package names ####

# This function expects $package to be set to a Coq Platform package name and
# sets package_ci to the corresponding Coq CI package name

function package_platform_to_ci() {
  package_main=${package%%.*}
  package_ci=''
  case $package_main in
    coq)                    ;;
    coqide)                 ;;
    coq-interval)           ;;
    coq-mathcomp-ssreflect) package_ci='mathcomp' ;; 
    coq-mathcomp-*)         ;; 
    coq-*)                  package_ci="${package_main#coq-}" ;;
    *)                      ;;
  esac
  package_ci=${package_ci//-/_}
}

##### Shell functions for reading ci-basic-overlay.sh #####

# reads a variable value from a ci-basic-overlay.sh file
function read_from() {
  ( . $1; varname="$2"; echo ${!varname} )
}

##### Shell functions for creating GIT server issue URL #####

# https://gist.github.com/cdown/1163649
function urlencode() {
    # urlencode <string>

    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    if [ -n "${old_lc_collate}" ]
    then
      LC_COLLATE=$old_lc_collate
    fi
}

function template {
  TITLE="Please create a tag for the upcoming release of Coq ${COQ_PLATFORM_COQ_BASE_VERSION}"
  BODY="The Coq team released Coq ${COQ_PLATFORM_COQ_BASE_VERSION}${EXT_PRE} on $DATE_PRE,
and plans to release Coq $COQ_PLATFORM_COQ_BASE_VERSION.0 on $DATE_FINAL.

Your project is currently scheduled for being $REASON.

Coq CI is currently testing commit $3
on branch $1/tree/$2
but we would like to ship a released version instead (a tag in git's slang).

Could you please create a tag, or communicate us any existing tag
that works with the Coq branch ${COQ_PLATFORM_COQ_BRANCH} at the *latest* 15 days before the
date of the final release?

Thanks!
$CC
"
  UUTITLE=$(urlencode "$TITLE")
  UUBODY=$(urlencode "$BODY")

  case $1 in
  ( http*github.com* )
    echo "$1/issues/new?title=$UUTITLE&body=$UUBODY"
  ;;
  ( http*gitlab* )
    echo "$1/-/issues/new"
    echo
    echo -e "$TITLE"
    echo
    echo -e "$BODY"
  ;;
  ( * )
    echo "$1"
    echo
    echo -e "$TITLE"
    echo
    echo -e "$BODY"

  ;;
  esac
}

##### Read package list file #####

COQ_PLATFORM_EXTENT=f
COQ_PLATFORM_COMPCERT=y
COQ_PLATFORM_VST=y

source $1

COQ_PLATFORM_COQ_BASE_VERSION=${COQ_PLATFORM_COQ_BRANCH#v}

echo COQ_PLATFORM_COQ_BASE_VERSION = "${COQ_PLATFORM_COQ_BASE_VERSION}"
echo COQ_PLATFORM_COQ_BRANCH       = "${COQ_PLATFORM_COQ_BRANCH}"
echo COQ_PLATFORM_COQ_TAG          = "${COQ_PLATFORM_COQ_TAG}"
echo PACKAGES                      = "${PACKAGES}"

##### Get ci-basic-overlay.sh file from the branch corresponding to the version #####

wget https://raw.githubusercontent.com/coq/coq/${COQ_PLATFORM_COQ_BRANCH}/dev/ci/ci-basic-overlay.sh -O /tmp/branch-ci-basic-overlay.sh
wget https://raw.githubusercontent.com/coq/coq/master/dev/ci/ci-basic-overlay.sh -O /tmp/master-ci-basic-overlay.sh

##### Main loop #####

set +o nounset

for package in ${PACKAGES}
do
  package_platform_to_ci
  if [ -n "${package_ci}" ]
  then
    echo -e "\n----------------------------------------------"
    url=`read_from /tmp/master-ci-basic-overlay.sh "${package_ci}_CI_GITURL"`
    ref=`read_from /tmp/master-ci-basic-overlay.sh "${package_ci}_CI_REF"`
    pin=`read_from /tmp/branch-ci-basic-overlay.sh "${package_ci}_CI_REF"`
    echo "Available tags for ${package} are:"
    git -c 'versionsort.suffix=-' ls-remote --refs --tags --sort='v:refname' "${url}" | sed 's|.*refs/tags/||'
    if [ "${#pin}" = "40" ]
    then
      echo -e "Package ${package} is pinned to a hash in Coq CI, to open an issue open the following url:\n"
      template ${url} $ref $pin
    elif [ "${#pin}" = "0" ]
    then
      echo "=================================================="
      echo "ERROR: Package ${package} has no pin!"
      echo "=================================================="
    else
      echo "Package ${package} is already pinned to version $pin"
      echo 
    fi
  fi
done
