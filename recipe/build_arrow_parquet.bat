cd build
if errorlevel 1 exit 1

copy CMakeCache.txt.orig CMakeCache.txt

REM Remove build artifacts potentially generated with a different libarrow version
rmdir ogr\ogrsf_frmts\arrow /s /q
rmdir ogr\ogrsf_frmts\parquet /s /q

REM We reuse the same build directory as libgdal, so we just to have to
REM turn on the required dependency and drivers
cmake -DBUILD_PYTHON_BINDINGS:BOOL=OFF ^
      -DGDAL_USE_PARQUET=ON ^
      -DGDAL_USE_ARROW=ON ^
      -DGDAL_USE_ARROWDATASET=ON ^
      -DOGR_ENABLE_DRIVER_ARROW=ON ^
      -DOGR_ENABLE_DRIVER_ARROW_PLUGIN=ON ^
      -DOGR_ENABLE_DRIVER_PARQUET=ON ^
      -DOGR_ENABLE_DRIVER_PARQUET_PLUGIN=ON ^
      "%SRC_DIR%"

if errorlevel 1 exit /b 1

cmake --build . -j %CPU_COUNT% --verbose --config Release
if errorlevel 1 exit /b 1

cmake --build . --target install --config Release
if errorlevel 1 exit /b 1
