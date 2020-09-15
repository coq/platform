#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### INSTALL Gappa prerequisites #####################

# install GMP, MPFR, BOOST if not there (gappa)
# Note: There is no easy way to check if boost is installed, so check if gappa itself is installed.
#       If the script is run again, this should be a sufficient test.

if [ $(opam var "gappa:installed") == "false" ]
then
  opam depext gappa
fi
