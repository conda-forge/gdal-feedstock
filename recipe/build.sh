#!/bin/bash
# Get an updated config.sub and config.guess
# cp $BUILD_PREFIX/share/gnuconfig/config.* .

set -ex # Abort on error.

# also allow newer symbols (https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk)
export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

mkdir build
cd build

# Make sure to disable Arrow/Parquet dependencies for now, so they are only
# used in build_arrow_parquet
cmake -G "Unix Makefiles" \
      ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_TESTING=OFF \
      -DGDAL_USE_PARQUET=OFF \
      -DGDAL_USE_ARROW=OFF \
      -DGDAL_USE_ARROWDATASET=OFF \
      -DGDAL_USE_OPENJPEG=OFF \
      -DOGR_REGISTER_DRIVER_ARROW_FOR_LATER_PLUGIN=ON \
      -DOGR_REGISTER_DRIVER_PARQUET_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_JP2OPENJPEG_FOR_LATER_PLUGIN=ON \
      -DOGR_DRIVER_ARROW_PLUGIN_INSTALLATION_MESSAGE="You may install it with with 'conda install -c conda-forge libgdal-arrow-parquet'" \
      -DOGR_DRIVER_PARQUET_PLUGIN_INSTALLATION_MESSAGE="You may install it with with 'conda install -c conda-forge libgdal-arrow-parquet'" \
      -DGDAL_DRIVER_JP2OPENJPEG_PLUGIN_INSTALLATION_MESSAGE="You may install it with with 'conda install -c conda-forge libgdal-openjpeg'" \
      -DGDAL_ENABLE_HDF5_GLOBAL_LOCK:BOOL=ON \
      -DBUILD_PYTHON_BINDINGS:BOOL=OFF \
      -DBUILD_JAVA_BINDINGS:BOOL=OFF \
      -DBUILD_CSHARP_BINDINGS:BOOL=OFF \
      ${SRC_DIR}

cmake --build . -j ${CPU_COUNT} --config Release

# save cache file for later
cp CMakeCache.txt CMakeCache.txt.orig

cmake --build . --target install

# Make sure GDAL_DATA and set and still present in the package.
# https://github.com/conda/conda-recipes/pull/267
ACTIVATE_DIR=${PREFIX}/etc/conda/activate.d
DEACTIVATE_DIR=${PREFIX}/etc/conda/deactivate.d
mkdir -p ${ACTIVATE_DIR}
mkdir -p ${DEACTIVATE_DIR}

cp ${RECIPE_DIR}/scripts/activate.sh ${ACTIVATE_DIR}/gdal-activate.sh
cp ${RECIPE_DIR}/scripts/deactivate.sh ${DEACTIVATE_DIR}/gdal-deactivate.sh
