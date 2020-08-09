REM Please adjust the below paths as appropriate for your local setup

CALL ..\coq_platform_make_windows.bat ^
  -destcyg=C:\bin\cygwin_cp_8_11_2 ^
  -cygcache=C:\bin\setupfiles\cygwin_cache ^
  -srccache=C:\bin\setupfiles\source_cache ^
  -cygrepo=http://mirror.checkdomain.de/cygwin

REM -cygquiet=N   -cygforce=Y