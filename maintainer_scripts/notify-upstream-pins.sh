
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
DATE_PRE="September 17, 2021"

DATE_FINAL="October 31, 2021"

DATE_PLATFORM_EXPECTED="November 30, 2021"
DATE_PLATFORM_LATEST="January 31, 2022"

CC="CC: https://github.com/coq/platform/issues/139"
#CC="\n@coqbot column:...."

##### Shell functions for translating Coq Platform (Opam) package names to Coq CI package names ####

# This function expects $package to be set to a Coq Platform package name and
# Sets package_ci to the corresponding Coq CI package name
# In addition sets package_main to the opam package name without version

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

##### Shell functions for reading opam status for a package #####

# Check if package $1 is installed

function opam_check_installed() {
  [ "$(opam var "$1":installed)" == "true" ]
}

# Get installed version of package $1
# Only to be used if package is installed!

function opam_get_installed_version() {
  opam var "$1":version
}

# Get installed version of package $1
# Only to be used if package is installed!

function opam_get_installed_source_repo() {
  repo=$(opam show -f repository "$1")
  case $repo in
    default)             echo 'official repository https://opam.ocaml.org' ;;
    coq-core-dev)        echo 'official repository https://coq.inria.fr/opam/core-dev' ;;
    coq-extra-dev)       echo 'official repository https://coq.inria.fr/opam/extra-dev' ;;
    coq-released)        echo 'official repository https://coq.inria.fr/opam/released' ;;
    *patch_coq-dev)      echo 'platform patch repository https://github.com/coq/platform/tree/main/opam/opam-coq-archive/extra-dev' ;;
    *patch_coq-released) echo 'platform patch repository https://github.com/coq/platform/tree/main/opam/opam-coq-archive/released' ;;
    *patch_ocaml)        echo 'platform patch repository https://github.com/coq/platform/tree/main/opam/opam-repository' ;;
    *)                   echo 'unknown repository' ;;
  esac
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
  BODY="The Coq team released Coq ${COQ_PLATFORM_COQ_BASE_VERSION}${EXT_PRE} on ${DATE_PRE}
and plans to release Coq ${COQ_PLATFORM_COQ_BASE_VERSION}.0 before ${DATE_FINAL}.
A corresponding Coq Platform releases should be released before ${DATE_PLATFORM_EXPECTED}.
It can be dealyed in case of difficulties until ${DATE_PLATFORM_LATEST}, but this should be an exception.

Coq CI is currently testing commit $3
on branch $1/tree/$2
but we would like to ship a released version instead (a tag in git's slang).

${COQ_PLATFORM_MESSAGE}

Could you please create a tag, or communicate us any existing tag that works with
Coq branch ${COQ_PLATFORM_COQ_BRANCH}, preferably 15 days before ${DATE_PLATFORM_EXPECTED}?
In case we might have to delay the Coq Platform release cause of issues with
your project, we would prefer to be informed about the situation as early as possible.

Thanks!

P.S.: this issue has been created semi-automatically.

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
    if opam_check_installed "$package_main"
    then
      COQ_PLATFORM_MESSAGE="Coq Platform is currently testing opam version $(opam_get_installed_version "$package_main")"$'\n'"from $(opam_get_installed_source_repo "$package_main")."
    else
      COQ_PLATFORM_MESSAGE="Coq Platform is currently *not testing* this package!"
    fi

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

##### Clean up #####

rm /tmp/branch-ci-basic-overlay.sh
rm /tmp/master-ci-basic-overlay.sh
