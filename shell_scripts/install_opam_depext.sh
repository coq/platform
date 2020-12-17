#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### INSTALL pkg-config #####################

echo "===== INSTALL OPAM DEPEXT ====="

opam --version

if [ "$OSTYPE" == cygwin ]
then
  $COQ_PLATFORM_TIME opam install depext depext-cygwinports
else
  $COQ_PLATFORM_TIME opam install depext
fi
