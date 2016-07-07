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

IF "%MSVC_VER%"=="" (
    echo "Python version not supported. Please update bld.bat"
    exit 1
)

:: Need consistent flags between build and install.
set BLD_OPTS=%WIN64% ^
    MSVC_VER=%MSVC_VER% ^
    PYDIR=%PREFIX% ^
    GDAL_HOME=%LIBRARY_PREFIX% ^
    BINDIR=%LIBRARY_BIN% ^
    LIBDIR=%LIBRARY_LIB% ^
    INCDIR=%LIBRARY_INC% ^
    DATADIR=%LIBRARY_PREFIX%\share\gdal ^
    HTMLDIR=%LIBRARY_PREFIX%\share\doc\gdal ^
    HDF4_DIR=%LIBRARY_PREFIX% ^
    HDF4_LIB="%LIBRARY_LIB%\hdf.lib %LIBRARY_LIB%\mfhdf.lib %LIBRARY_LIB%\xdr.lib" ^
    HDF4_HAS_MAXOPENFILES=YES ^
    HDF5_LIB=%LIBRARY_LIB%\hdf5.lib ^
    HDF5_DIR=%LIBRARY_PREFIX% ^
    GEOS_DIR=%LIBRARY_PREFIX% ^
    GEOS_CFLAGS="-I%LIBRARY_INC% -DHAVE_GEOS" ^
    GEOS_LIB=%LIBRARY_LIB%\geos_c.lib ^
    XERCES_DIR=%LIBRARY_PREFIX% ^
    XERCES_INCLUDE="-I%LIBRARY_INC% -I%LIBRARY_INC%\xercesc" ^
    XERCES_LIB=%LIBRARY_LIB%\xerces-c_3.lib ^
    NETCDF_LIB=%LIBRARY_LIB%\netcdf.lib ^
    NETCDF_INC_DIR=%LIBRARY_INC% ^
    NETCDF_SETTING=yes ^
    KEA_CFLAGS="-I%LIBRARY_INC%" ^
    KEA_LIB=%LIBRARY_LIB%\libkea.lib ^
    TIFF_INC="-I%LIBRARY_INC%" ^
    TIFF_LIB=%LIBRARY_LIB%\libtiff_i.lib ^
    TIFF_OPTS=-DBIGTIFF_SUPPORT ^
    PNG_EXTERNAL_LIB=1 ^
    PNGDIR=%LIBRARY_INC% ^
    PNG_LIB=%LIBRARY_LIB%\libpng.lib ^
    JPEG_EXTERNAL_LIB=1 ^
    JPEGDIR=%LIBRARY_INC% ^
    JPEG_LIB=%LIBRARY_LIB%\libjpeg.lib ^
    PROJ_FLAGS=-DPROJ_STATIC ^
    PROJ_INCLUDE="-I%LIBRARY_INC%" ^
    PROJ_LIBRARY=%LIBRARY_LIB%\proj.lib ^
    OPENJPEG_ENABLED=YES ^
    OPENJPEG_CFLAGS="-I%LIBRARY_INC%" ^
    OPENJPEG_LIB=%LIBRARY_LIB%\openjp2.lib ^
    OPENJPEG_VERSION=20100 ^
    CURL_INC="-I%LIBRARY_INC%" ^
    CURL_LIB="%LIBRARY_LIB%\libcurl.lib wsock32.lib wldap32.lib winmm.lib" ^
    FREEXL_CFLAGS="-I%LIBRARY_INC%" ^
    FREEXL_LIBS=%LIBRARY_LIB%\freexl_i.lib ^
    EXPAT_DIR=%LIBRARY_PREFIX% ^
    EXPAT_INCLUDE="-I%LIBRARY_INC%" ^
    EXPAT_LIB=%LIBRARY_LIB%\expat.lib ^
    SQLITE_INC="-I%LIBRARY_INC% -DHAVE_SPATIALITE" ^
    SQLITE_LIB="%LIBRARY_LIB%\sqlite3.lib %LIBRARY_LIB%\spatialite_i.lib" ^
    SPATIALITE_412_OR_LATER=yes

nmake /f makefile.vc %BLD_OPTS%
if errorlevel 1 exit 1

mkdir -p %LIBRARY_PREFIX%\share\doc\gdal

nmake /f makefile.vc devinstall %BLD_OPTS%
if errorlevel 1 exit 1

copy *.lib %LIBRARY_LIB%\ || exit 1
if errorlevel 1 exit 1

:: Python bindings
cd swig\python
%PYTHON% setup.py build
if errorlevel 1 exit 1

%PYTHON% setup.py install
if errorlevel 1 exit 1
cd ..\..

set ACTIVATE_DIR=%PREFIX%\etc\conda\activate.d
set DEACTIVATE_DIR=%PREFIX%\etc\conda\deactivate.d
mkdir %ACTIVATE_DIR%
mkdir %DEACTIVATE_DIR%

copy %RECIPE_DIR%\scripts\activate.bat %ACTIVATE_DIR%\gdal-activate.bat
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.bat %DEACTIVATE_DIR%\gdal-deactivate.bat
if errorlevel 1 exit 1
