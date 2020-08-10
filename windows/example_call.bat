REM Please adjust the below paths as appropriate for your local setup

CALL ..\coq_platform_make_windows.bat ^
  -destcyg=C:\bin\cygwin_coqplatform_8_11_2 ^
  -cygcache=C:\bin\setupfiles\cygwin_cache ^
  -cygrepo=https://mirrors.kernel.org/sourceware/cygwin

REM -cygquiet=N   -cygforce=Y