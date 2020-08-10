REM Please adjust the below paths as appropriate for your local setup

CALL ..\coq_platform_make_windows.bat ^
  -destcyg=C:\bin\cygwin_coqplatform_8_12_0 ^
  -cygcache=C:\bin\setupfiles\cygwin_cache ^
  -srccache=C:\bin\setupfiles\source_cache ^
  -cygrepo=http://mirror.checkdomain.de/cygwin

REM -cygquiet=N   -cygforce=Y