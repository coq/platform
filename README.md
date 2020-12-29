# Coq platform

The coq platform is a set of scripts and patches which allows to compile and install Coq and
a set of useful Coq libraries and plugins on macOS, Windows and many Linux distributions in a
reliable way with consistent results.

See [Charter](charter.md) for the coq platform concept.

# **ATTENTION - master branch**

Please do not use the master branch of Coq Platform unless you are involved in package development and want to use the master / development versions of all packages. The master branch is different from the release branches and release tags of the Coq platform. The release branches and tags use hand picked versions of packages, while the master branch always uses the latest version.

The current release branches are:
- [v8.13](https://github.com/coq/platform/tree/v8.13) (beta for Coq 8.13+beta)
- [v8.12](https://github.com/coq/platform/tree/v8.12) (released for Coq 8.12.2 and same package set as the legacy Windows installer)

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

# Coq platform master branch status

The master branch contains a reduced list of packages - those where the master branch of the packages works.
The list of included packages is:
```
coq                       dev             Formal proof management system
coq-aac-tactics           dev             This Coq plugin provides tactics for rewriting universally quantified equat
coq-bignums               dev             Bignums, the Coq library of arbitrary large numbers
coq-coquelicot            dev             A Coq formalization of real analysis compatible with the standard library.
coq-elpi                  dev             Elpi extension language for Coq
coq-equations             dev             A function definition package for Coq
coq-ext-lib               dev             a library of Coq definitions, theorems, and tactics
coq-flocq                 dev             A floating-point formalization for the Coq system.
coq-gappa                 dev             A Coq tactic for discharging goals about floating-point arithmetic and roun
coq-hierarchy-builder     dev             Hierarchy Builder
coq-interval              dev             A Coq tactic for proving bounds on real-valued expressions automatically
coq-mathcomp-algebra      dev             Mathematical Components Library on Algebra
coq-mathcomp-bigenough    dev             A small library to do epsilon - N reasonning
coq-mathcomp-character    dev             Mathematical Components Library on character theory
coq-mathcomp-field        dev             Mathematical Components Library on Fields
coq-mathcomp-fingroup     dev             Mathematical Components Library on finite groups
coq-mathcomp-finmap       dev             Finite sets, finite maps, finitely supported functions, orders
coq-mathcomp-real-closed  dev             Mathematical Components Library on real closed fields
coq-mathcomp-solvable     dev             Mathematical Components Library on finite groups (II)
coq-mathcomp-ssreflect    dev             Small Scale Reflection
coq-menhirlib             dev             A support library for verified Coq parsers produced by Menhir
coq-mtac2                 dev             Mtac2: Typed Tactics for Coq
coq-quickchick            dev             QuickChick is a random property-based testing library for Coq.
coq-simple-io             dev             IO monad for Coq
coq-unicoq                dev             An enhanced unification algorithm for Coq
gappa                     dev             Tool intended for formally proving properties on numerical programs dealing
menhir                    dev             An LR(1) parser generator
```
Currently not supported are
- coq-vst (likely cause: incompatible with CompCert master)
- coq-compcert (likely cause: incompatible with Flocq master)

# Installation of the master branch

Again, in most cases you should not install Coq platform master, but a release version or at least a release branch version.

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
