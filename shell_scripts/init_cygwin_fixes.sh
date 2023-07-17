#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### Select a python interpreter #####################

# Cygwin stopped to have a /usr/bin/python symlink, but some build scripts
# expect that there is *a* python.

if [[ "$OSTYPE" == cygwin ]]
then
  ln -s -f /usr/bin/python3 /usr/bin/python
fi

###################### Fix tar in 32 bit cygwin #####################

# Cygwin updated to tar 1.33 which is broken on Cygwin 32

if [[ "$OSTYPE" == cygwin ]]
then
  if [ "`uname -m`" = "i686" ]; then
    wget https://mirrors.kernel.org/sourceware/cygwin-archive/20221123/x86/release/tar/tar-1.32-2.tar.xz -O /tmp/tar-1.32-2.tar.xz
    tar xvf /tmp/tar-1.32-2.tar.xz -C /
  fi
fi
