mkdir build
if errorlevel 1 exit 1
cd build
if errorlevel 1 exit 1

if  %vc% LEQ 9 set MSVC_VER=1500
if  %vc% GTR 9 set MSVC_VER=1900

if  %vc% LEQ 9 set MSVC_TS_VER=90
if  %vc% GTR 9 set MSVC_TS_VER=140

REM Make sure to disable Arrow/Parquet dependencies for now, so they are only
REM used in build_arrow_parquet

cmake -G "Ninja" ^
      "%CMAKE_ARGS%" ^
      -DMSVC_VERSION="%MSVC_VER%" ^
      -DMSVC_TOOLSET_VERSION="%MSVC_TS_VER%" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
      -DBUILD_SHARED_LIBS=ON ^
      -DBUILD_TESTING=OFF ^
      -DBUILD_PYTHON_BINDINGS:BOOL=OFF ^
      -DBUILD_JAVA_BINDINGS:BOOL=OFF ^
      -DBUILD_CSHARP_BINDINGS:BOOL=OFF ^
      -DGDAL_USE_KEA:BOOL=ON ^
      -DKEA_INCLUDE_DIR:PATH="%LIBRARY_INC%" ^
      -DKEA_LIBRARY:PATH="%LIBRARY_LIB%\libkea.lib" ^
      -DGDAL_USE_MYSQL:BOOL=OFF ^
      -DGDAL_USE_MSSQL_ODBC:BOOL=OFF ^
      -DGDAL_USE_PARQUET=OFF ^
      -DGDAL_USE_ARROW=OFF ^
      -DGDAL_USE_ARROWDATASET=OFF ^
      -DOGR_REGISTER_DRIVER_ARROW_FOR_LATER_PLUGIN=ON ^
      -DOGR_REGISTER_DRIVER_PARQUET_FOR_LATER_PLUGIN=ON ^
      -DGDAL_REGISTER_DRIVER_JP2OPENJPEG_FOR_LATER_PLUGIN=ON ^
      -DOGR_DRIVER_ARROW_PLUGIN_INSTALLATION_MESSAGE="You may install it with with 'conda install -c conda-forge libgdal-arrow-parquet'" ^
      -DOGR_DRIVER_PARQUET_PLUGIN_INSTALLATION_MESSAGE="You may install it with with 'conda install -c conda-forge libgdal-arrow-parquet'" ^
      -DGDAL_DRIVER_JP2OPENJPEG_PLUGIN_INSTALLATION_MESSAGE="You may install it with with 'conda install -c conda-forge libgdal-openjpeg'" ^
      "%SRC_DIR%"

if errorlevel 1 exit /b 1

cmake --build . -j %CPU_COUNT% --verbose --config Release
if errorlevel 1 exit /b 1

copy CMakeCache.txt CMakeCache.txt.orig

cmake --build . --config Release --target install
if errorlevel 1 exit /b 1

set ACTIVATE_DIR=%PREFIX%\etc\conda\activate.d
set DEACTIVATE_DIR=%PREFIX%\etc\conda\deactivate.d
mkdir %ACTIVATE_DIR%
mkdir %DEACTIVATE_DIR%

copy %RECIPE_DIR%\scripts\activate.bat %ACTIVATE_DIR%\gdal-activate.bat
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.bat %DEACTIVATE_DIR%\gdal-deactivate.bat
if errorlevel 1 exit 1


:: Copy powershell activation scripts
copy %RECIPE_DIR%\scripts\activate.ps1 %ACTIVATE_DIR%\gdal-activate.ps1
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.ps1 %DEACTIVATE_DIR%\gdal-deactivate.ps1
if errorlevel 1 exit 1



:: Copy unix shell activation scripts, needed by Windows Bash users
copy %RECIPE_DIR%\scripts\activate.sh %ACTIVATE_DIR%\gdal-activate.sh
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.sh %DEACTIVATE_DIR%\gdal-deactivate.sh
if errorlevel 1 exit 1
