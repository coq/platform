@ECHO OFF

REM ========== COPYRIGHT/COPYLEFT ==========

REM (C) 2020 Michael Soegtrop

REM Released to the public under the
REM GNU Lesser General Public License Version 2.1 or later
REM See https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html

REM Based on ^<coq^>/dev/build/windows/coq_platform_cygwin_setup.bat

REM (C) 2016 Intel Deutschland GmbH
REM Author: Michael Soegtrop

REM Released to the public by Intel under the
REM GNU Lesser General Public License Version 2.1 or later
REM See https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html

REM ========== NOTES ==========

REM For Cygwin setup command line options
REM see https://cygwin.com/faq/faq.html#faq.setup.cli

REM ========== DEFAULT VALUES FOR PARAMETERS ==========

REM For a description of all parameters, see ReadMe.txt

SET BATCHFILE=%~0
SET BATCHDIR=%~dp0

REM see -arch in ReadMe.txt, but values are x86_64 or i686 (not 64 or 32)
SET ARCH=x86_64
SET SETUP=setup-x86_64.exe

REM see -destcyg in ReadMe.txt
SET DESTCYG=C:\bin\cygwin_coq_platform

REM see -proxy in ReadMe.txt
IF DEFINED HTTP_PROXY (
  SET PROXY=%HTTP_PROXY:http://=%
) else (
  REM One can't set a variable to empty in DOS, but you can set it to a space this way.
  REM The quotes are just there to make the space visible and to protect from "remove trailing spaces".
  SET "PROXY= "
)

REM A Cygwin mirror - see https://cygwin.com/mirrors.html for choices
REM THIS MUST NOT INCLUDE THE TRAILING /
SET CYGWIN_REPOSITORY=https://mirrors.kernel.org/sourceware/cygwin

REM A local folder (in Windows path syntax) where cygwin packages are cached
SET CYGWIN_LOCAL_CACHE_WFMT=%BATCHDIR%cygwin_cache

REM If Y, install Cygwin as found in the cache - do not try to update from teh repo server
SET CYGWIN_FROM_CACHE=N

REM If Y, do an unattended installation of Cygwin
SET CYGWIN_QUIET=Y

REM If Y, force run the cygwin setup - even if it appears to be installed already
SET CYGWIN_FORCE=N

REM If Y, automatically run the coq-platform setup after cygwin setup
SET BUILD_COQ_PLATFORM=Y

REM ========== PARSE COMMAND LINE PARAMETERS ==========

SHIFT

:Parse

IF "%~0" == "-arch" (
  IF "%~1" == "32" (
    SET ARCH=i686
    SET SETUP=setup-x86.exe
  ) ELSE (
    IF "%~1" == "64" (
      SET ARCH=x86_64
      SET SETUP=setup-x86_64.exe
    ) ELSE (
      ECHO "Invalid -arch, valid are 32 and 64"
      GOTO :EOF
    )
  )
  SHIFT
  SHIFT
  GOTO Parse
)

IF "%~0" == "-destcyg" (
  SET DESTCYG=%~1
  SHIFT
  SHIFT
  GOTO Parse
)

IF "%~0" == "-proxy" (
  SET PROXY=%~1
  SHIFT
  SHIFT
  GOTO Parse
)

IF "%~0" == "-cygrepo" (
  SET CYGWIN_REPOSITORY=%~1
  SHIFT
  SHIFT
  GOTO Parse
)

IF "%~0" == "-cygcache" (
  SET CYGWIN_LOCAL_CACHE_WFMT=%~1
  SHIFT
  SHIFT
  GOTO Parse
)

IF "%~0" == "-cyglocal" (
  SET CYGWIN_FROM_CACHE=%~1
  CALL :CheckYN -cyglocal %~1 || GOTO ErrorExit
  SHIFT
  SHIFT
  GOTO Parse
)

IF "%~0" == "-cygquiet" (
  SET CYGWIN_QUIET=%~1
  CALL :CheckYN -cygquiet %~1 || GOTO ErrorExit
  SHIFT
  SHIFT
  GOTO Parse
)

IF "%~0" == "-cygforce" (
  SET CYGWIN_FORCE=%~1
  CALL :CheckYN -cygquiet %~1 || GOTO ErrorExit
  SHIFT
  SHIFT
  GOTO Parse
)

IF "%~0" == "-build" (
  SET BUILD_COQ_PLATFORM=%~1
  CALL :CheckYN -build %~1 || GOTO ErrorExit
  SHIFT
  SHIFT
  GOTO Parse
)

IF NOT "%~0" == "" (
  ECHO Install cygwin and download, compile and install OCaml and Coq for MinGW
  ECHO !!! Illegal parameter %~0
  ECHO Usage:
  ECHO coq_platform_cygwin_setup
  CALL :PrintPars
  GOTO :EOF
)

REM ========== CONFIRM PARAMETERS ==========

CALL :PrintPars
REM Note: DOS batch replaces variables on parsing, so one can't use a variable just set in an () block
IF "%COQREGTESTING%"=="Y" (GOTO DontAsk)
  SET /p ANSWER="Is this correct? y/n "
  IF NOT "%ANSWER%"=="y" (GOTO :EOF)
:DontAsk

REM ========== DERIVED VARIABLES ==========

SET CYGWIN_INSTALLDIR_WFMT=%DESTCYG%
SET TARGET_ARCH=%ARCH%-w64-mingw32
SET BASH=%CYGWIN_INSTALLDIR_WFMT%\bin\bash

REM Convert paths to various formats
REM WFMT = windows format (C:\..)          Used in this batch file.
REM CFMT = cygwin format (\cygdrive\c\..)  Used for Cygwin PATH variable, which is : separated, so C: doesn't work.
REM MFMT = MinGW format (C:/...)           Used for the build, because \\ requires escaping. Mingw can handle \ and /.

SET CYGWIN_INSTALLDIR_MFMT=%CYGWIN_INSTALLDIR_WFMT:\=/%
SET CYGWIN_INSTALLDIR_CFMT=%CYGWIN_INSTALLDIR_MFMT:C:/=/cygdrive/c/%
SET CYGWIN_INSTALLDIR_CFMT=%CYGWIN_INSTALLDIR_CFMT:D:/=/cygdrive/d/%
SET CYGWIN_INSTALLDIR_CFMT=%CYGWIN_INSTALLDIR_CFMT:E:/=/cygdrive/e/%

ECHO CYGWIN INSTALL DIR (WIN)    = %CYGWIN_INSTALLDIR_WFMT%
ECHO CYGWIN INSTALL DIR (MINGW)  = %CYGWIN_INSTALLDIR_MFMT%
ECHO CYGWIN INSTALL DIR (CYGWIN) = %CYGWIN_INSTALLDIR_CFMT%

REM WARNING: Add a space after the = in case you want set this to empty, otherwise the variable will be unset
SET MAKE_OPT=-j %MAKE_THREADS%

REM ========== DERIVED CYGWIN SETUP OPTIONS ==========

REM One can't set a variable to empty in DOS, but you can set it to a space this way.
REM The quotes are just there to make the space visible and to protect from "remove trailing spaces".
SET "CYGWIN_OPT= "

IF "%CYGWIN_FROM_CACHE%" == "Y" (
  SET CYGWIN_OPT= %CYGWIN_OPT% -L
)

IF "%CYGWIN_QUIET%" == "Y" (
  SET CYGWIN_OPT= %CYGWIN_OPT% -q --no-admin
)

REM Cygwin setup sets proper ACLs (permissions) for folders it CREATES.
REM Otherwise chmod won't work and e.g. the ocaml build will fail.
REM Cygwin setup does not touch the ACLs of existing folders.

ECHO "========== DOWNLOAD CYGWIN SETUP =========="

IF NOT EXIST "%CYGWIN_LOCAL_CACHE_WFMT%\%SETUP%" (
  powershell -Command "(New-Object Net.WebClient).DownloadFile('http://www.cygwin.com/%SETUP%', '%CYGWIN_LOCAL_CACHE_WFMT%/%SETUP%')"
)

ECHO "========== INSTALL CYGWIN =========="

SET RUNSETUP=Y
IF EXIST "%CYGWIN_INSTALLDIR_WFMT%\etc\setup\installed.db" (
  SET RUNSETUP=N
)
IF NOT "%CYGWIN_QUIET%" == "Y" (
  SET RUNSETUP=Y
)

IF "%CYGWIN_FORCE%" == "Y" (
  SET RUNSETUP=Y
)

REM If you need to add packages, see https://cygwin.com/packages/package_list.html for package names
REM In the description of each package you also find the file list and maintainer there

IF "%RUNSETUP%"=="Y" (
  "%CYGWIN_LOCAL_CACHE_WFMT%\%SETUP%" ^
    --proxy "%PROXY%" ^
    --site "%CYGWIN_REPOSITORY%" ^
    --root "%CYGWIN_INSTALLDIR_WFMT%" ^
    --local-package-dir "%CYGWIN_LOCAL_CACHE_WFMT%" ^
    --no-shortcuts ^
    %CYGWIN_OPT% ^
    -P cygwin-devel,gcc-core,gcc-g++, ^
    -P rsync,patch,diffutils,curl,make,unzip,git,m4,perl,wget ^
    -P gdb,liblzma5 ^
    -P automake,automake1.14 ^
    -P pkg-config ^
    -P mingw64-%ARCH%-binutils,mingw64-%ARCH%-gcc-core,mingw64-%ARCH%-gcc-g++,mingw64-%ARCH%-windows_default_manifest ^
    -P mingw64-%ARCH%-headers,mingw64-%ARCH%-runtime,mingw64-%ARCH%-pthreads,mingw64-%ARCH%-zlib ^
    -P mingw64-%ARCH%-gtk3,mingw64-%ARCH%-libxml2,mingw64-%ARCH%-cairo ^
    -P mingw64-%ARCH%-gmp,mingw64-%ARCH%-mpfr ^
    -P libiconv-devel,libunistring-devel,libncurses-devel ^
    -P gettext-devel,libgettextpo-devel ^
    -P libglib2.0-devel,libgdk_pixbuf2.0-devel ^
    -P libtool,intltool ^
    -P gtk-update-icon-cache ^
    -P mingw64-x86_64-adwaita-icon-theme,mingw64-x86_64-adwaita-themes ^
    -P libfontconfig1 ^
    -P bison,flex ^
    %EXTRAPACKAGES% ^
    || GOTO ErrorExit

  MKDIR "%CYGWIN_INSTALLDIR_WFMT%\build"
  MKDIR "%CYGWIN_INSTALLDIR_WFMT%\build\buildlogs"
)

IF NOT "%CYGWIN_QUIET%" == "Y" (
  REM Like most setup programs, cygwin setup starts the real setup as a separate process, so wait for it.
  REM This is not required with the -cygquiet=Y and the resulting --no-admin option.
  :waitsetup
  tasklist /fi "imagename eq %SETUP%" | find ":" > NUL
  IF ERRORLEVEL 1 GOTO waitsetup
)

ECHO ========== CONFIGURE CYGWIN USER ACCOUNT ==========

REM In case this batch file is called from a cygwin bash (e.g. a git repo) we need to clear
REM HOME (otherwise we get to the home directory of the other installation)
REM PROFILEREAD (this is set to true if the /etc/profile has been read, which creates user)
SET "HOME="
SET "PROFILEREAD="

copy "%BATCHDIR%\windows\configure_profile.sh" "%CYGWIN_INSTALLDIR_WFMT%\var\tmp" || GOTO ErrorExit
%BASH% --login "%CYGWIN_INSTALLDIR_CFMT%/var/tmp/configure_profile.sh" "%PROXY%" || GOTO ErrorExit

REM Get cygwin user home folder as windows path
REM Note: we don't write the full path from cygwin, because it is a bit dangerous if this fails.
REM We want to prepend USER_HOME_DIR_MFMT here to be sure we stay in this folder.
SET /p USER_HOME_DIR_CFMT=<"%CYGWIN_INSTALLDIR_WFMT%\var\tmp\main_user_folder.txt"
SET USER_HOME_DIR_MFMT=%CYGWIN_INSTALLDIR_MFMT%%USER_HOME_DIR_CFMT%
SET USER_HOME_DIR_WFMT=%USER_HOME_DIR_MFMT:/=\%

ECHO ========== BUILD COQ PLATFORM ==========

IF "%BUILD_COQ_PLATFORM%" == "Y" (
  RMDIR /S /Q "%USER_HOME_DIR_MFMT%/coq-platform"
  MKDIR "%USER_HOME_DIR_MFMT%/coq-platform"
  XCOPY /S "%BATCHDIR%*.*" "%USER_HOME_DIR_WFMT%\coq-platform" || GOTO ErrorExit

  %BASH% --login "%CYGWIN_INSTALLDIR_CFMT%/%USER_HOME_DIR_CFMT%/coq-platform/coq_platform_make.sh" || GOTO ErrorExit

) ELSE (
  ECHO Note: Automatic Coq platform build has been disabled with -build=N
)

ECHO ========== FINISHED ==========

GOTO :EOF

ECHO ========== BATCH FUNCTIONS ==========

:PrintPars
  REM  01234567890123456789012345678901234567890123456789012345678901234567890123456789
  ECHO -arch     ^<32 or 64^> Set cygwin, ocaml and coq to 32 or 64 bit
  ECHO -build    ^<Y or N^> build coq platform
  ECHO -destcyg  ^<path to cygwin destination folder^>
  ECHO -proxy    ^<internet proxy^>
  ECHO -cygrepo  ^<cygwin download repository^>
  ECHO -cygcache ^<local cygwin repository/cache^>
  ECHO -cyglocal ^<Y or N^> install cygwin from cache
  ECHO -cygquiet ^<Y or N^> install cygwin without user interaction
  ECHO -srccache ^<local source code repository/cache^>
  ECHO(
  ECHO Parameter values (default or currently set):
  ECHO -arch     = %ARCH%
  ECHO -build    = %BUILD_COQ_PLATFORM%
  ECHO -destcyg  = %DESTCYG%
  ECHO -proxy    = %PROXY%
  ECHO -cygrepo  = %CYGWIN_REPOSITORY%
  ECHO -cygcache = %CYGWIN_LOCAL_CACHE_WFMT%
  ECHO -cyglocal = %CYGWIN_FROM_CACHE%
  ECHO -cygquiet = %CYGWIN_QUIET%
  GOTO :EOF

:CheckYN
  REM Reset errorlevel to 0
  CMD /c "EXIT /b 0"
  IF "%2" == "Y" (
    REM OK Y
  ) ELSE IF "%2" == "N" (
    REM OK N
  ) ELSE (
    ECHO ERROR Parameter %1 must be Y or N, but is %2
    GOTO ErrorExit
  )
  GOTO :EOF

:ErrorExit
  ECHO ERROR coq_platform_make_windows.bat failed
  EXIT /b 1
