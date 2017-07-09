if "%ARCH%"=="64" (
    set WIN64="WIN64=YES"
) else (
    set WIN64=
)

:: Work out MSVC_VER - needed for build process.
:: Currently guess from Python version
if "%CONDA_PY%" == "27" (
    set MSVC_VER=1500
)
if "%CONDA_PY%" == "34" (
    set MSVC_VER=1600
)
if "%CONDA_PY%" == "35" (
    set MSVC_VER=1900
)
if "%CONDA_PY%" == "36" (
    set MSVC_VER=1900
)

if "%MSVC_VER%"=="" (
    echo "Python version not supported. Please update bld.bat"
    exit 1
)

:: Need consistent flags between build and install.
set BLD_OPTS=%WIN64% ^
    MSVC_VER=%MSVC_VER% ^
    GDAL_HOME=%LIBRARY_PREFIX% ^
    BINDIR=%LIBRARY_BIN% ^
    LIBDIR=%LIBRARY_LIB% ^
    INCDIR=%LIBRARY_INC% ^
    DATADIR=%LIBRARY_PREFIX%\share\gdal ^
    HTMLDIR=%LIBRARY_PREFIX%\share\doc\gdal

nmake /f makefile.vc %BLD_OPTS%
if errorlevel 1 exit 1

cd swig\python

%PYTHON% setup.py build_ext --include-dirs %LIBRARY_INC% --library-dirs %LIBRARY_LIB% --gdal-config %LIBRARY_BIN%\gdal-config
if errorlevel 1 exit 1

%PYTHON% setup.py build_py
if errorlevel 1 exit 1

%PYTHON% setup.py build_scripts
if errorlevel 1 exit 1

%PYTHON% setup.py install
if errorlevel 1 exit 1

rd /s /q %SP_DIR%\numpy
if errorlevel 1 exit 1
