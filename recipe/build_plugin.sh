#!/bin/bash

set -ex # Abort on error.

cd build

cp CMakeCache.txt.orig CMakeCache.txt

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

elif [[ "$PKG_NAME" == "libgdal-jp2openjpeg" ]]; then
  CMAKE_ARGS="$CMAKE_ARGS \
      -DGDAL_USE_OPENJPEG=ON \
      -DGDAL_ENABLE_DRIVER_JP2OPENJPEG=ON \
      -DGDAL_ENABLE_DRIVER_JP2OPENJPEG_PLUGIN=ON"

elif [[ "$PKG_NAME" == "libgdal-pdf" ]]; then
  CMAKE_ARGS="$CMAKE_ARGS \
      -DGDAL_USE_POPPLER=ON \
      -DGDAL_ENABLE_DRIVER_PDF=ON \
      -DGDAL_ENABLE_DRIVER_PDF_PLUGIN=ON"
fi

# We reuse the same build directory as libgdal, so we just to have to
# turn on the required dependency and drivers
cmake -DBUILD_PYTHON_BINDINGS:BOOL=OFF ${CMAKE_ARGS} ${SRC_DIR}

cmake --build . -j ${CPU_COUNT} --config Release
cmake --build . --target install
