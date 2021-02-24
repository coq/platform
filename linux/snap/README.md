Snap package for Coq
====================

URL: https://snapcraft.io/coq-prover

Maintainer: Enrico Tassi

Package name
------------
The name of the package is `coq-prover` since `coq` was considered
unacceptable by the snap store admins (too short and non informative).

Aliases
-------
The snap package can install binaries in the path, but they are all called
`coq-prover.something` and `something` cannot contain `_`.

As per [request](https://forum.snapcraft.io/t/aliases-request-for-coq-prover/21925)
Coq is granted the `coqide -> coq-prover.coqide` and
`coq_makefile -> coq-prover.coq-makefile` aliases (shorthands generated
on the fly).

Channels and updates
--------------------
Each package is available on a channel, which is a combination of track and
risk level.
A track is something like `latest` (the default one) or, `major-version` (as
many packages do).
A risk level is something like `stable`, `beta`, `edge`.

By default users install from `latest/stable`.
The CI script uploads to `latest/edge`, then via a web ui the package
maintainer can promote a package from one level to another.

IMPORTANT: snap packages are *automatically* updated. This means that when *we*
make a new release the package installed by a user *silently* upgrades, no
questions asked!

A user can install from `latest/edge` to test the very last upload, but also,
and more interestingly, from `2021.02/stable` to *never* move to Coq 8.14 without
consent. This last option makes snap package also usable by developers (and
indeed one finds stuff like `node` or `go` distributed via snap).

CAVEAT: track's creation need to be explicitly requested. The store admins are
happy to grant quickly a new track if it follows the same schema of an existing
one.

See also
--------
- linux/snap/github_actions for a script to trigger a CI build for a platform
  branch also uploading to the snap store

Snap doc
--------

- Channels
  https://snapcraft.io/docs/channels
- Process for manual store actions (tracks, aliases)
  https://forum.snapcraft.io/t/process-for-aliases-auto-connections-and-tracks/455
