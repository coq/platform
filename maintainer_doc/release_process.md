# How to create a new Coq Platform release

## Create a preliminary pick file

### Initial steps

In this step a preliminary "best effort" pick file is created for the latest Coq version.
The goal of this pick file is mostly to test what works and what not, so that we can give
informative feedback to package maintainers about the status of their packages.

The pick file generation follows these steps:

- copy and paste the latest pick file in `package_picks`
- the name of the pick file should be `package-pick-${COQ_PLATFORM_PACKAGE_PICK_POSTFIX without initial ~}` - that is the file name and the variable setting should correspond
- adjust the header information:
  - the `+beta1` extension of `COQ_PLATFORM_PACKAGE_PICK_POSTFIX` refers to the status of the pick, not to the status of the Coq release
  - the Coq patch version (beta, rc1, .0, .1, ...) is **never** shown in the pick - the pick always uses the latest patch release of the specified Coq version
  - the `COQ_PLATFORM_VERSION_SORTORDER` needs to be aligned with other packages - currently dev is `99`, so `98` is one before `dev`
  - `COQ_PLATFORM_USE_DEV_REPOSITORY` must be `Y` for any pre release (beta or rc1) and `N` otherwise. 
     This flag controls if the `core-dev` and `extra-dev` opam repos are used by the newly created switch.
- A typical `CONTROL VARIABLES` section for a preliminary pick is:
```
###################### CONTROL VARIABLES #####################

# The two lines below are used by the package selection script
COQ_PLATFORM_VERSION_TITLE="Coq 8.18+rc1 (released Sep 2023) with the preliminary package pick from Sep 2023"
COQ_PLATFORM_VERSION_SORTORDER=98

# The package list name is the final part of the opam switch name.
# It is usually either empty ot starts with ~.
# It might also be used for installer package names, but with ~ replaced by _
# It is also used for version specific file selections in the smoke test kit.
COQ_PLATFORM_PACKAGE_PICK_POSTFIX='~8.18+beta1'

# The corresponding Coq development branch and tag
COQ_PLATFORM_COQ_BRANCH='v8.18'
COQ_PLATFORM_COQ_TAG='8.18+rc1'

# This controls if opam repositories for development packages are selected
COQ_PLATFORM_USE_DEV_REPOSITORY='Y'

# This extended descriptions is used for readme files
COQ_PLATFORM_VERSION_DESCRIPTION='This version of Coq Platform 2023.11.0 includes Coq 8.18+rc1 from Sep 2023. '
COQ_PLATFORM_VERSION_DESCRIPTION+='This is a preliminary release intended for package maintainers. '

# The OCaml version to use for this pick (just the version number - options are elaborated in a platform dependent way)
COQ_PLATFORM_OCAML_VERSION='4.14.1'
```
- select the most recent coq platform opam switch with `opam switch <name>` and possibly `eval $(opam env)`
- run `opam update`
- use `opam show <name>` to inform yourself about available versions of the below packages (for these one can assume that opam is up to date)
- in the new pickfile adjust the versions of these packages
  - `ocamlfind` - this involves porting the `relocatable` patch and can also be done later, but requires a full rebuild then
  - `dune`
  - `dune-configurator`
  - `coq`
  - `coqide`
  - use 
- Build Coq Platform until including CoqIDE using `OPAMYES=0 ./coq_platform_make.sh -extent=i -parallel=p -jobs=8 -switch=d` and select the new pick when asked
  - if this fails, fix it and rerun the build (possibly using `-switch=k`)

### Select initial package versions

- empty the file `maintainer_scripts/PATCHED_PACKAGE_LIST_FILE.sh` - this file contains a list of already processed packages and is usually checked in since the whole process can take several days
- run the script `./maintainer_scripts/package-version-info.sh  package_picks/package-pick-<new pick>.sh`
- this script copies the new pick, removes comment signs in front of any package pick line and then gets some info for each package in the pick, e.g.:
```
==================== PROCESSING coq-bignums ====================
OPAM:             NOT INSTALLED
OPAM issue url    https://github.com/coq/bignums/issues
Coq CI repo:      https://github.com/coq/bignums
Coq CI ref:       a8c50a569a971d6e36e8df88ca16f9f8958f9543
OPAM versions:    8.6.0  8.7.0  8.7.dev  8.8.0  8.8.dev  8.9.0  8.10+beta1  8.10.0  8.11.0  8.11.dev  8.12.0  8.12.dev  8.13+beta1  8.13.0  8.14.0  8.15.0  8.16.0  8.17.0  9.0.0+coq8.13  9.0.0+coq8.14  9.0.0+coq8.15  9.0.0+coq8.16  9.0.0+coq8.17  9.0.0+coq8.18  dev [9.0.0+coq8.18]
GIT tag-versions: 8.6.0  8.7.0  8.8+beta1  8.8.0  8.9.0  8.10+beta1  8.10.0  8.11.0  8.12.0  8.13+beta1  8.13.0  8.14.0  8.15.0  8.16.0  8.17.0  9.0.0  9.0.0+coq8.13  9.0.0+coq8.14  9.0.0+coq8.15  9.0.0+coq8.16  9.0.0+coq8.17  9.0.0+coq8.18  
```
- compare the git tag names and opam package versions, do an initial pick for the package and update the new pick file - the packages are processed in the same order as they appear in the pick file
- in case the opam and git tag versions don't match, try using `opam show --raw <package.version>` to see how opam and git versions relate
- in case there is a new tag but no opam package, consider to create one in the coq platform opam patch folder
  - `git clone git@github.com:coq/opam-coq-archive.git` (or pull)
  - copy the latest opam package from the above git repo to `opam/opam-coq-archive/released` (or a more appropriate coq platform opam patch folder - there are 3)
  - adjust the version number (that is the folder name)
  - adjust the source tar name in the opam file
  - make sure the source TGZ file in the opam file comes via HTTPS or other protected services
  - `wget` the new source tar file locally
  - run `openssl dgst --sha512 <source.tgz>` and copy/paste the SSH key into the opam file (If the opam file was still SHA256, update it)
- run this process for all packages in the `full` extent
- do a **sequential** build of the full extent:
  - `OPAMYES=0 ./coq_platform_make.sh -extent=x -parallel=s -jobs=8 -compcert=y -large=i -switch=k`
  - a parallel build is likely to have opam conflicts and opam is not terribly informative about the nature of such conflicts
  - a sequential build gives much more information in case there are conflicts - typically at some point the build says it want's to recompile something giving a detailed reason why
  - note that `OPAMYES=0` is required, otherwise the script sets it to `1` and would do the above recompiles without stopping to ask
- if the build fails just because of an opam version restriction, try creating a patched opam file with relaxed restrictions
  - the are a few scripts `maintainer_scripts/patch_opam_package_<detail>.sh` to help with this, but please note that these are not that well tested and that they use `opam show --raw` to get
    the previous version, which is usually a reordering / reformatting of the opam file and not comparable with it (PRs to fix this welcome ;-)
- if something isn't easy to fix, comment out the package (it dependent package) with a note why the package was disabled (`# version xyz does not work`). Typically anything that requires patching the repo's source code would be considered not easy to fix.
- if things are reasonably file for the `full` build, run the script again for the extended selection - it should pick up where you aborted it before cause of `maintainer_scripts/packages_already_processed.txt`