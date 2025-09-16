#!/bin/bash

set -ex # Abort on error.

cd build

cp -p CMakeCache.txt.orig CMakeCache.txt

if [[ "$PKG_NAME" == "libgdal-arrow-parquet" ]]; then
  # Remove build artifacts potentially generated with a different libarrow version
  rm -rf ogr/ogrsf_frmts/arrow
  rm -rf ogr/ogrsf_frmts/parquet
fi

if [[ "$PKG_NAME" == "libgdal-arrow-parquet" ]]; then
  CMAKE_ARGS="$CMAKE_ARGS \
      -DGDAL_USE_PARQUET=ON \
      -DGDAL_USE_ARROW=ON \
      -DGDAL_USE_ARROWDATASET=ON \
      -DOGR_ENABLE_DRIVER_ARROW=ON \
      -DOGR_ENABLE_DRIVER_ARROW_PLUGIN=ON \
      -DOGR_ENABLE_DRIVER_PARQUET=ON \
      -DOGR_ENABLE_DRIVER_PARQUET_PLUGIN=ON"
else
  GDAL_PLUGIN_TYPE=$(echo ${GDAL_PLUGIN_TYPE} | tr '[:lower:]' '[:upper:]')
  GDAL_PLUGIN_NAME=$(echo ${GDAL_PLUGIN_NAME} | tr '[:lower:]' '[:upper:]')
  CMAKE_ARGS="$CMAKE_ARGS ${GDAL_PLUGIN_DEPS}
      -D${GDAL_PLUGIN_TYPE}_ENABLE_DRIVER_${GDAL_PLUGIN_NAME}=ON \
      -D${GDAL_PLUGIN_TYPE}_ENABLE_DRIVER_${GDAL_PLUGIN_NAME}_PLUGIN=ON"
fi

# We reuse the same build directory as libgdal, so we just to have to
# turn on the required dependency and drivers
cmake "-U*LATER_PLUGIN" -DBUILD_PYTHON_BINDINGS:BOOL=OFF ${CMAKE_ARGS} ${SRC_DIR}

cmake --build . -j ${CPU_COUNT} --config Release
cmake --build . --target install
