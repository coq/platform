#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### INSTALL pkg-config #####################

# Note: for each depext package we check upfront if it is there.
# This has the advantage that all stuff requring sudo is at the begining.
# Usually running one sudo command upfront is enough to keep the password for 15 minutes.

# install pkg-config if it is not there
if ! command -v pkg-config &> /dev/null
then
  $COQ_PLATFORM_TIME opam depext conf-pkg-config
fi
