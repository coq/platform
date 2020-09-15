#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### SANITY CHECK SYSTEM PREREQUISITES #####################

if [[ "$OSTYPE" == linux-gnu* ]]
then

	check_command_available curl

elif [[ "$OSTYPE" == darwin* ]]
then

	# On macOS we definitely need a package manager
	if ! command -v port &> /dev/null && !command -v brew &> /dev/null
	then
		cat <<-EOH
			======================= MacPorts or HomeBrew required! =======================
			This script installs quite a few system prerequisites and requires either
			MacPorts or Homebrew to be installed for this purpose - neither was found.

			The author of this script uses MacPorts, so this is better tested, but
			Homebrew should also work fine. Homebrew makes some system folders writable
			for the current user so that installations do not require sudo. This makes
			things easier but might be a security risk, so the author uses MacPorts.

			Please refer to:

			https://www.macports.org/install.php
			AND/OR
			https://brew.sh

			for installation instructions. This script will exit now.
			Please restart the script after you installed either MacPorts or Homebrew.
			======================= MacPorts or HomeBrew required! =======================
			EOH
		exit 1
	fi

elif [[ "$OSTYPE" == cygwin ]]
then

	if [ "${COQ_PLATFORM_CYGWIN_OK:+N}" != "Y" ]
	then
		cat <<-EOH
			================================= Bad Cygwin =================================
			This script requires MinGW cross build tools (make, a C compiler) and a lot
			of other prerequisites. Since Cygwin does not include a package manager,
			the best way to ensure that all packages are there is to use the script

			    coq_platform_make_windows.bat

			to setup cygwin and run coq_platform_make.sh. Apparently you did run the script
			coq_platform_make.sh directly from a pre-existing cygwin installation.
			This is not supported.

			This script will exit now.
			Please start the script via coq_platform_make_windows.bat from a DOS shell.
			================================= Bad Cygwin =================================
			EOH
		exit 1
	fi

else
		echo "ERROR: unsopported OS type '$OSTYPE'"
		exit 1
fi
