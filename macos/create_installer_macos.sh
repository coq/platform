#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CREATE MAC DMG INSTALLER ######################

# Script safety

set -o nounset
set -o errexit

# Check if required utilities are installed

command -v gfind || ( echo "Install gfind (eg. sudo port install findutils)" ; exit 1)
command -v pip3 || ( echo "Install pip3 (eg. sudo port install py38-pip; port select --set pip3 pip38)" ; exit 1)

# Create working folder

rm -rf macos_installer/
mkdir macos_installer/
cd macos_installer/

###### Get the Coq sourcees from opam #####

# Get installed version of coq (otherwise opam source gives the latest)
coqpackagefull=$(opam list --installed-roots --short --columns=name,version coq | sed 's/ /./')
opam source --dir=coq/ $coqpackagefull

##### Get the version of Coq #####

COQ_VERSION=$(coqc --print-version | cut -d ' ' -f 1)

# The MacOS version needs to be purely numeric (no +beta) and is set separately in configure.ml
COQ_VERSION_MACOS=$(egrep -o 'coq_macos_version *= *"[0-9.]+"' coq/configure.ml | cut -d '=' -f 2 | tr -d ' "')

echo "##### Building Mac DMG installer for Coq $COQ_VERSION (MacVersion=$COQ_VERSION_MACOS) #####"

##### Create DMG package foldr structure #####

# Base folder

APP=_dmg/Coq_${COQ_VERSION}.app

# Create Info.plist file

mkdir -p ${APP}/Contents/
sed -e "s/VERSION/$COQ_VERSION_MACOS/g" coq/ide/coqide/MacOS/Info.plist.template > \
    ${APP}/Contents/Info.plist

##### Copy resource files the installed binaries depend on #####

echo '##### Copy resources #####'

# Create resource folder in DMG folder

mkdir -p ${APP}/Contents/Resources

# Copy icons from Coq source

cp coq/ide/coqide/MacOS/*.icns ${APP}/Contents/Resources

# Copy complete Opam switch contents

cp -r $(opam config var prefix)/* ${APP}/Contents/Resources

# Remove things we won't need

gfind ${APP}/Contents/Resources \( -name '*.byte.exe' -o -name '*.byte' -o -name '*.cm[aioxt]' -o -name '*.cmxa' -o -name '*.[oa]' -o -name '*.cmti' -o -name '*.glob' \) -type f  -delete
gfind ${APP}/Contents/Resources/bin/ -maxdepth 1 -mindepth 1 \! -name 'coq*' -exec rm -f {} \;
gfind ${APP}/Contents/Resources/lib/ -maxdepth 1 -mindepth 1 \! \( -name 'coq' -o -name 'stublibs' \) -exec rm -rf {} \;
rm -rf ${APP}/Contents/Resources/share/ocaml-secondary-compiler

# Create a shell script to start CoqIDE with correct environmant

mkdir -p ${APP}/Contents/MacOS
cat> ${APP}/Contents/MacOS/coqide <<'EOT'
#!/bin/sh
HERE=$(cd $(dirname $0); pwd)
export PATH="$HERE/../Resources/bin/:$PATH"
export LD_LIBRARY_PATH="$HERE"
export DYLD_LIBRARY_PATH="$HERE"
exec coqide
EOT
chmod a+x ${APP}/Contents/MacOS/coqide

# Create a link to the 'Applications' folder, so that one can drag and drop the application there

ln -sf /Applications _dmg/Applications

##### Find system shared libraries the installed binaries depend on #####

echo '##### Copy system shared libraries #####'

# Copy dynamically loaded (invisible for 'otool') shared libraries for GDK and GTK

for file in $(gdk-pixbuf-query-loaders | grep pixbufloader | sed s/\"//g); do
  cp $file ${APP}/Contents/MacOS/
done

for file in $(gtk-query-immodules-3.0 | grep /im- | sed s/\"//g); do
  cp $file ${APP}/Contents/MacOS/
done

# Use macpack to find dependencies and patch binaries

pip3 install macpack
mkdir ${APP}/Contents/Resources/lib/dylib

# Find dependencies and patch one binary
# $1 full path to binary
# $2 relative path from binary to "${APP}/Contents/Resources" filder

function run_macpack {
  type="$(file -b $1)"
  if [ "$type" == 'Mach-O 64-bit executable x86_64' ] || [ "$type" == 'Mach-O 64-bit bundle x86_64' ]
  then
    echo
    echo "### Finding / patching dependencies for $1 ..."
    macpack -d $2/lib/dylib $1
  else
    echo
    echo "### File '$1' with type '$type' ignored."
  fi
}

for file in $(find "${APP}/Contents/Resources/bin" -type f)
do
  run_macpack "$file" ".."
done

for file in $(find "${APP}/Contents/MacOS" -type f)
do
  run_macpack "$file" "../Resources"
done

# Debug: Dump all dependencies

# for file in $(find "${APP}/Contents/Resources/bin" "${APP}/Contents/MacOS" "${APP}/Contents/Resources/lib/dylib" -type f)
# do
#   otool -L "$file"
# done

##### Create DMG image from folder #####

echo '##### Create DMG image #####'

hdi_opts=(-volname "coq-$COQ_VERSION-installer-macos"
          -srcfolder _dmg
          -ov # overwrite existing file
          -format UDZO
          -imagekey "zlib-level=0"

          # needed for backward compat since macOS 10.14 which uses APFS by default
          # see discussion in #11803
          -fs hfs+
         )
hdiutil create "${hdi_opts[@]}" "coq-$COQ_VERSION-installer-macos.dmg"
