#!/usr/bin/env bash

###################### COPYRIGHT/COPYLEFT ######################

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### CREATE MAC DMG INSTALLER ######################

# Options:
# -quick|-q : disable ZIP compression of DMG file (much faster to create and install for tests)

echo "##### Building Mac DMG installer #####"

###### Script safety ######

set -o nounset
set -o errexit

###### Parse command line ######

ZIPCOMPR=9
INSTALL='N'

for arg in "$@"
do
  case "${arg}" in
    -quick|-q) ZIPCOMPR=0 ;;
    -install|-i) INSTALL='Y' ;;
    *) echo "ERROR: Unknown command line argument ${arg}!"; false;;
  esac
done

###### Check if required utilities are installed #####

command -v gfind &> /dev/null || ( echo "Install gfind (eg. sudo port install findutils)" ; exit 1)
command -v pip3  &> /dev/null || ( echo "Install pip3 (eg. sudo port install py38-pip; port select --set pip3 pip38)" ; exit 1)

###### Create working folder and cd #####

rm -rf macos_installer/
mkdir macos_installer/
cd macos_installer/
mkdir logs

###### Get the Coq sourcees from opam #####

# Get installed version of coq (otherwise opam source gives the latest)
coqpackagefull=$(opam list --installed-roots --short --columns=name,version coq | sed 's/ /./')
opam source --dir=coq/ ${coqpackagefull}

##### Get the version of Coq #####

COQ_VERSION=$(coqc --print-version | cut -d ' ' -f 1)

# The MacOS version needs to be purely numeric (no +beta) and is set separately in configure.ml
COQ_VERSION_MACOS=$(egrep -o 'coq_macos_version *= *"[0-9.]+"' coq/configure.ml | cut -d '=' -f 2 | tr -d ' "')

echo "##### Coq version = ${COQ_VERSION} (Mac app version=${COQ_VERSION_MACOS}) #####"

##### Create DMG package folder structure #####

# Folder and image names

APPNAME="Coq_${COQ_VERSION}.app"
APPFOLDER="_dmg/${APPNAME}"
RSRCFOLDER="${APPFOLDER}/Contents/Resources"
DMGNAME="coq-${COQ_VERSION}-installer-macos"

# Sub folders

mkdir -p ${APPFOLDER}
mkdir ${APPFOLDER}/Contents/
mkdir ${APPFOLDER}/Contents/MacOS  # The top level executable shown in launcher
mkdir ${RSRCFOLDER}                # Most files go here
mkdir -p ${RSRCFOLDER}/lib/dylib   # System shared libraries

# Create Info.plist file

sed -e "s/VERSION/${COQ_VERSION_MACOS}/g" coq/ide/coqide/MacOS/Info.plist.template > \
    ${APPFOLDER}/Contents/Info.plist

##### Copy resource files the installed binaries depend on #####

echo '##### Copy resources #####'

# Copy icons from Coq source

cp coq/ide/coqide/MacOS/*.icns ${RSRCFOLDER}

# Copy complete Opam switch contents

cp -r $(opam config var prefix)/* ${RSRCFOLDER}

# Remove things we won't need

gfind ${RSRCFOLDER} \( -name '*.byte.exe' -o -name '*.byte' -o -name '*.cm[aioxt]' -o -name '*.cmxa' -o -name '*.[oa]' -o -name '*.cmti' -o -name '*.glob' \) -type f  -delete
gfind ${RSRCFOLDER}/bin/ -maxdepth 1 -mindepth 1 \! -name 'coq*' -exec rm -f {} \;
gfind ${RSRCFOLDER}/lib/ -maxdepth 1 -mindepth 1 \! \( -name 'coq' -o -name 'stublibs' \) -exec rm -rf {} \;
rm -rf ${RSRCFOLDER}/share/ocaml-secondary-compiler

# Create a shell script to start CoqIDE with correct environmant

cat> ${APPFOLDER}/Contents/MacOS/coqide <<'EOT'
#!/bin/sh
HERE=$(cd $(dirname $0); pwd)
export PATH="${HERE}/../Resources/bin/:${PATH}"
export LD_LIBRARY_PATH="${HERE}"
export DYLD_LIBRARY_PATH="${HERE}"
exec coqide
EOT
chmod a+x ${APPFOLDER}/Contents/MacOS/coqide

# Create a link to the 'Applications' folder, so that one can drag and drop the application there

ln -sf /Applications _dmg/Applications

##### Find system shared libraries the installed binaries depend on #####

echo '##### Copy system shared libraries #####'

# Copy dynamically loaded (invisible for 'otool') shared libraries for GDK and GTK

for file in $(gdk-pixbuf-query-loaders | grep pixbufloader | sed s/\"//g); do
  cp ${file} ${APPFOLDER}/Contents/MacOS/
done

for file in $(gtk-query-immodules-3.0 | grep /im- | sed s/\"//g); do
  cp ${file} ${APPFOLDER}/Contents/MacOS/
done

# Use macpack to find dependencies and patch binaries

pip3 install macpack
> logs/macpack.log

# Find dependencies and patch one binary
# $1 full path to binary
# $2 relative path from binary to "${RSRCFOLDER}" filder

function run_macpack {
  type="$(file -b $1)"
  if [ "${type}" == 'Mach-O 64-bit executable x86_64' ] || [ "${type}" == 'Mach-O 64-bit bundle x86_64' ]
  then
    echo "Finding / patching dependencies for $1 ..."
    macpack -v -d "$2"/lib/dylib $1 >> logs/macpack.log
  else
    echo "INFO: File '$1' with type '${type}' ignored."
  fi
}

for file in $(find "${RSRCFOLDER}/bin" -type f)
do
  run_macpack "${file}" ".."
done

for file in $(find "${APPFOLDER}/Contents/MacOS" -type f)
do
  run_macpack "${file}" "../Resources"
done

# Debug: Dump all dependencies

# for file in $(find "${RSRCFOLDER}/bin" "${APPFOLDER}/Contents/MacOS" "${RSRCFOLDER}/lib/dylib" -type f)
# do
#   otool -L "${file}"
# done

##### Create DMG image from folder #####

echo '##### Create DMG image #####'

hdi_opts=(-volname "${DMGNAME}"
          -srcfolder _dmg
          -ov # overwrite existing file
          -format UDZO
          -imagekey "zlib-level=${ZIPCOMPR}"

          # needed for backward compat since macOS 10.14 which uses APFS by default
          # see discussion in #11803
          -fs hfs+
         )
hdiutil create "${hdi_opts[@]}" "${DMGNAME}.dmg"

echo "##### Finished installer '${DMGNAME}.dmg' #####"

##### Simply copy the folder over to the Applications folder #####

if [ "${INSTALL}" == 'Y' ]
then
  echo '##### Copying to /Applications folder #####'
  rm -rf "/Applications/${APPNAME}"
  cp -r "${APPFOLDER}" '/Applications/'
fi
