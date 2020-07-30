# Opam packages

- coq-ext-lib is taken from dev

ToDo: add patch for coq-ext-lib and/or upstream opam package
ToDo: remove extra-dev repo

# OSX

- The setup expects that MacPorts is installed - it is used for the installation or prerequisites
- Even if prerequisites are installed, the script runs a sudo command to install them (this does nothing if they are installed)

ToDo: check the availability of libraries in a MacPorts / homebrew independent way, e.g. pkg-config and don't try to install them if they exist
ToDo: try with an empty port if all prerequisites are installed

# Windows

- The main opam repo is used as overlay over the patched windows opam repo

ToDo: change this as soon as coq 8.12 is merged
ToDo: check about the status of merging the windows repo to the main repo