#!/bin/bash

command -v gfind || ( echo "Install gfind (eg. sudo port install findutils)" ; exit 1)

rm -rf macos_installer/
mkdir macos_installer/
cd macos_installer/

COQ_VERSION=$(coqc --print-version | cut -d ' ' -f 1 | tr -d '\r')
APP=_dmg/Coq_${COQ_VERSION}.app/

opam source coq --dir=coq/
eval `(cd coq ; ./configure -local >/dev/null 2>&1 ; grep VERSION4MACOS config/Makefile)`

mkdir -p ${APP}/Contents/
sed -e "s/VERSION/$VERSION4MACOS/g" coq/ide/coqide/MacOS/Info.plist.template > \
    ${APP}/Contents/Info.plist

mkdir -p ${APP}/Contents/MacOS
cat> ${APP}/Contents/MacOS/coqide <<EOT
#!/bin/sh
HERE=\$(cd \$(dirname \$0); pwd)
export PATH=\$HERE/../Resources/bin/:$PATH
export LD_LIBRARY_PATH=\$HERE
export DYLD_LIBRARY_PATH=\$HERE
exec coqide
EOT
chmod a+x ${APP}/Contents/MacOS/coqide

function ldd {
  > $1.tmp
  for f in $(cat $1); do
    otool -L $f | cut -d ' ' -f 1 | grep -v ':$' | grep -v /usr/lib | grep -v /System/Lib >> $1.tmp
  done
  sort -u $1.tmp > $1.new
  rm $1.tmp
  if diff -q $1 $1.new; then
    rm $1.new
  else
    mv $1.new $1
    ldd $1
  fi
}

which coqide > ldd_coqide
ldd ldd_coqide
for file in $(cat ldd_coqide); do
  if [ ! -e /usr/lib/$(basename $file) ]; then
    cp $file ${APP}/Contents/MacOS/
  fi
done
which coqc > ldd_coqc
ldd ldd_coqc
for file in $(cat ldd_coqc); do
  if [ ! -e /usr/lib/$(basename $file) ]; then
    cp $file ${APP}/Contents/MacOS/
  fi
done
for file in $(gdk-pixbuf-query-loaders | grep pixbufloader | sed s/\"//g); do
  cp $file ${APP}/Contents/MacOS/
done
for file in $(gtk-query-immodules-3.0 | grep /im- | sed s/\"//g); do
  cp $file ${APP}/Contents/MacOS/
done

mkdir -p ${APP}/Contents/Resources
cp coq/ide/coqide/MacOS/*.icns ${APP}/Contents/Resources
cp -r $(opam config var prefix)/* ${APP}/Contents/Resources
gfind ${APP}/Contents/Resources \( -name '*.byte.exe' -o -name '*.byte' -o -name '*.cm[aioxt]' -o -name '*.cmxa' -o -name '*.[oa]' -o -name '*.cmti' -o -name '*.glob' \) -type f  -delete
gfind ${APP}/Contents/Resources/bin/ -maxdepth 1 -mindepth 1 \! -name 'coq*' -exec rm -f {} \;
gfind ${APP}/Contents/Resources/lib/ -maxdepth 1 -mindepth 1 \! \( -name 'coq' -o -name 'stublibs' \) -exec rm -rf {} \;
rm -rf ${APP}/Contents/Resources/share/ocaml-secondary-compiler

ln -sf /Applications _dmg/Applications

hdi_opts=(-volname "coq-$COQ_VERSION-installer-macos"
          -srcfolder _dmg
          -ov # overwrite existing file
          -format UDZO
          -imagekey "zlib-level=9"

          # needed for backward compat since macOS 10.14 which uses APFS by default
          # see discussion in #11803
          -fs hfs+
         )
hdiutil create "${hdi_opts[@]}" "coq-$COQ_VERSION-installer-macos.dmg"
