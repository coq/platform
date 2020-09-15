#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### INSTALL CoqIDE prerequisites #####################

# install gtk3 if not there (CoqIDE)
if ! pkg-config --short-errors --print-errors --atleast-version 3.18 gtk+-3.0
then
  $COQ_PLATFORM_TIME opam depext conf-gtk3
fi

# install gtksourceview3 if not there (CoqIDE)
if ! pkg-config --short-errors --print-errors gtksourceview-3.0
then
  $COQ_PLATFORM_TIME opam depext conf-gtksourceview3
fi

# install adwaita-icon-theme if not there (CoqIDE)
if ! pkg-config --short-errors --print-errors adwaita-icon-theme
then
  $COQ_PLATFORM_TIME opam depext conf-gnome-icon-theme3
fi