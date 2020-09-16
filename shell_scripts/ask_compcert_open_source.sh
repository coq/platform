#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### USER CHOICES #####################

# CompCert open source or full

if [ -z "${COQ_PLATFORM_COMPCERT:+x}" ]
then
cat <<EOH
================================== COMPCERT ==================================
The Coq platform installs the formally verified C compiler CompCert.

CompCert is *not* free / open source software, but may be used for research and
evaluation purposes. Please clarify the license at:

https://github.com/AbsInt/CompCert/blob/master/LICENSE

Parts of CompCert are required for the Princeton C verification tool VST.
Some parts of CompCert are open source and for exploring or learning VST
using the supplied example programs, this open source part is sufficient.
If you want to use VST with your own C code, you need the non open source
variant of CompCert. Before you install the full non-free version of CompCert,
please make sure that your intended usage conforms to the above license.

If you answer n=no below to skip CompCert, VST will also not be installed.

You can also change this later using opam commands.
================================== COMPCERT ==================================
EOH
  ask_user_opt3_cancel "Install full (f), open source (o) or no (n) CompCert?" fF "full" oO "open source" nN "none"
  COQ_PLATFORM_COMPCERT=$ANSWER
fi
