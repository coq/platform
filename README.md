# Coq Platform

The Coq platform is a distribution of the Coq proof assistant together with a selection of Coq libraries.
It provides a set of scripts to compile and install OPAM, Coq, Coq libraries and Coq plugins on MacOS,
Windows and many Linux distributions in a reliable way with consistent results.

See [Charter](charter.md) for the coq platform concept.

# Information for Coq Platform users

You find the releases and downloads for binary packages here: [releases](https://github.com/coq/platform/releases).

The current release banch is:
- [2021.02](https://github.com/coq/platform/tree/2021.02) (release 2021.02.0 for Coq 8.13.1)

Previous release branches are:
- [v8.12](https://github.com/coq/platform/tree/v8.12) (release for Coq 8.12.2)

Please refer to the README.md file on these branches for further information.

Please do not use the master branch of Coq Platform unless you are involved in package development and want to use the master / development versions of all packages.
The master branch is *not* just a more recent version of the release branches - it is different.
The release branches and tags use hand picked versions of packages which is known to work together.
The master branch uses the latest version for all packages (with very few exceptions) and is intended for testing upcoming versions and early development.

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

# Information for Coq Platform developers

## Coq platform master branch status

The master branch contains a reduced list of packages - those where the master branch of the packages works.
The list of included packages is:
```
coq                       dev             Formal proof management system
coq-aac-tactics           dev             This Coq plugin provides tactics for rewriting universally quantified equations, modulo associative (and possibly commutative) operators
coq-bignums               dev             Bignums, the Coq library of arbitrary large numbers
coq-compcert              dev             The CompCert C compiler (64 bit)
coq-coquelicot            dev             A Coq formalization of real analysis compatible with the standard library.
coq-elpi                  dev             Elpi extension language for Coq
coq-equations             dev             A function definition package for Coq
coq-ext-lib               dev             a library of Coq definitions, theorems, and tactics
coq-flocq                 3.dev           A floating-point formalization for the Coq system.
coq-gappa                 dev             A Coq tactic for discharging goals about floating-point arithmetic and round-off errors using the Gappa prover
coq-hierarchy-builder     dev             Hierarchy Builder
coq-interval              dev             A Coq tactic for proving bounds on real-valued expressions automatically
coq-mathcomp-algebra      dev             Mathematical Components Library on Algebra
coq-mathcomp-bigenough    dev             A small library to do epsilon - N reasonning
coq-mathcomp-character    dev             Mathematical Components Library on character theory
coq-mathcomp-field        dev             Mathematical Components Library on Fields
coq-mathcomp-fingroup     dev             Mathematical Components Library on finite groups
coq-mathcomp-finmap       dev             Finite sets, finite maps, finitely supported functions
coq-mathcomp-real-closed  dev             Mathematical Components Library on real closed fields
coq-mathcomp-solvable     dev             Mathematical Components Library on finite groups (II)
coq-mathcomp-ssreflect    dev             Small Scale Reflection
coq-menhirlib             dev             A support library for verified Coq parsers produced by Menhir
coq-mtac2                 dev             Mtac2: Typed Tactics for Coq
coq-quickchick            dev             QuickChick is a random property-based testing library for Coq.
coq-simple-io             dev             IO monad for Coq
coq-unicoq                dev             An enhanced unification algorithm for Coq
coqide                    dev             IDE of the Coq formal proof management system
gappa                     dev             Tool intended for formally proving properties on numerical programs dealing with floating-point or fixed-point arithmetic
menhir                    dev             An LR(1) parser generator
```
Currently not supported are
- coq-vst (likely cause: incompatible with CompCert master)
- coq-flocq is tied to the `flocq-3` branch since CompCert is not yet compatible with latest Flocq

## Installation of the master branch

Again, in most cases you should not install Coq Platform master, but a release version or at least a release branch version.

Please refer to the ReadMe file for your OS.

- macOS: see [README_macOS](README_macOS.md).
- Windows: see [README_Windows](README_Windows.md)
- Linux: see [README_Linux](README_Linux.md).

## Installation of additional packages or package variants

- On Windows open a shell with `C:\<your_coq_platform_cygwin_path>\cygwin.bat`.
- On Linux or macOS open a shell in the usual way.
- Run these commands:
    ```
    opam switch _coq-platform_.master
    eval $(opam env)
    ```
- Install additional packages with `opam install "package"`
- You can find packages with `opam list --all | grep "some keyword"`
