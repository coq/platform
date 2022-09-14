#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2021..2022 Michael Soegtrop
# (C) 2020 Enrico Tassi

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### Create Readme.md ######################

# This script creates from an opam installation a README.md file with:
# - name, version, synopsis and description of each primary package
# - name, version, synopsis and description of each dependency package
# - information about licenses, project homepages, ...

##### Initialization #####

set -o nounset
set -o errexit

SCRIPT_PATH="$(dirname "$0")"
ROOT_PATH="$(dirname "${SCRIPT_PATH}")"
DOC_PATH="${ROOT_PATH}/doc"
cd "${ROOT_PATH}"

##### Parameters #####

CHECKOPAMLINKS='Y'
COQ_PLATFORM_PACKAGE_PICK_NAME=''

for arg in "$@"
do
  case "${arg}" in
    -quick|-q)             CHECKOPAMLINKS='N' ;;
    -pick=*|-p=*|-v=*)     COQ_PLATFORM_PACKAGE_PICK_NAME="${arg#*=}";;
    -packages=*)           COQ_PLATFORM_PACKAGE_PICK_NAME="${arg#*=}";;
    -output=*|-o=*)        RESULT_FILE_MD="${arg#*=}";;
    -table=*|-t=*)         RESULT_FILE_CSV="${arg#*=}";;
    *) echo "Illegal option ${arg}"; exit 1 ;;
  esac
done

# allow short form names for packages
if [ -z "${COQ_PLATFORM_PACKAGE_PICK_NAME}" ]
then
  echo "Please specify a package list file with the -packages=<package-file> option"
  exit 1
else
  for prefix1 in "" "package_picks/"
  do
    for prefix2 in "" "package-pick-"
    do
      for postfix in "" ".sh"
      do
        testname="${prefix1}${prefix2}${COQ_PLATFORM_PACKAGE_PICK_NAME}${postfix}"
        if [ -f "${testname}" ]
        then
          COQ_PLATFORM_PACKAGE_PICK_FILE="${testname}"
        fi
      done
    done
  done
fi

##### Utility functions #####

# Check if a space separated list contains an item
# $1 = list
# $2 = item

function list_contains {
    [[ " $1 " == *" $2 "* ]]
}

# Check if a list contains an item with prefix
# $1 = list
# $2 = prefix

function list_contains_prefix {
    [[ " $1 " == *" $2"* ]]
}

# Filter a package list and remove packages from lower levels
# $1 = package list string
# $2 = packages from previous level
# $3 = true to apply name based filter, false otherwise

function filter_package_list() {
  local packages="$1"
  local exclude="$2"
  if $3
  then
    packages="$(echo "${packages}" | tr -s ' ' '\n' | grep -v '^ocaml\|^opam\|^depext\|^conf\|^lablgtk\|^elpi' | tr -s '\n' ' ')"
  else
    # exclude gets filtered, so don't exclude packages which get filtered
    exclude="$(echo "${exclude}" | tr -s ' ' '\n' | grep -v '^ocaml\|^opam\|^depext\|^conf\|^lablgtk\|^elpi' | tr -s '\n' ' ')"
  fi
  packages_filtered=''
  for package in $packages
  do
    if ! list_contains "${exclude}" "${package}"
    then
      packages_filtered="${packages_filtered} ${package}"
    fi
  done
  echo "${packages_filtered}" |  tr -s ' ' '\n' | sed -E 's/(.*)/\1 \1/' | sed 's/^conf-|^-coq//' | sort | cut -d ' ' -f2 | tr -s '\n' ' '
}

# Check if a URL exists
# $1 url

function check_url {
  curl --head --silent --fail "$1" >/dev/null
}

# Check if an (opam) license name has an SPDX record
# $1 = name of license
# $2 = name of package (for warnings)

declare -A SPDX_LICENSE

function check_spdx_license {
  if [ -z ${SPDX_LICENSE[$1]+_} ]
  then
    if check_url "https://spdx.org/licenses/$1.html"
    then
      SPDX_LICENSE[$1]=yes
    else
      SPDX_LICENSE[$1]=no
    fi
  fi

  if [ "${SPDX_LICENSE[$1]}" == "yes" ]
  then
      return 0
  else
    echo "License for package '$2' with name '$1' has no SPDX record" >> WARNINGS.log
    return 1
  fi
}

# HTML escape the argument (only basic)

function html_escape {
  local string="$1"
  string="${string//&/&amp;}"
  string="${string//</&lt;}"
  string="${string//>/&gt;}"
  string="${string//\"/&quot;}"
  string="${string//\'/&apos;}"
  string="${string//\\n/<br>}"
  echo "${string}"
}

# Get opam package url from repo name and package name
# $1 repo name (opam show -f repository <package>)
# $2 package name

function opam_get_installed_opam_repo() {
  case "$1" in
    default)             local url='https://opam.ocaml.org' ;;
    coq-core-dev)        local url='https://coq.inria.fr/opam/core-dev' ;;
    coq-extra-dev)       local url='https://coq.inria.fr/opam/extra-dev' ;;
    coq-released)        local url='https://coq.inria.fr/opam/released' ;;
    *patch_coq-dev)      local url='https://github.com/coq/platform/tree/main/opam/opam-coq-archive/extra-dev' ;;
    *patch_coq-released) local url='https://github.com/coq/platform/tree/main/opam/opam-coq-archive/released' ;;
    *patch_ocaml)        local url='https://github.com/coq/platform/tree/main/opam/opam-repository' ;;
    *)                   return 1 ;;
  esac
  local package_main="${2%%.*}"
  echo ${url}/packages/${package_main}/$2/opam
}

##### Read package list file in different configurations #####

BITSIZE=64

COQ_PLATFORM_EXTENT=b
source ${COQ_PLATFORM_PACKAGE_PICK_FILE}
PACKAGES_BASE="${PACKAGES//PIN.}"

COQ_PLATFORM_EXTENT=i
source ${COQ_PLATFORM_PACKAGE_PICK_FILE}
PACKAGES_IDE="${PACKAGES//PIN.}"

COQ_PLATFORM_EXTENT=f
COQ_PLATFORM_COMPCERT=n
COQ_PLATFORM_VST=n
source ${COQ_PLATFORM_PACKAGE_PICK_FILE}
PACKAGES_FULL="${PACKAGES//PIN.}"

COQ_PLATFORM_EXTENT=f
COQ_PLATFORM_COMPCERT=y
COQ_PLATFORM_VST=y
source ${COQ_PLATFORM_PACKAGE_PICK_FILE}
PACKAGES_OPTIONAL="${PACKAGES//PIN.}"

COQ_PLATFORM_EXTENT=x
COQ_PLATFORM_COMPCERT=y
COQ_PLATFORM_VST=y
source ${COQ_PLATFORM_PACKAGE_PICK_FILE}
PACKAGES_EXTENDED="${PACKAGES//PIN.}"

source ${ROOT_PATH}/package_picks/coq_platform_release.sh

package_list_notes="$(grep '# DESCRIPTION'  "${COQ_PLATFORM_PACKAGE_PICK_FILE}" | sed 's/  */ /g' | cut -d ' ' -f 3-)"

##### Determine name of output files #####

RESULT_FILE_MD="${RESULT_FILE_MD:-${DOC_PATH}/README${COQ_PLATFORM_PACKAGE_PICK_POSTFIX}.md}"
RESULT_FILE_CSV="${RESULT_FILE_CSV:-${DOC_PATH}/PackageTable${COQ_PLATFORM_PACKAGE_PICK_POSTFIX}.csv}"

##### Get list of all installed packages from opam #####

source ${ROOT_PATH}/package_picks/coq_platform_switch_name.sh

opam switch "${COQ_PLATFORM_SWITCH_NAME}"

PACKAGES_ALL="$(opam list --installed --short --columns=name,version | sed 's/  */./' | tr -s '\n' ' ')"

##### Sanity checks #####

# The first sanity check - that the switch exists - is already done above.

# Check if all packages from the extended platform are in the switch.
# If this is not the case, dependencies might be missing.

for package in ${PACKAGES_EXTENDED}
do
  if ! list_contains "${PACKAGES_ALL}" "${package}"
  then
    echo "ERROR: the package '${package}' is not included in opam switch ${COQ_PLATFORM_SWITCH_NAME}"
    exit 1
  fi
done

##### Filter package lists #####

echo PACKAGES_BASE="${PACKAGES_BASE}"
echo PACKAGES_IDE="${PACKAGES_IDE}"
echo PACKAGES_FULL="${PACKAGES_FULL}"
echo PACKAGES_OPTIONAL="${PACKAGES_OPTIONAL}"
echo PACKAGES_EXTENDED="${PACKAGES_EXTENDED}"
echo PACKAGES_ALL="${PACKAGES_ALL}"

PACKAGES_ALL="$(filter_package_list "${PACKAGES_ALL}" "${PACKAGES_EXTENDED}" false)"
PACKAGES_EXTENDED="$(filter_package_list "${PACKAGES_EXTENDED}" "${PACKAGES_OPTIONAL}" true)"
PACKAGES_OPTIONAL="$(filter_package_list "${PACKAGES_OPTIONAL}" "${PACKAGES_FULL}" true)"
PACKAGES_FULL="$(filter_package_list "${PACKAGES_FULL}" "${PACKAGES_IDE}" true)"
PACKAGES_IDE="$(filter_package_list "${PACKAGES_IDE}" "${PACKAGES_BASE}" true)"
PACKAGES_BASE="$(filter_package_list "${PACKAGES_BASE}" "" true)"

echo PACKAGES_BASE="${PACKAGES_BASE}"
echo PACKAGES_IDE="${PACKAGES_IDE}"
echo PACKAGES_FULL="${PACKAGES_FULL}"
echo PACKAGES_OPTIONAL="${PACKAGES_OPTIONAL}"
echo PACKAGES_EXTENDED="${PACKAGES_EXTENDED}"
echo PACKAGES_ALL="${PACKAGES_ALL}"

##### Create one README.md entry #####

# Create Html (suitable for MD) and CSV entry for package
# $1 = package name (may or may not include version)
# $2 = Coq Platform level

function html_package_opam {
  echo "Create README for $1"

  # Get package information from opam
  # Example output (with 2 license fields ...)
  # opam show "conf-adwaita-icon-theme" -f version:,license:,synopsis:,homepage:
  # version:  "1"
  # license:  "LGPL-3.0-only" "CC-BY-SA-3.0"
  # synopsis: "Virtual package relying on adwaita-icon-theme"
  # homepage: "https://github.com/GNOME/adwaita-icon-theme"
  # Note: the process substitution (rather than pipe) avoids a subshell, so that variables can be set.
  # Note: the declare -a var="(list)" makes it possible to convert a list of quoted strings to an array
  unset pversion plicense psynopsis phomepage pbugreports pdescription pauthors prepository
  multiline=''
  while read -r var value
  do
      case "${var}" in
      version:)     pversion="${value//\"}"; multiline='' ;;
      license:)     declare -a plicense="(${value})"; multiline='' ;;
      synopsis:)    psynopsis="${value//\"}"; multiline='' ;;
      homepage:)    phomepage="${value//\"}"; multiline='' ;;
      bug-reports:) pbugreports="${value//\"}"; multiline='' ;;
      description:) pdescription="${value//\"}"; multiline='' ;;
      authors:)     pauthors="${value//\"}"; multiline=pauthors ;;
      repository)   prepository="${value//\"}"; multiline='' ;;
      *)
        if [ -n "$multiline" ] 
        then
          declare $multiline="${!multiline} - ${var//\"} ${value//\"}"
        else
          echo "Unexpected result from opam show: $var $value"; exit 1
        fi ;;
    esac
  done < <(opam show "$1" -f version:,license:,synopsis:,homepage:,bug-reports:,description:,authors:,repository)

  # Remove conf- prefix for printing of package name
  package_pretty=${package/conf-}

  # Some author field contain a empty email reference, which doesn't look nice
  pauthors="${pauthors//<>/}"
  # Do basic HTML escaping for synposis
  # I used 'recode' for this, but it is rather fragile, and this should be good enough
  psynopsis=$(html_escape "${psynopsis}")
  pdescription=$(html_escape "${pdescription}")
  pauthors=$(html_escape "${pauthors}")
  
  # Elaborate license information
  if [ ${#plicense[@]} -eq 0 ]
  then
    echo "License for package '${package}' is unspecified" >> WARNINGS.log
    licensehtml="unknown - please clarify with <a href=\"${phomepage}\" target=\"_blank\">homepage</a>"
    licensecsv="unknown"
  else
    licensehtml=""
    licensecsv=""
    for license in "${plicense[@]}"
    do
      license="${license//\"}"
      license=${license/CeCILL/CECILL}
      if [[ "${license}" == 'https://'* ]] || [[ "${license}" == 'http://'* ]]
      then
        licensehtml="${licensehtml} <a href=\"${license}\" target=\"_blank\">link</a>"
        licensecsv="${licensecsv}${licensecsv:+,}${license}"
      elif check_spdx_license "${license}" "${package}"
      then
        licensehtml="${licensehtml} <a href=\"https://spdx.org/licenses/${license}.html\" target=\"_blank\">${license}</a>"
        licensecsv="${licensecsv}${licensecsv:+,}https://spdx.org/licenses/${license}.html"
      else
        licensehtml="${licensehtml} ${license} - see <a href=\"${phomepage}\" target=\"_blank\">homepage</a> for details"
        licensecsv="${licensecsv}${licensecsv:+,}${license}"
      fi
    done
  fi

  # Look up the opam package URL
  popam_url="$(opam_get_installed_opam_repo "${prepository}" "$1")"
  if [ "${CHECKOPAMLINKS}" == 'Y' ] && ! check_url "${popam_url}"
  then
    echo "opam url '${popam_url}' for package '${package}' does not exist!" >> WARNINGS.log
  fi

  # Create final HTML text for package
  printf "<details>\n" >> ${RESULT_FILE_MD}
  printf "  <summary><a href='%s'>%s</a>\n(%s) %s</summary>\n" "${phomepage}" "${package_pretty}" "${pversion}" "${psynopsis}" >> ${RESULT_FILE_MD}
  printf "  <dl>\n" >> ${RESULT_FILE_MD}
  printf "    <dt><b>authors</b></dt><dd>%s</dd>\n" "${pauthors}" >> ${RESULT_FILE_MD}
  printf "    <dt><b>license</b></dt><dd>%s</dd>\n" "${licensehtml}" >> ${RESULT_FILE_MD}
  printf "    <dt><b>links</b></dt><dd>\n" >> ${RESULT_FILE_MD}
  if [ -n "${phomepage}" ]
  then  
    printf "      (<a href='%s'>homepage</a>)\n" "${phomepage}" >> ${RESULT_FILE_MD}
  fi
  if [ -n "${pbugreports}" ]
  then  
    printf "      (<a href='%s'>bug reports</a>)\n" "${pbugreports}" >> ${RESULT_FILE_MD}
  fi
  if [ -n "${popam_url}" ]
  then  
    printf "      (<a href='%s'>opam package</a>)\n" "${popam_url}" >> ${RESULT_FILE_MD}
  fi
  printf "    </dd>\n" >> ${RESULT_FILE_MD}
  printf "    <dt><b>description</b></dt><dd>%s</dd>\n" "${pdescription}" >> ${RESULT_FILE_MD}
  printf "  </dl>\n" >> ${RESULT_FILE_MD}
  printf "</details>\n\n" >> ${RESULT_FILE_MD}

  # Create CSV entry for package
  package_main="${1%%.*}"
  printf '"%s","%s","%s","%s"\n' "${package_main}" "${pversion}" "${licensecsv}" "$2" >> ${RESULT_FILE_CSV}
}

##### Create README.md and README.csv #####

# Write CSV header

echo "package,version,license,level" > ${RESULT_FILE_CSV}

# Write MD header

cat > ${RESULT_FILE_MD} <<EOT
# Coq Platform ${COQ_PLATFORM_RELEASE} providing ${COQ_PLATFORM_VERSION_TITLE}

The [Coq proof assistant](https://coq.inria.fr) provides a formal language
to write mathematical definitions, executable algorithms, and theorems, together
with an environment for semi-interactive development of machine-checked proofs.

The [Coq Platform](https://github.com/coq/platform) is a distribution of the Coq
interactive prover together with a selection of Coq libraries and plugins.

The Coq Platform supports to install several versions of Coq (also in parallel).
This README file is for **Coq Platform ${COQ_PLATFORM_RELEASE} with Coq ${COQ_PLATFORM_COQ_TAG}**.
The README files for other versions are linked in the main [README](../README.md).

${COQ_PLATFORM_VERSION_DESCRIPTION}

The OCaml version used is $(opam switch invariant | tr -d '"[]{}' | sed 's/.*= //').

The Coq Platform supports four levels of installation extent:
**base**, **IDE**, **full** and **extended** and a few **optional** packages.
The sections below provide a short description of each level and the list of
packages included in each level. Packaged versions of the Coq Platform usually
contain the **extended** set with all optional packages.

**Note on non-free licenses:** The Coq Platform contains software with
**non-free licenses which do not allow commercial use without purchasing a license**,
notably the **coq-compcert** package. Please study the package licenses given
below and verify that they are compatible with your intended use in case you
plan to use these packages.

**Note on license information:**
The license information given below is obtained from opam.
The Coq Platform team does no double check this information.

**Note on multiple licenses:** 
In case several licenses are given below, it is not clearly specified what this means.
It could mean that parts of the software use one license while other parts use another license.
It could also mean that you can choose between the given licenses.
Please clarify the details with the homepage of the package.

**Note:** The package list is also available as [CSV](${RESULT_FILE_CSV#${DOC_PATH}/}).

**Note:** Click on the triangle to show additional information for a package!

<br>

## **Coq Platform ${COQ_PLATFORM_RELEASE} with Coq ${COQ_PLATFORM_COQ_TAG} "base level"**

The **base level** is mostly intended as a basis for custom installations using
opam and contains the following package(s):

EOT

for package in ${PACKAGES_BASE}
do
  html_package_opam "${package}" base
done

cat >> ${RESULT_FILE_MD} <<EOT
<br>

## **Coq Platform ${COQ_PLATFORM_RELEASE} with Coq ${COQ_PLATFORM_COQ_TAG} "IDE level"**

The **IDE level** adds an interactive development environment to the **base level**.

For beginners, e.g. following introductory tutorials, this level is usually sufficient.
If you install the **IDE level**, you can later add additional packages individually
via \`opam install <package-name>\` or rerun the Coq Platform installation script
and choose the full or extended level.

The **IDE level** contains the following package(s):

EOT

for package in ${PACKAGES_IDE}
do
  html_package_opam "${package}" ide
done

cat >> ${RESULT_FILE_MD} <<EOT
<br>

## **Coq Platform ${COQ_PLATFORM_RELEASE} with Coq ${COQ_PLATFORM_COQ_TAG} "full level"**

The **full level** adds many commonly used coq libraries, plug-ins and
developments.

The packages in the **full level** are mature, well maintained
and suitable as basis for your own developments.
See the Coq Platform [charter](charter.md) for details.

The **full level** contains the following packages:

EOT

for package in ${PACKAGES_FULL}
do
  html_package_opam "${package}" full
done

cat >> ${RESULT_FILE_MD} <<EOT
<br>

## **Coq Platform ${COQ_PLATFORM_RELEASE} with Coq ${COQ_PLATFORM_COQ_TAG} "optional packages"**

The **optional** packages have the same maturity and maintenance level as the
packages in the full level, but either have a **non open source license** or
depend on packages with non open source license.

The interactive installation script and the Windows installer explicitly ask
if you want to install these packages.

The macOS and snap installation bundles always include these packages.

The following packages are **optional**:

EOT

for package in ${PACKAGES_OPTIONAL}
do
  html_package_opam "${package}" optional
done

cat >> ${RESULT_FILE_MD} <<EOT
<br>

## **Coq Platform ${COQ_PLATFORM_RELEASE} with Coq ${COQ_PLATFORM_COQ_TAG} "extended level"**

The **extended level** contains packages which are in a beta stage or otherwise
don't yet have the level of maturity or support required for inclusion in the
full level, but there are plans to move them to the full level in a future
release of Coq Platform. The main point of the extended level is advertisement:
users are important to bring a development from a beta to a release state.

The interactive installation script explicitly asks if you want to install these packages.
The macOS and snap installation bundles always include these packages.
The Windows installer also includes them, and they are selected by default.

The **extended level** contains the following packages:

EOT

for package in ${PACKAGES_EXTENDED}
do
  html_package_opam "${package}" extended
done

cat >> ${RESULT_FILE_MD} <<EOT
<br>

## **Dependency packages**

In addition the dependencies listed below are partially or fully included or required during build time.
Please note, that the version numbers given are the versions of opam packages,
which do not always match with the version of the supplied packages.
E.g. some opam packages just refer to latest packages e.g. installed by MacPorts,
Homebrew or Linux system package managers.
Please refer to the linked opam package and/or your system package manager for details on what software version is used.

EOT

# sort packages by name, but ignore a "conf-" prefix
for package in ${PACKAGES_ALL}
do
  html_package_opam "${package}" dependency
done
