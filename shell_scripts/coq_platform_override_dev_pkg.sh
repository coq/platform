#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### OVERRIDES #####################

for override in ${COQ_PLATFORM_OVERRIDE_DEV:-}
do
    pkg="${override%%=*}"
    url="${override#*=}"
    echo "Overriding $pkg.dev url with $url"
    mkdir -p opam/opam-coq-archive/extra-dev/packages/$pkg/$pkg.dev/
    opam show --raw $pkg.dev | tr -s '\n' ' ' | sed "s@ src: [^ ]*@ src: \"$url\"@" > opam/opam-coq-archive/extra-dev/packages/$pkg/$pkg.dev/opam
done

if [ ! -z "${COQ_PLATFORM_OVERRIDE_DEV:-}" ]; then
    opam update
fi
