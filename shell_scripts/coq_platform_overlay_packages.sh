
for override in ${COQ_PLATFORM_OVERRIDE_DEV:-}
do
    pkg="${override%%=*}"
    url="${override#*=}"
    echo "overriding $pkg.dev url with $url"
    mkdir -p opam/packages/$pkg/$pkg.dev/
    opam show --raw $pkg.dev | tr -s '\n' ' ' | sed "s@ src: [^ ]*@ src: \"$url\"@" > opam/packages/$pkg/$pkg.dev/opam
done

if [ ! -z "${COQ_PLATFORM_OVERRIDE_DEV:-}" ]; then
    opam update
fi