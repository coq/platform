# Creating custom package picks and installers

It is an intended use case of the Coq Platform to create custom variants and installers, e.g.
for projects or lectures, by creating additional files in the [package_picks](../package_picks) folder.

The scripts for creating binary packages and installers should be able to
handle such variants, so that it should be easy to create a custom installer
e.g. for a lecture.

## Creating released versions of packages

The CP build scripts get the source code for each package by downloading a zipped file.
For github, zipped files are available only for _released_ versions. For example, the
[Coq releases page](https://github.com/coq/coq/releases) lists the released versions.
The zip files are listed under "Assets".  If your changes are not merged, then the
zip files will be in your fork, e.g. https://github.com/FORKNAME/coq/releases.  Do the
following:

- On your system, create a tag for the change with **git tag TAGNAME**
- Use **git push REMOTENAME TAGNAME** to upload the tag to github
- In the github GUI, create a release that refers to the tag.
- You will shortly need to copy the URL into the opam files and include its md5 and
  sha512 checksums.  Download the zipped file and use a command such as
  **openssl dgst --md5 ZIPFILE** to compute the checksums.

## Creating local opam and patch files

Each package has a directory that defines it, such as
**coq-platform/platform/opam/opam-repository/coq/coq.8.19.0**.  This
directory must contain an **opam** file and it may contain a **files**
subdirectory containing patch files.

Along with other information, the opam file points to the zipped file and gives
its checksums, for example:

```
url {
  src: 
    "https://github.com/jfehrle/coq/archive/refs/tags/debug_pl_8_19_tag2.tar.gz"
  checksum: [
    "md5=8540549341f6425174165edec2bc5c29"
    "sha512=00833a93914d485e6ca695b6cec220da47957d7e3358bfe8e68300c48935255e95436be751826d837dfbd5f784116df86c1b57a8fe7e3301b45b4b19bffe958f"
  ]
}
```

If there are prior versions of the package, you may be able to copy the **opam** file
from another version and update only the url information.  Otherwise, dune
can generate these files at compile time (e.g. the file for Coq's **coq-core** module
is **coq-core.opam**, which you must rename to "**opam**" in the package directory).

If you've modified Coq, note that it has four packages (coq, coq-core, coqide
and coq-stdlib).  You'll need to create opam directories for each of these.

Patch files provide a way to use source code that differs from what's in the
zipped source file during the CP build.  As a heuristic, you may want to try
copying the patch files from the most similar previous release, but it may
be that the code in the patch has already been incorporated into the zipped
file of your newer version.

## Creating a new package pick file

- Create a new file in the [package_picks](package_picks) folder by copying one of the existing files as template.
- **Please always change the opam switch name**, that is the variable `COQ_PLATFORM_PACKAGE_PICK_POSTFIX`
- Make sure that the value assigned to `COQ_PLATFORM_PACKAGE_PICK_POSTFIX` matches the postfix of the package pick file name.
- Give appropriate values to other variables in the header section of the package pick file, especially `COQ_PLATFORM_VERSION_TITLE` and `COQ_PLATFORM_VERSION_DESCRIPTION`.
- Add or remove packages or change package versions according to your requirements.
- You should include specific versions for all packages to get a reproducible result.
  The opam database changes daily and unless you specify a version for each package you get different results and possibly the build will fail.
  Opam CI does not test all possible combinations of package versions.
- In case you want to include pre release packages, which don't have a published opam package as yet, you can add opam packages in the folders under [opam](../opam).
  opam packages in thes folder take precedence over packages from the published repositories.
- You can set the variable `COQ_PLATFORM_USE_DEV_REPOSITORY` in the header of the package pick file to `Y` in case you want to include the public and local `extra-dev` opam repositories in the opam package search.

As soon as you have created a package pick file, you can create an opam switch from it by running `coq_platform_make.sh/.bat` and selecting the new pick.
You can also give the pick on the command line e.g. by running:
```
./coq_platform_make.sh -packages="my_new_pick" -extent=x -parallel=p -jobs=6 -compcert=y -large=i -switch=k
```

On Windows you can either create a new cygwin with:
```
CALL coq_platform_make_windows.bat ^
  -arch=64 ^
  -destcyg=C:\bin\cygwin64_coq_platform_my_new_pick ^
  -cygcache=C:\bin\cygwin_cache ^
  -cygrepo=https://mirrors.kernel.org/sourceware/cygwin ^
  -packages="my_new_pick" -extent=x -parallel=p -jobs=6 -compcert=y -large=i -switch=k 
```
or you can reuse an existing Coq Platform created cygwin and run the same shell script as above.
The Coq Platform cygwin hardly ever changes, so there is no point in creating a new cygwin for each package pick.
In case your pick requires additional cygwin supplied MinGW libraries, this is handled automatically by opam depext - if not it is better to fix the opam package than adding teh package to the cygwin install command line.

### Debugging package picks

Since package picks should specify all versions, it is quite common that opam says: `Sorry, no solution found: there seems to be a problem with your request.` simply because you requested conflicting versions.
There is a script `maintainer_scripts/build_seq.sh` which builds a pick package by package and disables the opam "auto-yes". This way, when you have a conflict, opam will stop and ask you if it should change the package versions. At this point you can exactly see which package (the which shall be installed) requires which versions (the requested recompiles).

If you have issues, please contact us on zulip chat [Coq-Platform & users](https://coq.zulipchat.com/#narrow/stream/250632-Coq-Platform.20devs.20.26.20users)

## Creating a custom installer for macOS

After you created and built a new package pick, you can create a macOS DMG installer from it as follows:

- Activate the opam switch with `opam switch CP.2025.01.0~my_new_pick`
- Navigate to your Coq Platform git folder, e.g. `cd ~/platform`
- Run `macos/create_installer_macos.sh -sign=Y -signcert=path_to_certificate_file -signid=signature_id`
- Above the `path_to_certificate_file` is the path and name of the `.cer` and `.p12` file **without** the file extension. The signature ID is typically the name of the institution to which the certificate is issued.

On recent macOS one can't start the application - that is CoqIDE - without signing the installer. One can still use the installed tools from the command line, though. One can even start coqide from the command line even without signing.

## Creating a custom installer for Windows

After you created and built a new package pick, you can create a Windows installer from it as follows:

- Open the Coq Platform cygwin shell, e.g. `C:\bin\cygwin64_coq_platform\cygwin.bat`.
- Activate the opam switch with `opam switch CP.2025.01.0~my_new_pick`
- Navigate to the `coq-platform` folder.
- Run `windows/create_installer_windows.sh`

On Windows it depends on the exact version and variant if you need to sign the installer or not.
