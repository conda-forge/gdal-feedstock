setlocal EnableDelayedExpansion

if "%ARCH%"=="64" (
    set WIN64="WIN64=YES"
) else (
    set WIN64=
)

:: Work out MSVC_VER - needed for build process.
:: Currently guess from Python version
if  %vc% LEQ 9 set MSVC_VER=1500
if  %vc% GTR 9 set MSVC_VER=1900

:: Need consistent flags between build and install.
set BLD_OPTS=%WIN64% ^
    MSVC_VER=%MSVC_VER% ^
    GDAL_HOME=%LIBRARY_PREFIX% ^
    BINDIR=%LIBRARY_BIN% ^
    LIBDIR=%LIBRARY_LIB% ^
    INCDIR=%LIBRARY_INC% ^
    DATADIR=%LIBRARY_PREFIX%\share\gdal ^
    HTMLDIR=%LIBRARY_PREFIX%\share\doc\gdal ^
    CURL_INC="-I%LIBRARY_INC%" ^
    CURL_LIB="%LIBRARY_LIB%\libcurl.lib wsock32.lib wldap32.lib winmm.lib" ^
    EXPAT_DIR=%LIBRARY_PREFIX% ^
    EXPAT_INCLUDE="-I%LIBRARY_INC%" ^
    EXPAT_LIB=%LIBRARY_LIB%\expat.lib ^
    FREEXL_CFLAGS="-I%LIBRARY_INC%" ^
    FREEXL_LIBS=%LIBRARY_LIB%\freexl_i.lib ^
    GEOS_CFLAGS="-I%LIBRARY_INC% -DHAVE_GEOS" ^
    GEOS_DIR=%LIBRARY_PREFIX% ^
    GEOS_LIB=%LIBRARY_LIB%\geos_c.lib ^
    HDF4_DIR=%LIBRARY_PREFIX% ^
    HDF4_HAS_MAXOPENFILES=YES ^
    HDF4_LIB="%LIBRARY_LIB%\hdf.lib %LIBRARY_LIB%\mfhdf.lib %LIBRARY_LIB%\xdr.lib" ^
    HDF5_DIR=%LIBRARY_PREFIX% ^
    HDF5_LIB=%LIBRARY_LIB%\hdf5.lib ^
    JPEGDIR=%LIBRARY_INC% ^
    JPEG_EXTERNAL_LIB=1 ^
    JPEG_LIB=%LIBRARY_LIB%\libjpeg.lib ^
    KEA_CFLAGS="-I%LIBRARY_INC%" ^
    KEA_LIB=%LIBRARY_LIB%\libkea.lib ^
    NETCDF_INC_DIR=%LIBRARY_INC% ^
    NETCDF_LIB=%LIBRARY_LIB%\netcdf.lib ^
    NETCDF_SETTING=yes ^
    OPENJPEG_CFLAGS="-I%LIBRARY_INC%\openjpeg-2.3" ^
    OPENJPEG_ENABLED=YES ^
    OPENJPEG_LIB=%LIBRARY_LIB%\openjp2.lib ^
    PG_INC_DIR=%LIBRARY_INC% ^
    PG_LIB=%LIBRARY_LIB%\libpq.lib ^
    PNGDIR=%LIBRARY_INC% ^
    PNG_EXTERNAL_LIB=1 ^
    PNG_LIB=%LIBRARY_LIB%\libpng.lib ^
    PROJ_FLAGS=-DPROJ_STATIC ^
    PROJ_INCLUDE="-I%LIBRARY_INC%" ^
    PROJ_LIBRARY=%LIBRARY_LIB%\proj.lib ^
    SPATIALITE_412_OR_LATER=yes ^
    SQLITE_INC="-I%LIBRARY_INC% -DHAVE_SPATIALITE" ^
    SQLITE_LIB="%LIBRARY_LIB%\sqlite3.lib %LIBRARY_LIB%\spatialite_i.lib" ^
    TIFF_INC="-I%LIBRARY_INC%" ^
    TIFF_LIB=%LIBRARY_LIB%\tiff.lib ^
    TIFF_OPTS=-DBIGTIFF_SUPPORT ^
    XERCES_DIR=%LIBRARY_PREFIX% ^
    XERCES_INCLUDE="-I%LIBRARY_INC% -I%LIBRARY_INC%\xercesc" ^
    XERCES_LIB=%LIBRARY_LIB%\xerces-c_3.lib ^
    GEOTIFF_INC="-I%LIBRARY_INC%" ^
    GEOTIFF_LIB=%LIBRARY_LIB%\geotiff_i.lib ^
    LIBICONV_INCLUDE="-I%LIBRARY_INC% -DICONV_CONST= " ^
    LIBICONV_LIBRARY="%LIBRARY_LIB%\iconv.lib"

endlocal && set BLD_OPTS=%BLD_OPTS%
