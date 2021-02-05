#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### Select a python interperter #####################

# Cygwin stopped to have a /usr/bin/python symlink, but some build scripts
# expect that there is *a* python.

if [[ "$OSTYPE" == cygwin ]]
then
  ln -s -f /usr/bin/python2 /usr/bin/python
fi

###################### Fix tar in 32 bit cygwin #####################

# Cygwin updated to tar 1.33 which is broken on Cygwin 32

if [[ "$OSTYPE" == cygwin ]]
then
  if [ "`uname -m`" = "i686" ]; then
    wget http://mirrors.kernel.org/sourceware/cygwin/x86/release/tar/tar-1.32-2.tar.xz -O /tmp/tar-1.32-2.tar.xz
    tar xvf /tmp/tar-1.32-2.tar.xz -C /
  fi
fi

###################### Fix binutils in 64 bit cygwin #####################

# Cygwin updated to mingw64-x86_64-binutils is broken on Cygwin 64

if [[ "$OSTYPE" == cygwin ]]
then
  if [ "`uname -m`" = "x86_64" ]; then
    wget http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/mingw64-x86_64-binutils/mingw64-x86_64-binutils-2.35.1-1.tar.xz -O /tmp/mingw64-x86_64-binutils-2.35.1-1.tar.xz
    tar xvf /tmp/mingw64-x86_64-binutils-2.35.1-1.tar.xz -C /
  fi
fi
