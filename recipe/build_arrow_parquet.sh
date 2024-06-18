#!/bin/bash

set -ex # Abort on error.

cd build

cp CMakeCache.txt.orig CMakeCache.txt

# Remove build artifacts potentially generated with a different libarrow version
rm -rf ogr/ogrsf_frmts/arrow
rm -rf ogr/ogrsf_frmts/parquet

# We reuse the same build directory as libgdal, so we just to have to
# turn on the required dependency and drivers
cmake -DBUILD_PYTHON_BINDINGS:BOOL=OFF \
      -DGDAL_USE_PARQUET=ON \
      -DGDAL_USE_ARROW=ON \
      -DGDAL_USE_ARROWDATASET=ON \
      -DOGR_ENABLE_DRIVER_ARROW=ON \
      -DOGR_ENABLE_DRIVER_ARROW_PLUGIN=ON \
      -DOGR_ENABLE_DRIVER_PARQUET=ON \
      -DOGR_ENABLE_DRIVER_PARQUET_PLUGIN=ON \
      ${SRC_DIR}

cmake --build . -j ${CPU_COUNT} --config Release
cmake --build . --target install
