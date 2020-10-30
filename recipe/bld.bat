setlocal enableextensions

RMDIR /s /q ext\fiddle\libffi-3.2.1

CALL win32\configure.bat --prefix=%LIBRARY_PREFIX%
if %errorlevel% neq 0 exit /b %errorlevel%

nmake
if %errorlevel% neq 0 exit /b %errorlevel%

nmake install
if %errorlevel% neq 0 exit /b %errorlevel%

mkdir %LIBRARY_PREFIX%\etc
if %errorlevel% neq 0 exit /b %errorlevel%

mkdir %LIBRARY_PREFIX%\share\rubygems
if %errorlevel% neq 0 exit /b %errorlevel%

echo "gemhome: %LIBRARY_PREFIX%/share/rubygems" > %LIBRARY_PREFIX%/etc/gemrc
if %errorlevel% neq 0 exit /b %errorlevel%

setlocal EnableDelayedExpansion
:: Copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
for %%F in (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    copy %RECIPE_DIR%\%%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat
    if %errorlevel% neq 0 exit /b %errorlevel%

    :: Copy unix shell activation scripts, needed by Windows Bash users
    copy %RECIPE_DIR%\%%F.sh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.sh
    if %errorlevel% neq 0 exit /b %errorlevel%
)