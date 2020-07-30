# coq-platform
Preliminary / experimental version of the Coq platform discussed in the coq-dev mailing list.

See [`charter.md`](/charter.md) for the coq platform concept.

# Note on Licenses

The Coq platform setup scripts and the selection of packages is licensed LGPL 2.1+.
This license does **not** apply to the packages installed by the Coq platform.
You can get an overview over the licenses of the installed software (after installing it)
with the command:
```
opam list --columns=name,license:
```
In case no license is given please clarify on the homepage of the software:
```
opam list --columns=name,homepage:
```

# Features of the 8.12~alpha1 release

- fully opam based, also on Windows
- system prerequisites are installed using opam depext in a system independent manner
  (on Windows/cygwin currently all prerequisites are installed upfront during cygwin installation)
- single script call to install system dependencies, opam (if not there), a fresh opam switch and the coq platform
- includes most packages provided in the 8.12 windows installer. The list of included packages is:
```
coq 8.12.0
coqide
menhir
coq-bignums
coq-equations
coq-coquelicot
coq-flocq
coq-interval
coq-quickchick
coq-ext-lib
coq-aac-tactics
coq-mathcomp-ssreflect 1.11.0
coq-mathcomp-algebra
coq-mathcomp-character
coq-mathcomp-field
coq-mathcomp-fingroup
coq-mathcomp-solvable
coq-mathcomp-real-closed
coq-mathcomp-finmap
coq-mathcomp-bigenough
coq-menhirlib 20200624
coq-compcert.3.7+8.12~coq_platform~open_source
coq-vst.2.6
```
- one setup script for Windows, macOS and Linux with few OS dependent sections only
- on Windows there is an additional wrapper batch script to setup cygwin as build and working environment
- the script should be fairly robust and safe - it will immediately abort an all errors not explicitly handled
- the script can be restarted if it fails - e.g cause of internet issues - it will not redo things it already did

## Nonfeatures

- the script is still quite basic with no options and simply sets up the complete coq platform in a new opam switch
- installers for OSX and Windows are not yet provided
- Linux is not yet tested in any way
- A few packages from the Coq 8.12.0 Windows installer are still missing: `mtac2`, `elpi`, `hierarchy-builder` and `gappa`

# Usage of the 8.12~alpha1 release

- Get the coq platform scripts via either of these methods
  - `git clone https://github.com/MSoegtropIMC/coq-platform.git`
  - download and extract `https://github.com/MSoegtropIMC/coq-platform/archive/master.zip`
- Follow the below OS specfic instructions.
- For all OSes this will
  - create a new opam switch (and setup and/or initialize opam if it is not there yet).
  - install system prerequisites (like gtk3)
- The name of the opam switch is `_coq-platform_.8.12.alpha1`.
  Use the following commands to activate this switch after opening a new shell:
    ```
    opam switch _coq-platform_.8.12.alpha1
    eval $(opam env)
    ```
  or rerun `opam init` to automate this in each new shell.
- The main opam repository for Coq developments is already added to the created opam switch, so it should be easy to install additional coq (or ocaml) packages. On Windows the support of packages is a bit reduced, but still quite good.
- The full installation might require up to 5 GB of disk space.

## Windows

- Open a command window, navigate to the download folder and execute `coq_platform_make_windows.bat`
- This will setup a fresh cygwin as build host (the created Coq is MinGW and runs without cygwin).
- After the cygwin setup, the script will automatically execute the common setup shell script `coq_platform_make.sh`.
- The script should run fully unattended. The build time should be about 1..2 hours.
- The default cygwin installation folder is `C:\bin\cygwin_coq_platform`.
- The script has various options for configuring paths and proxies; see `windows/example_coq_platform_make.bat` for an example command line.
- The resulting Coq installation is opam based and best used from the cygwin prompt (started via `C:\bin\cygwin_coq_platform\cygwin.bat`) - please remember to activate the opam switch as explained above with `opam switch` when opening a new cygwin shell. CoqIDE can be started from the cygwin prompt with `coqide`.

## macOS

- Open a shell, navigate to the download folder and execute `coq_platform_make.sh`.
- The script assumes that you have either MacPorts or homebrew installed for installing prerequisites.
  - If you use homebrew, you must install opam upfront manually - if you use MacPorts this is done automatically.
  - If you are using MacPorts, the system will ask for sudo permissions to install prerequisites *several times* so the script is not fully unattended.
    With macPorts I have seen aborts cause or temporary internet (curl download) issues. In this case just rerun the script.
- Using Homebrew instead of MacPorts should work but is untested.
- If one or more prerequisites are missing, the script will issue a `sudo port install` command to install them - you need to enter your password at the prompt.
- The resulting Coq installation is opam based and best used from the shell prompt - please remember to activate the opam switch as explained above with `opam switch` when opening a new shell. CoqIDE can be started from the shell prompt with `coqide`.
- The setup script creates a folder `$HOME/coq-platform` where it stores a few files but likely this will be removed in future releases.

## Linux

this is work in progress.