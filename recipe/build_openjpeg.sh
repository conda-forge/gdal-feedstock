#!/bin/bash

set -ex # Abort on error.

cd build

cp CMakeCache.txt.orig CMakeCache.txt

# We reuse the same build directory as libgdal, so we just to have to
# turn on the required dependency and drivers
cmake -DBUILD_PYTHON_BINDINGS:BOOL=OFF \
      -DGDAL_USE_OPENJPEG=ON \
      -DGDAL_ENABLE_DRIVER_OPENJPEG=ON \
      -DGDAL_ENABLE_DRIVER_OPENJPEG_PLUGIN=ON \
      ${SRC_DIR}

cmake --build . -j ${CPU_COUNT} --config Release
cmake --build . --target install
