cd build
if errorlevel 1 exit 1

copy CMakeCache.txt.orig CMakeCache.txt

REM Remove build artifacts potentially generated with a different libarrow version
if "%PKG_NAME%" == "libgdal-arrow-parquet" (
  rmdir ogr\ogrsf_frmts\arrow /s /q
  rmdir ogr\ogrsf_frmts\parquet /s /q
)

if "%PKG_NAME%" == "libgdal-arrow-parquet" (
  set CMAKE_ARGS=%CMAKE_ARGS% ^
      -DGDAL_USE_PARQUET=ON ^
      -DGDAL_USE_ARROW=ON ^
      -DGDAL_USE_ARROWDATASET=ON ^
      -DOGR_ENABLE_DRIVER_ARROW=ON ^
      -DOGR_ENABLE_DRIVER_ARROW_PLUGIN=ON ^
      -DOGR_ENABLE_DRIVER_PARQUET=ON ^
      -DOGR_ENABLE_DRIVER_PARQUET_PLUGIN=ON
)

if "%PKG_NAME%" == "libgdal-jp2openjpeg" (
  set CMAKE_ARGS=%CMAKE_ARGS% ^
      -DGDAL_USE_OPENJPEG=ON ^
      -DGDAL_ENABLE_DRIVER_JP2OPENJPEG=ON ^
      -DGDAL_ENABLE_DRIVER_JP2OPENJPEG_PLUGIN=ON
)

if "%PKG_NAME%" == "libgdal-pdf" (
  set CMAKE_ARGS=%CMAKE_ARGS% ^
      -DGDAL_USE_POPPLER=ON ^
      -DGDAL_ENABLE_DRIVER_PDF=ON ^
      -DGDAL_ENABLE_DRIVER_PDF_PLUGIN=ON
)

if "%PKG_NAME%" == "libgdal-postgisraster" (
  set CMAKE_ARGS=%CMAKE_ARGS% ^
      -DGDAL_USE_POSTGRESQL=ON ^
      -DGDAL_ENABLE_DRIVER_POSTGISRASTER=ON ^
      -DGDAL_ENABLE_DRIVER_POSTGISRASTER_PLUGIN=ON
)

if "%PKG_NAME%" == "libgdal-pg" (
  set CMAKE_ARGS=%CMAKE_ARGS% ^
      -DGDAL_USE_POSTGRESQL=ON ^
      -DOGR_ENABLE_DRIVER_PG=ON ^
      -DOGR_ENABLE_DRIVER_PG_PLUGIN=ON
)

REM We reuse the same build directory as libgdal, so we just to have to
REM turn on the required dependency and drivers
cmake -DBUILD_PYTHON_BINDINGS:BOOL=OFF %CMAKE_ARGS% "%SRC_DIR%"
if errorlevel 1 exit /b 1

cmake --build . -j %CPU_COUNT% --verbose --config Release
if errorlevel 1 exit /b 1

cmake --build . --target install --config Release
if errorlevel 1 exit /b 1
