
#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Enrico Tassi
# (C) 2021 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### Notify Coq Platform Maintainers ######################

# This script interactively creates upstream issues to notify coq platform
# package maintainers that while their current tag works, they might want to update.

# $1: Path of Coq Platform package list file

set -o nounset
set -o errexit

##### Settings #####

EXT_PRE="+rc1"
DATE_PRE="September 17, 2021"

DATE_FINAL="October 31, 2021"

DATE_PLATFORM_EXPECTED="November 30, 2021"
DATE_PLATFORM_LATEST="January 31, 2022"

CC="CC: https://github.com/coq/platform/issues/139"
#CC="\n@coqbot column:...."

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

# Get issue reporting URL for package $1

function opam_get_installed_issue_url() {
  opam show -f bug-reports "$1" | tr -d '"'
}

##### Shell functions for creating GIT server issue URL #####

# https://gist.github.com/cdown/1163649
function urlencode() {
    # urlencode <string>

    old_lc_collate=${LC_COLLATE:-}
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
  TITLE="Informative: pick of tag for upcoming release of Coq Platform for Coq ${COQ_PLATFORM_COQ_BASE_VERSION}"
  BODY="The Coq team released Coq ${COQ_PLATFORM_COQ_BASE_VERSION}${EXT_PRE} on ${DATE_PRE}
and plans to release Coq ${COQ_PLATFORM_COQ_BASE_VERSION}.0 before ${DATE_FINAL}.
A corresponding Coq Platform releases should be released before ${DATE_PLATFORM_EXPECTED}.
It can be dealyed in case of difficulties until ${DATE_PLATFORM_LATEST}, but this should be an exception.

This issue is to inform you that your latest tag does work fine with Coq ${COQ_PLATFORM_COQ_BASE_VERSION}${EXT_PRE}.

Coq Platform currently uses the opam package '$2'
from $(opam_get_installed_source_repo "$2").${flex_message}

In case this is the version you want to see in Coq Platform, there is nothing to do for you - just close this issue.

In case you would prefer to see an updated version in the upcoming Coq Platform, please inform as as soon as possible!
In this case please **don't** close this issue, even after creating the new tag and/or opam package. We will close the issue after updating Coq Platform.

In any case, Coq Platform won't be released before this issue is closed!

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

COQ_PLATFORM_EXTENT=x
COQ_PLATFORM_COMPCERT=y
COQ_PLATFORM_VST=y

source $1

COQ_PLATFORM_COQ_BASE_VERSION=${COQ_PLATFORM_COQ_BRANCH#v}

echo COQ_PLATFORM_COQ_BASE_VERSION = "${COQ_PLATFORM_COQ_BASE_VERSION}"
echo COQ_PLATFORM_COQ_BRANCH       = "${COQ_PLATFORM_COQ_BRANCH}"
echo COQ_PLATFORM_COQ_TAG          = "${COQ_PLATFORM_COQ_TAG}"
echo PACKAGES                      = "${PACKAGES}"

##### Main loop #####

for package in ${PACKAGES}
do
  package_main="${package%%.*}"
  case ${package_main} in
    coq-*)   ;;
    gappa*)  ;;
    elpi*)   ;;
    *)       continue;
  esac

  case ${package} in
    coq-*~flex) flex_message=$'\n
__Note:__ We had to patch version restrictions in the opam package and possibly the make file to accept the new version of Coq, but no other changes were required.'
      ;;
    coq-*.dev)  continue ;; # This needs a new tag
    *) flex_message=''
  esac

  if opam_check_installed "$package_main"
  then
    echo -e "\n----------------------------------------------"
    issue_url="$(opam_get_installed_issue_url "$package_main")"
    git_url="${issue_url%/issues}"
    echo $issue_url $git_url
    echo "Available tags for ${package} are:"
    git -c 'versionsort.suffix=-' ls-remote --refs --tags --sort='v:refname' "${git_url}" | sed 's|.*refs/tags/||'
    template "${git_url}" "${package}"
  fi
done
