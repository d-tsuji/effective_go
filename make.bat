@ECHO OFF

pushd %~dp0

REM Command file for Sphinx documentation

if "%SPHINXBUILD%" == "" (
	set SPHINXBUILD=sphinx-build
)
set SOURCEDIR=source
set BUILDDIR=_build
REM set BUILDDIR=docs

if "%1" == "" goto help

if "%1" == "preview" (
	echo.Running sphinx-autobuild. View live edits at:
	echo.  http://0.0.0.0:8000
	sphinx-autobuild -b html %SOURCEDIR% %BUILDDIR%/html
	if errorlevel 1 exit /b 1
	echo.
	for /d %%i in (%BUILDDIR%\*) do rmdir /q /s %%i
	del /q /s %BUILDDIR%\*
	echo.cleaned dir "%BUILDDIR%".
	goto end
)

if "%1" == "clean" (
	for /d %%i in (%BUILDDIR%\*) do rmdir /q /s %%i
	del /q /s %BUILDDIR%\*
	echo.
	echo.cleaned dir "%BUILDDIR%"
	goto end
)

%SPHINXBUILD% >NUL 2>NUL
if errorlevel 9009 (
	echo.
	echo.The 'sphinx-build' command was not found. Make sure you have Sphinx
	echo.installed, then set the SPHINXBUILD environment variable to point
	echo.to the full path of the 'sphinx-build' executable. Alternatively you
	echo.may add the Sphinx directory to PATH.
	echo.
	echo.If you don't have Sphinx installed, grab it from
	echo.http://sphinx-doc.org/
	exit /b 1
)

REM %SPHINXBUILD% -M %1 %SOURCEDIR% %BUILDDIR% %SPHINXOPTS% %O%
REM goto end

:html
%SPHINXBUILD% -b html %SOURCEDIR% %BUILDDIR% %SPHINXOPTS% %O%
REM %SPHINXBUILD% -M latexpdf %SOURCEDIR% %BUILDDIR% %SPHINXOPTS% %O%
REM cp build/latex/go.pdf ./docs
goto end

:help
%SPHINXBUILD% -M help %SOURCEDIR% %BUILDDIR% %SPHINXOPTS% %O%


:end
popd
