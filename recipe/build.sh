#!/bin/bash
# Get an updated config.sub and config.guess
# cp $BUILD_PREFIX/share/gnuconfig/config.* .

set -ex # Abort on error.

# also allow newer symbols (https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk)
export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY -DHAVE_POPPLER"

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
      -DGDAL_USE_POPPLER=OFF \
      -DGDAL_USE_POSTGRESQL=OFF \
      -DGDAL_USE_CFITSIO=OFF \
      -DGDAL_USE_FREEXL=OFF \
      -DGDAL_USE_LIBAEC=OFF \
      -DGDAL_USE_KEA=OFF \
      -DGDAL_USE_TILEDB=OFF \
      -DGDAL_USE_NETCDF=OFF \
      -DGDAL_USE_HDF4=OFF \
      -DGDAL_USE_HDF5=OFF \
      -DGDAL_USE_AVIF=OFF \
      -DGDAL_USE_HEIF=OFF \
      -DOGR_ENABLE_DRIVER_ARROW=OFF \
      -DOGR_ENABLE_DRIVER_PARQUET=OFF \
      -DGDAL_ENABLE_DRIVER_JP2OPENJPEG=OFF \
      -DGDAL_ENABLE_DRIVER_PDF=OFF \
      -DGDAL_ENABLE_DRIVER_POSTGISRASTER=OFF \
      -DOGR_ENABLE_DRIVER_PG=OFF \
      -DGDAL_ENABLE_DRIVER_FITS=OFF \
      -DOGR_ENABLE_DRIVER_XLS=OFF \
      -DGDAL_ENABLE_DRIVER_GRIB=OFF \
      -DGDAL_ENABLE_DRIVER_KEA=OFF \
      -DGDAL_ENABLE_DRIVER_TILEDB=OFF \
      -DGDAL_ENABLE_DRIVER_NETCDF=OFF \
      -DGDAL_ENABLE_DRIVER_HDF4=OFF \
      -DGDAL_ENABLE_DRIVER_HDF5=OFF \
      -DGDAL_ENABLE_DRIVER_AVIF=OFF \
      -DGDAL_ENABLE_DRIVER_HEIF=OFF \
      -DOGR_REGISTER_DRIVER_ARROW_FOR_LATER_PLUGIN=ON \
      -DOGR_REGISTER_DRIVER_PARQUET_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_JP2OPENJPEG_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_PDF_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_POSTGISRASTER_FOR_LATER_PLUGIN=ON \
      -DOGR_REGISTER_DRIVER_PG_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_FITS_FOR_LATER_PLUGIN=ON \
      -DOGR_REGISTER_DRIVER_XLS_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_GRIB_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_KEA_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_TILEDB_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_NETCDF_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_HDF4_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_HDF5_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_AVIF_FOR_LATER_PLUGIN=ON \
      -DGDAL_REGISTER_DRIVER_HEIF_FOR_LATER_PLUGIN=ON \
      -DOGR_DRIVER_ARROW_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-arrow-parquet'" \
      -DOGR_DRIVER_PARQUET_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-arrow-parquet'" \
      -DGDAL_DRIVER_JP2OPENJPEG_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-jp2openjpeg'" \
      -DGDAL_DRIVER_PDF_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-pdf'" \
      -DGDAL_DRIVER_POSTGISRASTER_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-postgisraster'" \
      -DOGR_DRIVER_PG_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-pg'" \
      -DGDAL_DRIVER_FITS_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-fits'" \
      -DOGR_DRIVER_XLS_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-xls'" \
      -DGDAL_DRIVER_GRIB_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-grib'" \
      -DGDAL_DRIVER_KEA_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-kea'" \
      -DGDAL_DRIVER_TILEDB_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-tiledb'" \
      -DGDAL_DRIVER_NETCDF_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-netcdf'" \
      -DGDAL_DRIVER_HDF4_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-hdf4'" \
      -DGDAL_DRIVER_HDF5_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-hdf5'" \
      -DGDAL_ENABLE_HDF5_GLOBAL_LOCK:BOOL=ON \
      -DGDAL_DRIVER_AVIF_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-avif'" \
      -DGDAL_DRIVER_HEIF_PLUGIN_INSTALLATION_MESSAGE="You may install it with 'conda install -c conda-forge libgdal-heif'" \
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
