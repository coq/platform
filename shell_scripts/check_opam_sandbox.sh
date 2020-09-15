#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

# Note: use help <builtin> to get information on bash builtin commands like "command"

###################### SANITY OPAM SANDBOX SCRIPT #####################

if [[ "$OSTYPE" == darwin* ]]
then

	# Check of opam sandbox script is current
	if !  grep "allow network" "$(opam var root)/opam-init/hooks/sandbox.sh"
	then
		cat <<-"EOH"
			======================== Outdated Opam sandbox script ========================
			Opam has a sandbox mechanism to ensure that build scripts do not modify
			files outside of their build tree. While youe opam version is OK,
			the version of your sandbox script is not. Unfortunately opam does not
			update this file after opam init. This means you need to update this file
			manually. Please replace the file

			$(opam var root)/opam-init/hooks/sandbox.sh
			
			With the version downloaded here:

			https://github.com/ocaml/opam/blob/2.0.7/src/state/shellscripts/sandbox_exec.sh

			for installation instructions. This script will exit now.
			Please restart the script after you updated the sandbox script.
			======================== Outdated Opam sandbox script ========================
			EOH
		exit 1
	fi

fi
