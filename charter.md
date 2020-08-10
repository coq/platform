# Coq platform charter

## Primary / user facing goals

The primary goal of the Coq platform is to provide a stable and dependable extended platform for advanced usages of Coq in industry, education and research. It is inspired by the Windows installer of Coq, which since a few years includes a stable set of plugins and library developments. The primary goal of the Coq platform is to improve the situation for Coq users. It also has the potential to improve the situation for developers. The corresponding secondary goals are given in the next section.

In more detail, the primary goals are:

**Ease of use**: Provide an easy and fast way to install a usable Coq system. Ease of installation is especially important in eduction, where each course attendee has to be able to install Coq with a known feature set with reasonable effort. Also for industrial users, which sometimes start using Coq by looking at some non trivial research projects, an easy to install system leaves a good first impression.

**Completeness**: The easy installation shall include in addition to the core Coq system commonly used plugins and libraries. The definition of "commonly used" is, of course, difficult. For the Windows installer, packages have been added either on request of users or teachers or because several research projects use a package as pre requisite. It would be ideal if a large number of important research projects would compile with the packages provided with the extended platform.

**Stability**: The composition of the Coq platform, that is the selection of packages, should be stable. It should be a rare event that a package is removed from the platform. This means that packages should only be added if the authors and maintainers of a package agree to provide a certain level of maintenance. Finding a compromise between this goal and the *Completeness* goal will likely be difficult and require some curation.

**Tested interoperability**: Some Coq libraries are tested with specific fixed versions of pre requisites. Other developments are tested with other versions of the same pre requisites. This has the effect that such developments cannot be used together. In the Coq platform only one version of each library or plugin shall be used and interoperability shall be tested with dedicated interoperability test cases.

**Release plan**: The Coq platform shall have a release schedule which is coupled to the release schedule of core Coq. The platform should be released 1 to 3 months after each Coq release. This gives both, users and maintainers of platform components a time frame for planning their work.

**Releases only**: In the past the Windows installer did sometimes pick intermediate versions of packages in case the most recent release did not build with current Coq. For the platform this shall be avoided. The platform release time frame of 1..3 months in addition to the beta phase of core Coq releases should be sufficient to make a release of each package or, in case this is not possible, to patch the most recent package release to be compatible with latest core Coq.

**Cross platform**: The Coq platform shall be easy to install on all systems supported by core Coq, that is Linux, Windows and Mac. Since compilation of the platform takes considerable time, binary releases of the platform shall be made available on all supported platforms.

**Developer support**: For developers of plugins, building the Coq platform via opam shall also be supported on Linux, Windows and Mac. The opam repository shall be setup such that it is possible to create exactly the same package configuration as included in the most recent or any previous binary release. Furthermore the Coq platform shall provide a method to automatically setup a working Coq developer environment on all supported platforms (compiled from sources).

## Secondary / developer facing goals

**Decoupling** In the past the release schedule of Coq and the extended platform delivered with the Windows installer had a bad influence on each other. On the one hand, providing a stable extended platform with each Coq release frequently lead to delays in the release schedule of Coq. On the other hand, attempts to have as little impact on the Coq schedule as possible lead to suboptimal version pickings for the extensions provided with the platform. In the end delivering a set of packages with each Coq release created an artificial circular dependency between core Coq and the packages, which led to substantial organizational difficulties. An important goal of the Coq platform is to re-establish a manageable dependency structure.

**CI performance** Another goal is to reduce the CI effort in core Coq. It is not required to test in core Coq CI each and every development for every commit. A regular test, say nightly for platform packages and weekly for an extended set of developments using the platform, should be sufficient to detect compatibility breaking changes early.

## Package inclusion process

- Packages are typically included on user request via a github issue.

- Requests should contain a justification. Good justifications are usage of the package in a regular course or a course with more than 25 attendees or usage of the package as prerequisite in at least three other packages or research developments by authors other than the author of the original package.

- The author(s) of the package shall agree to the inclusion of their package in the Coq platform. This means that the authors agree to put reasonable effort into releasing a version of the package compatible with each new Coq release in less than three months after such a release. The agreement of the authors is given via a comment in the respective github issue.

## Package exclusion process

- The exclusion of a package shall be a rare event.

- In case the package authors / maintainers cannot maintain compatibility to a new Coq release in the expected time, for one release the curator will try to organize maintenance otherwise. The platform curator will also have timely discussions with the Coq team in case changes in core Coq might lead to substantial maintenance effort in a platform package. If the maintenance problem continues for the next release, the curator can remove a package from the platform. The platform users shall be informed about such a decision as early as possible, at least 1 month before a platform release.

## The Coq platform from a technical point of view

Technically the Coq platform will be a git/github/gitlab repo containing:

- Information on packages included in the platform and their versions, sources, build instructions. This information is either given as an opam repo, or there will be automated scripts to generate the opam repo from it.

- A CI setup which tests if the Coq platform builds on Linux, Windows and Mac and which creates the binary setups for these platforms.

- Additional scripts and tools, e.g. for automatic setup of a Coq development environment.

- Possibly patches for included packages, although the goal is to avoid patching packages and instead to fix issues upstream.

- Discussions (in form of issues) on the package inclusion and exclusion.

## Steps

- Move the current Windows Installer from core Coq to the platform
- Simplify the windows installer in core Coq to only install Coq (and possibly very few selected plugins)
- Move CI of platform packages from core Coq CI to Coq platform CI
- Ensure that platform CI runs with Coq master and release branches daily
- Change additional package CI tests currently running in Coq Coq CI so that they use the platform. That is
  - don't rebuild dependencies already existing in the platform
  - make sure the packages build with the version of dependencies provided by the platform
- Create a binary package for Linux (Snap store)
- Create a binary package for Mac (Apple store)
- Create an opam repo for the platform (or do this based on the existing Coq repo)
- Provide developer setups on all platforms
