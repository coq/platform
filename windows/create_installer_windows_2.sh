#!/bin/bash

# This script creates a Windows NSIS MSI installer from the current set of installed opam Coq packages

set -o nounset
set -o errexit

DIR_TARGET=windows_installer
FILE_DEP_HIDDEN="$DIR_TARGET"/dependencies_hidden.nsh
FILE_DEP_VISIBLE="$DIR_TARGET"/dependencies_visible.nsh
FILE_RES_HIDDEN="$DIR_TARGET"/reset_hidden.nsh
FILE_RES_VISIBLE="$DIR_TARGET"/reset_visible.nsh
> $FILE_RES_HIDDEN
> $FILE_RES_VISIBLE

# Sort a dependecy file by dependency level (leaves last)
# $1 input file name
# $2 check macro output file name
# $3 NSIS Check macro name
# $4 reset macro output file name

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
    }' | sort -r -n | awk "
    { print \"\${$3}\", \"\${Sec_\"\$2\"}\", \"\${Sec_\"\$3\"}\", \"'\"\$2\"'\", \"'\"\$3\"'\"; }" > "$2"
}

sort_dependencies "$FILE_DEP_HIDDEN.in" "$FILE_DEP_HIDDEN" 'CheckHiddenSectionDependency' "$FILE_RES_HIDDEN"
sort_dependencies "$FILE_DEP_VISIBLE.in" "$FILE_DEP_VISIBLE" 'CheckVisibleSectionDependency' "$FILE_RES_VISIBLE"

cd $DIR_TARGET

wget --no-clobber --progress=dot:giga http://downloads.sourceforge.net/project/nsis/NSIS%202/2.51/nsis-2.51.zip
unzip -o nsis-2.51.zip
NSIS=$(pwd)/nsis-2.51/makensis.exe
chmod u+x "$NSIS"
cp ../windows/*.ns* .

wget --no-clobber https://github.com/coq/coq/raw/v8.12/ide/coq.ico
wget --no-clobber https://github.com/coq/coq/raw/v8.12/LICENSE

COQ_VERSION=$(coqc --print-version | cut -d ' ' -f 1 | tr -d '\r')
COQ_ARCH=$(uname -m)
#  -DCOQ_SRC_PATH="$PREFIXCOQ"
"$NSIS" -DVERSION="$COQ_VERSION" -DARCH="$COQ_ARCH" Coq.nsi

cd ..