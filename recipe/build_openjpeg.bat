cd build
if errorlevel 1 exit 1

copy CMakeCache.txt.orig CMakeCache.txt

REM We reuse the same build directory as libgdal, so we just to have to
REM turn on the required dependency and drivers
cmake -DBUILD_PYTHON_BINDINGS:BOOL=OFF ^
      -DGDAL_USE_OPENJPEG=ON ^
      -DGDAL_ENABLE_DRIVER_JP2OPENJPEG=ON ^
      -DGDAL_ENABLE_DRIVER_JP2OPENJPEG_PLUGIN=ON ^
      "%SRC_DIR%"

if errorlevel 1 exit /b 1

cmake --build . -j %CPU_COUNT% --verbose --config Release
if errorlevel 1 exit /b 1

cmake --build . --target install --config Release
if errorlevel 1 exit /b 1
