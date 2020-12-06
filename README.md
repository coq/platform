# Coq platform

The coq platform is a set of scripts and patches which allows to compile and install Coq and
a set of useful Coq libraries and plugins on macOS, Windows and many Linux distributions in a
reliable way with consistent results.

See [`charter.md`](/charter.md) for the coq platform concept.

# Note on Licenses

The Coq platform setup scripts and the selection of packages and patches are licensed Creative Commons CC0.
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
Please note that some opam packages require and install system packages with many dependencies (e.g GTK3).
These dependencies might have various licenses. You need to refer to your system package manager to
inspect the licenses of such packages.

# Features of the 8.13+beta release

- fully opam based, also on Windows
- single script call to install system dependencies, opam (if not there), a fresh opam switch and the coq platform
- interactive (well script based) guidance of the user through the few parameters
- includes all packages provided in the 8.12 windows installer. The list of included packages is:
```
coq                       8.13.dev        Formal proof management system
coqide                    8.13.dev        IDE of the Coq formal proof management system
coq-aac-tactics           8.13.0          Coq plugin providing tactics for rewriting universally quantified equations
coq-bignums               8.13.0~beta1    Bignums, the Coq library of arbitrary large numbers
coq-compcert              3.8             The CompCert C compiler (64 bit)
coq-coquelicot            3.1.0           A Coq formalization of real analysis compatible with the standard library
coq-elpi                  1.8.1           Elpi extension language for Coq
coq-equations             1.2.3+8.13      A function definition package for Coq
coq-ext-lib               0.11.3          A library of Coq definitions, theorems, and tactics
coq-flocq                 3.3.1           A formalization of floating-point arithmetic for the Coq system
coq-gappa                 1.4.6           A Coq tactic for discharging goals about floating-point arithmetic and roun
coq-hierarchy-builder     1.0.0           Hierarchy Builder
coq-interval              4.1.0           A Coq tactic for proving bounds on real-valued expressions automatically
coq-mathcomp-algebra      1.12.0          Mathematical Components Library on Algebra
coq-mathcomp-bigenough    1.0.0           A small library to do epsilon - N reasonning
coq-mathcomp-character    1.12.0          Mathematical Components Library on character theory
coq-mathcomp-field        1.12.0          Mathematical Components Library on Fields
coq-mathcomp-fingroup     1.12.0          Mathematical Components Library on finite groups
coq-mathcomp-finmap       1.5.1           Finite sets, finite maps, finitely supported functions
coq-mathcomp-real-closed  1.1.2           Mathematical Components Library on real closed fields
coq-mathcomp-solvable     1.12.0          Mathematical Components Library on finite groups (II)
coq-mathcomp-ssreflect    1.12.0          Small Scale Reflection
coq-menhirlib             20200624        A support library for verified Coq parsers produced by Menhir
coq-mtac2                 1.4+8.13        Mtac2: Typed Tactics for Coq
coq-quickchick            1.5.0           Randomized Property-Based Testing Plugin for Coq
coq-simple-io             1.5.0           IO monad for Coq
coq-unicoq                1.5+8.13        An enhanced unification algorithm for Coq
coq-vst                   2.7             Verified Software Toolchain
gappa                     1.3.5           Tool intended for formally proving properties on numerical programs dealing
menhir                    20200624        An LR(1) parser generator
```
- one unified setup script for Windows, macOS and Linux with few OS dependent sections only
- on Windows there is an additional wrapper batch script to setup Cygwin as build and working environment
- on Windows there is in addition a classic Windows installer mostly intended for quick installation by beginners
- it is easy to build variants of the Windows with modified content from an existing opam switch
- system prerequisites are installed using opam depext in a system independent manner
- the script should be fairly robust and safe - it will immediately abort an all errors not explicitly handled
- the script can be restarted if it fails - e.g cause of internet issues - it will not redo things it already did
- the scripts are modular and easy to configure for specific needs, e.g. a reduced or extended setup for a lecture - see [`variants.md`](/variants.md)

## Nonfeatures

- an installer for OSX are not yet provided - this is work in progress

# Usage of the 8.13+beta.0 release

- Get the coq platform scripts via either of these methods
  - `git clone --branch v8.13+beta.0 https://github.com/MSoegtropIMC/coq-platform.git`
  - download and extract `https://github.com/MSoegtropIMC/coq-platform/archive/v8.13+beta.0.zip`
- Follow the below OS specfic instructions.
- For all OSes this will
  - create a new opam switch (and setup and/or initialize opam if it is not there yet).
  - install system prerequisites (like gtk3)
- The name of the opam switch is `_coq-platform_.8.13+beta.0`.
  Use the following commands to activate this switch after opening a new shell:
    ```
    opam switch _coq-platform_.8.13+beta.0
    eval $(opam env)
    ```
  or rerun `opam init` to automate this in each new shell.
- The main opam repository for Coq developments is already added to the created opam switch, so it should be easy to install additional coq (or ocaml) packages. On Windows the support of packages is a bit reduced, but still quite good.
- The full installation might require up to 5 GB of disk space.

## Windows (using the installer)

This method is intended for beginners.
For advanced users it is recommended to compile Coq from sources via opam (see next section).

In case you want to use the fats path:

- Download the installer from https://github.com/coq/platform/releases (click on "Assets" at the end of a release section)
- Run the installer and follow the instructions

A note to lecturers: it is easy to create a customized Windows installer from an opam switch.

## Windows (compiling from sources)

This method is intended for advanced users which need additional flexibility and/or an advanced working environment.
For beginners it is recommended to use the Windows installer (see previous section).

- Open a command window, navigate to the download folder and execute `coq_platform_make_windows.bat`
- This will ask for the cygwin installation path and setup a fresh cygwin as build host (the created Coq is MinGW and runs without cygwin).
- After the cygwin setup, the script will automatically execute the common setup shell script `coq_platform_make.sh`.
- The script will ask a few questions if no parameters are given and then run fully unattended.
- The build time is between 1..5 hours, depending on CPU speed and RAM size.
- The script has various options for configuring paths and proxies; see `example_coq_platform_make.bat` for an example command line.
- The resulting Coq installation is opam based and best used from the cygwin prompt (started via `C:\<your_coq_platform_cygwin_path>\cygwin.bat`) - please remember to activate the opam switch as explained above with `opam switch` when opening a new cygwin shell. CoqIDE can be started from the cygwin prompt with `coqide`.
- It is possible to install several versions of the Coq platform in one Cygwin, as long as the pre-requisites are met. This is best achieved
by running the additional `coq_platform_make.sh` directly from the coq platfiorm created Cygwin.

A note on **virus scanners**: there are no reports of virus scanners reporting any executable generated by the coq platform as virus but they sometimes lead to errors in the build process.
If a virus scanner does its work it has files and/or directories open which on Windows results in `Permission denied` errors in case a build system tries to rename a folder or file. This is not a bug of the scanners but a design issue of Windows, namely that open files and folders are referenced by path names rather than inode numbers. An example error message is:
```
<><> Fetching repository information ><><><><><><><><><><><><><><><><><><><><><>
[ERROR] Could not update repository "default": "C:\\bin\\cygwin_coqplatform_8_12_0\\bin\\mv.exe
        C:/bin/cygwin_coqplatform_8_12_0/home/Michael/.opam/repo/default.new
        C:/bin/cygwin_coqplatform_8_12_0/home/Michael/.opam/repo/default" exited with code 1 "/usr/bin/mv: cannot move
        'C:/bin/cygwin_coqplatform_8_12_0/home/Michael/.opam/repo/default.new' to
        'C:/bin/cygwin_coqplatform_8_12_0/home/Michael/.opam/repo/default': Permission denied"
[ERROR] Initial download of repository failed
```
In case this happens, it might help to simply retry and if this does not help to pause the virus scanner during the build or to exclude the Cygwin destination folder from scans. This might also help another issue with virus scanners: they can take considerable amounts of CPU time and RAM during a highly parallel build. A virus scanner from GData took about 3..4 cores (6..8 threads) of a Xeon CPU and almost 2.0 GB RAM during Coq platform build tests. And GData seems to be on the better side - much worse resource usage slowing down a build by a factor of ten is not unheard of. For GData virus scanners it helps to disable `BEAST (Behavior Monitoring)` and `Deep Ray` in the real time protection - the resource usage is reasonable then. In case you have advice for other virus scanner products, please share via an issue or PR.

## macOS

- Open a shell, navigate to the download folder and execute `coq_platform_make.sh`.
- The script assumes that you have either MacPorts or homebrew installed for installing prerequisites.
  - If you are using MacPorts, the system will ask for sudo permissions to install prerequisites *several times* so the script is not fully unattended but all installations of dependencies are done directly after the initialization of the opam switch.
  - With macPorts I have seen aborts cause or temporary internet (curl download) issues. In this case just rerun the script.
- Using Homebrew should work but is less well tested than MacPorts
- The resulting Coq installation is opam based and best used from the shell prompt - please remember to activate the opam switch as explained above with `opam switch` when opening a new shell. CoqIDE can be started from the shell prompt with `coqide`.
- The setup script creates a folder `$HOME/coq-platform` where it stores a few files but likely this will be removed in future releases.

## Linux

- Open a shell, navigate to the download folder and execute `coq_platform_make.sh`.
- The system will ask for sudo permissions to install prerequisites *several times* so the script is not fully unattended but all installations of dependencies are done directly after the initialization of the opam switch.
- The script is tested on these Linux distributions:
  - Ubuntu 18.04 LTS and 16.04 LTS
  - Fedora 32
  - CentOS 8
  - OpenSuse 15
- The resulting Coq installation is opam based and best used from the shell prompt - please remember to activate the opam switch as explained above with `opam switch` when opening a new shell. CoqIDE can be started from the shell prompt with `coqide`.
- The setup script creates a folder `$HOME/coq-platform` where it stores a few files but likely this will be removed in future releases.

## Installation of additional packages or package variants

### CompCert and VST variants

For some packages, notably CompCert and VST (the Princeton tool-chain for verification of C code), exist various variants.
By default the 32 bit variant of CompCert and the 32 bit variant of VST are installed.

CompCert is **not** free / open source software, but may be used for research and
evaluation purposes. Please clarify the license at:

[`CompCert License`](https://github.com/AbsInt/CompCert/blob/master/LICENSE)

Parts of CompCert are required for the Princeton C verification tool VST.
Some parts of CompCert are open source and for exploring or learning VST
using the supplied example programs, this open source part is sufficient.
If you want to use VST with your own C code, you need the non open source
variant of CompCert. Before you install the full non-free version of CompCert,
please make sure that your intended usage conforms to the above license.

The script will ask which variant of CompCert you want to install.

The compilation of VST takes quite a while on slow / small RAM PCs. For this reason the script also asks if you want to install VST.

You can change the selection of packages any time later by issuing `opam install` commands, e.g.
```
opam install coq-compcert.3.7+8.12~coq_platform~open_source
opam install coq-compcert.3.7+8.12~coq_platform
opam install coq-vst.2.6
```

Besides the open source and non open source variant of CompCert, there is also a 64 bit variant of CompCert and VST, which can
be installed by running these commands:
```
opam install coq-compcert-64.3.7+8.12~coq_platform~open_source
opam install coq-vst-64.2.6
```
or by adjusting [`coq_platform_packages.sh`](/coq_platform_packages.sh) accordingly.
Please note that since both variants can be installed in parallel, only one, the 32 bit variant, is immediately available to Coq
without -Q and -R options. If you want to work with the 64 bit variants, please use these options in your Coq project:
```
-Q $(coqc -where)/../coq-variant/compcert64/compcert compcert
-Q $(coqc -where)/../coq-variant/VST64/VST VST
```

### Installation of other packages

- On Windows open a shell with `C:\<your_coq_platform_cygwin_path>\cygwin.bat`.
- On Linux or macOS open a shell in the usual way.
- Run these commands:
    ```
    opam switch _coq-platform_.8.13+beta.0
    eval $(opam env)
    ```
- Install additional packages with `opam install "package"`
- You can find packages with `opam list --all | grep "some keyword"`
