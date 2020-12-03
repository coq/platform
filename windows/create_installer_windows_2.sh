#!/bin/bash

# This script creates a Windows NSIS MSI installer from the current set of installed opam Coq packages

set -o nounset
set -o errexit

DIR_TARGET=windows_installer
FILE_DEP_HIDDEN="$DIR_TARGET"/dependencies_hidden.nsh
FILE_DEP_VISIBLE="$DIR_TARGET"/dependencies_visible.nsh
FILE_RES_HIDDEN="$DIR_TARGET"/reset_hidden.nsh
> $FILE_RES_HIDDEN
FILE_VISIBLE_SEL="$DIR_TARGET"/dependencies_visible_selection.nsh
FILE_VISIBLE_DESEL="$DIR_TARGET"/dependencies_visible_deselection.nsh

# Sort a dependecy file by dependency level (leaves last)
# $1 input file name
# $2 check macro output file name
# $3 NSIS Check macro name
# $4 reset macro output file name
# $5 sort options (e.g. -r for reverse)

function sort_dependencies
{
  cat  "$1" | awk '
    BEGIN{n=0}
    { DepSrc[n]=$1; DepDest[n]=$2; n++; IsSrc[$1]=1; IsDest[$2]=1; }
    END{
      PROCINFO["sorted_in"] = "@ind_str_asc";
      for (pkg in IsDest) {
        if(!IsSrc[pkg]) DestLvl[pkg]=1
      }
      fnd=1;
      for(lvl=1; fnd; lvl++) {
        fnd=0;
        for (i=0; i<n; i++) {
          if (DestLvl[DepDest[i]]==lvl) {
            DestLvl[DepSrc[i]]=lvl+1;
            DepLvl[i]=lvl;
            fnd=1;
          }
        }
        if(lvl>=50) {
          print "The dependency tree has more than 50 levels - there are likely cyclic dependencies";
          exit 1;
        }
      }
      for (pkg in IsDest) {
        print "${UnselectSection}", "${Sec_"pkg"}" >> "'"$4"'"
      }
      for (i=0; i<n; i++) {
        print DepLvl[i], DepSrc[i], DepDest[i];
      }
    }' | sort $5 -n | awk "
    { print \"\${$3}\", \"\${Sec_\"\$2\"}\", \"\${Sec_\"\$3\"}\", \"'\"\$2\"'\", \"'\"\$3\"'\"; }" > "$2"
}

sort_dependencies "$FILE_DEP_HIDDEN.in" "$FILE_DEP_HIDDEN" 'CheckHiddenSectionDependency' "$FILE_RES_HIDDEN" -r
sort_dependencies "$FILE_DEP_VISIBLE.in" "$FILE_VISIBLE_SEL" 'SectionVisibleSelect' /dev/null -r
sort_dependencies "$FILE_DEP_VISIBLE.in" "$FILE_VISIBLE_DESEL" 'SectionVisibleDeSelect' /dev/null ""

cd $DIR_TARGET

# NSIS 2.51 has the bug that $0 is not set in .onSelChange, so use the latest version 3.06.1

wget --no-clobber --progress=dot:giga http://downloads.sourceforge.net/project/nsis/NSIS%203/3.06.1/nsis-3.06.1.zip
unzip -o nsis-3.06.1
# Unzipping this results in very strange permissions - fix this
chmod -R 700 nsis-3.06.1

# Enable the below lines to enable logging
# wget --no-clobber --progress=dot:giga http://downloads.sourceforge.net/project/nsis/NSIS%203/3.06.1/nsis-3.06.1-log.zip
# unzip -o nsis-3.06.1-log.zip -d nsis-3.06.1-log
# cp -rf nsis-3.06.1-log/* nsis-3.06.1

NSIS=$(pwd)/nsis-3.06.1/makensis.exe

chmod u+x "$NSIS"
cp ../windows/*.ns* .

# ToDo: we need a more elegant way to get this data via opam
wget https://github.com/coq/coq/raw/v8.12/ide/coq.ico
wget https://github.com/coq/coq/raw/v8.12/LICENSE
wget https://raw.githubusercontent.com/AbsInt/CompCert/v3.7/LICENSE -O coq-compcert-license.txt
wget https://raw.githubusercontent.com/PrincetonUniversity/VST/v2.6/LICENSE -O coq-vst-license.txt

COQ_VERSION=$(coqc --print-version | cut -d ' ' -f 1 | tr -d '\r')
COQ_ARCH=$(uname -m)
"$NSIS" -DVERSION="$COQ_VERSION" -DARCH="$COQ_ARCH" Coq.nsi

cd ..