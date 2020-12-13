# Installation

- Install buildtools
  - Debian, Ubuntu:       sudo apt-get install build-essentials
  - CentOS, RHEL, Fedora: sudo dnf groupinstall "Development Tools"
  - OpenSuse:             sudo zypper in -t pattern devel_C_C++
- For CentOS and possibly RHEL some additional spets are required, see [CentOS](#centos) below.
- Get the coq platform scripts via either of these methods
  - `git clone --branch v8.12.1.0 https://github.com/coq/platform.git`
  - download and extract `https://github.com/coq/platform/archive/v8.12.1.0.zip`
- Open a shell, navigate to the download folder and execute `coq_platform_make.sh`.
- The system will ask for sudo permissions to install prerequisites *several times* so the script is not fully unattended but all installations of dependencies are done directly after the initialization of the opam switch.
- In case the script aborts e.g. cause of internet issues, just rerun the script.
- The script creates a new opam switch named `_coq-platform_.8.12.1.0` - this means the script does not touch your existing opam setup unless you already have a switch of this name.
- Use the following commands to activate this switch after opening a new shell:
  - `opam switch _coq-platform_.8.12.1.0`
  - `eval $(opam env)`
  - The second step can be automated by rerunning `opam init`
- The main opam repositories for Coq and OCaml developments are already added to the created opam switch, so it should be easy to install additional Coq (or OCaml) packages.
- CoqIDE can be started from the shell prompt with `coqide`.
- The full installation might require up to 5 GB of disk space.
- The setup script creates a folder `$HOME/coq-platform` where it stores a few files but likely this will be removed in future releases.

# Tests run on Linux

All tests where run with extent=platform, parallel 16 threads, compcert=full, VST=yes, on a machine with 32GB of RAM.

- Ubuntu 18.04 LTS => OK
- Ubuntu 16.04 LTS => OK
- Fedora 32 => OK
- CentOS 8 => OK, but see [CentOS](#centos) below.
- OpenSuse 15 => OK

## Tested commit

```
commit 8c3c2013ce32bd681a51397463f548c270a004ac (HEAD -> v8.12, origin/v8.12)
Author: Michael Soegtrop <7895506+MSoegtropIMC@users.noreply.github.com>
Date:   Sun Dec 13 17:50:52 2020 +0100

    macOS: Clarified XCode install instructions in script message
```

# Notes for specific Linux distributions

## CentOS

### Enable sudo for current user

Centos requires two additional steps. First sudo should be enabled, so that opam depext can work. opam depext automatically installs required system dependencies, which requires sudo rights. Since one cannot run the complete script as super user, there is no easy way around using sudo. The only method is to make sure that all prerequisites are installed upfront. One way to do this is to run the coq platform script until it asks for the sudo password and then see what it want's to do and do this as super user.

Sudo can be enable sudo for the current user as follows:
```
su
usermod -aG wheel username
exit
logout
login
```

### Enable PowerTools repo

CentOS by default doesn't have things like the gtk-sourceview in its repo. Additional packages can be enabled with the following command:
```
sudo dnf config-manager --set-enabled PowerTools
```
This might not required if you do not install CoqIDE, but this has not been tested. Possibly other opam packages also need packages from the CentOS PowerTools repo.