REM This is a test / example call for coq_platform_make_windows.bat.
REM Please note that it is no problem to install several coq-platform version into one cygwin.
REM Each coq-platform will create its own opam switch.
REM The reason for having a version specific cygwin folder name is simplification of testing.

CALL coq_platform_make_windows.bat ^
  -destcyg=C:\bin\cygwin_coqplatform_8_12_0 ^
  -cygcache=C:\bin\cygwin_cache ^
  -cygrepo=https://mirrors.kernel.org/sourceware/cygwin ^
  -intro=n -parallel=p -jobs=16 -compcert=o -vst=y -switch=k

REM -cygquiet=N   -cygforce=Y