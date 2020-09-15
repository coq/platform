#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### USER CHOICES #####################

# introduction

if [ ! "${COQ_PLATFORM_INTRO:-Y}" = "N" ]
then
cat <<EOH
================================ INTRODUCTION ================================
This script installs the Coq platform version $COQ_PLATFORM_VERSION, that is:

- the Coq compiler and Coq's standard library
- CoqIDE, a GTK3 based graphical user interface
- various widely used libraries and plugins

The script uses opam, the OCaml package manager, to do all the work.
In case opam is not yet installed, it will install opam.
A new opam switch named $COQ_PLATFORM_SWITCH_NAME will be created.

The script compiles everything from sources, which might takes less than one
hour on a fast machine with lot's of RAM, or up to 6 hours with little RAM.

The script is tested on these platforms:
- Windows 10 with cygwin installed by coq_platform_make_windows.bat
- macOS Catalina 10.15.4 with XCode 11.0.3
- Ubuntu 18.04 LTS
In case you have issues, please report a bug at:
https://github.com/MSoegtropIMC/coq-platform/issues
================================ INTRODUCTION ================================
EOH
ask_user_opt1_cancel "Enter y to continue with compiling/installing the Coq platform!" yY yes
fi
