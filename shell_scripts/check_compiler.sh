#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CHECK IF WE HAVE A COMPILER #####################

if [[ "$OSTYPE" == linux-gnu* ]]
then
	if ! command -v gcc &> /dev/null || ! command -v g++ &> /dev/null || ! command -v make &> /dev/null
	then
		cat <<-EOH
			=========================== Build tools required! ===========================
			This script requires build tools (make, a C compiler) to be installed.

			Please refer to the documentation on how to install these packages:

				gcc, g++, make

			Some distributions have a package "build-essentials"

			This script will exit now.
			Please restart the script after you installed the build tools.
			=========================== Build tools required! ===========================
			EOH
	return 1
	fi

elif [[ "$OSTYPE" == darwin* ]]
then

	if ! command -v gcc &> /dev/null || ! command -v g++ &> /dev/null || ! command -v make &> /dev/null
	then
		cat <<-EOH
			=========================== Build tools required! ===========================
			This script requires build tools (make, a C compiler) to be installed.

			The easiest way to install the build tools on macOS is:

			- install XCode via the app store
			- run the following command line in a terminal
				xcode-select --install

			This script will exit now.
			Please restart the script after you installed the build tools.
			=========================== Build tools required! ===========================
			EOH
		return 1
	fi

fi
