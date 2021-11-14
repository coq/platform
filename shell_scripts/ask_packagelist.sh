#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### USER CHOICES #####################

# package list

if [ -z "${COQ_PLATFORM_PACKAGELIST:+x}" ]
then
cat <<EOH
========================= SELECT PACKAGELIST VERSION ==========================
The Coq Platform allows to install the latest release version of Coq and
packages, but also older versions or development versions of Coq. You can
install several versions of Coq in parallel, which simplifies porting of
developments. You can use "opam switch" to switch between Coq versions.

The following versions / package lists are supported:
EOH

  packagefile_list="$( (for file in versions/packages-*.sh; do echo "$(grep "COQ_PLATFORM_VERSION_SORTORDER=" $file) $file"; done) | tr '=' ' ' | sed 's/  */ /g' | sort -n | cut -d ' ' -f 3)"

  packageindex=0
  for packagefile in ${packagefile_list}
  do
      if ! grep -q "COQ_PLATFORM_VERSION_SORTORDER=" "$packagefile"; then echo "ERROR: package file '$packagefile' does not contain 'COQ_PLATFORM_VERSION_SORTORDER' definition."; fail; fi
      if ! grep -q "COQ_PLATFORM_VERSION_TITLE=" "$packagefile"; then echo "ERROR: package file '$packagefile' does not contain 'COQ_PLATFORM_VERSION_TITLE' definition."; fail; fi
      packageindex=$((${packageindex} + 1))
      notes="$(grep 'COQ_PLATFORM_VERSION_TITLE=' "${packagefile}" | tr '=' ' ' | tr -d '"' | sed 's/  */ /g' | cut -d ' ' -f 2-)"
      echo "(${packageindex}): $notes"
  done

cat <<EOH

Pleas select a version by entering the number shown at the begin of a line.
========================= SELECT PACKAGELIST VERSION ==========================
EOH
  ask_user_number "Select package list" 1 "${packageindex}"
  packageindex=0
  for packagefile in ${packagefile_list}
  do
    packageindex=$((${packageindex} + 1))
    if [ "${packageindex}" -eq "${ANSWER}" ]
    then
      COQ_PLATFORM_PACKAGELIST="${packagefile}"
    fi
  done
  if [ -z "${COQ_PLATFORM_PACKAGELIST:+x}" ]
  then
    echo "INTERNAL ERROR: not package list file selected!"
    false
  fi
fi
