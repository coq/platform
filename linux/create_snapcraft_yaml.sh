#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2021 Enrico Tassi, Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CREATE scnapcraft.yml #####################

# This script creates snap craft yaml file from which a
# snap based Linux installer is created in a later step

###################### GATHER INFORMATION #####################

# Run the Coq Platform setup scripts but stop just after the installation of
# opam and setting up the switch but before installing packages.
# The purpose of this is not to setup the Coq Platform - this is done when
# the snapcraft.yaml file is run - but to gather information about the
# Coq Platform, e.g. the package lists.
# We also setup opam, since we get package descriptions from opam.

cd "$(dirname "$0")/.."
COQ_PLATFORM_OPAM_ONLY=y
source coq_platform_make.sh

# Snap versions cannot contain . nor +
PLATFORM_RELEASE=${COQ_PLATFORM_RELEASE//[.+]/-}

###################### CREATE SNAPCRAFT.YAML #####################

# Description of the snap
COQ_DESCRIPTION=`mktemp`
cat > $COQ_DESCRIPTION <<EOT
  The Coq proof assistant provides a formal language to write
  mathematical definitions, executable algorithms, and theorems, together
  with an environment for semi-interactive development of machine-checked
  proofs.
  
  This snap contains the Coq prover version $COQ_PLATFORM_COQ_TAG
  along with CoqIDE and the following packages:
EOT

for p in $(echo ${PACKAGES} | sed -e 's/ /\n/g' | sort); do
  pname=`echo $p | sed 's/\..*//'`
  if [ "${pname##coq-}" == "$pname" ]; then continue; fi
  pversion="$(opam show $p -f version: | tr -d \")"
  pdescr="$(opam show $p -f synopsis: | tr -d \")"
  pdescr_short="${pdescr:0:60}"
  if [ "$pdescr" != "$pdescr_short" ]
  then
    pdescr_short="${pdescr_short}..."
    echo "INFO: description for package $pname is too long and was truncated!"
    printf "ORIGINAL:  %s\n" "$pdescr"
    printf "TRUNCATED: %s\n" "$pdescr_short"
  fi
  printf "  * **%s**: %s (%s)\n" ${pname##coq-} "$pdescr_short" "$pversion" >> $COQ_DESCRIPTION
done

COQ_DESCRIPTION_LEN="$(wc -m < $COQ_DESCRIPTION)"
if [ "$COQ_DESCRIPTION_LEN" -gt 4096 ]
then
  echo "ERROR: the description text is too long: $COQ_DESCRIPTION_LEN > 4096"
  cat $COQ_DESCRIPTION
  exit 1
else
  echo "INFO: length of description text is OK: $COQ_DESCRIPTION_LEN <= 4096"
fi

mkdir -p snap/

sed \
   -e "s/@@PLATFORM_RELEASE@@/$PLATFORM_RELEASE/g" \
   -e "s/@@PLATFORM_ARGS@@/$*/g" \
   -e "/@@COQ_DESCRIPTION@@/r $COQ_DESCRIPTION" -e "/@@COQ_DESCRIPTION@@/d" \
   linux/snap/snapcraft.yaml.in > snap/snapcraft.yaml

echo "INFO: filled in snap/snapcraft.yaml"

mkdir -p snap/gui/

sed \
   -e "s/@@PLATFORM_RELEASE@@/$PLATFORM_RELEASE/g" \
   linux/snap/coq-prover.desktop.in > snap/gui/coq-prover.desktop

echo "INFO: filled in snap/gui/coqide.desktop"

echo -e "Done, now run:\n\tsnapcraft snap"

rm -f $COQ_DESCRIPTION
