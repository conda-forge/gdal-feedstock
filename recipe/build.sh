#!/bin/bash

if [ $(uname) == Darwin ]; then
    export LDFLAGS="-headerpad_max_install_names"
    OPTS="--enable-rpath"
else
    OPTS="--disable-rpath"
fi

export LDFLAGS="$LDFLAGS -L$PREFIX/lib"
export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"

# `--without-pam` was removed.
# See https://github.com/conda-forge/gdal-feedstock/pull/47 for the discussion.

./configure --prefix=$PREFIX \
            --with-hdf4=$PREFIX \
            --with-hdf5=$PREFIX \
            --with-xerces=$PREFIX \
            --with-netcdf=$PREFIX \
            --with-geos=$PREFIX/bin/geos-config \
            --with-kea=$PREFIX/bin/kea-config \
            --with-static-proj4=$PREFIX \
            --with-libz=$PREFIX \
            --with-png=$PREFIX \
            --with-jpeg=$PREFIX \
            --with-libjson-c=$PREFIX \
            --with-expat=$PREFIX \
            --with-freexl=$PREFIX \
            --with-libtiff=$PREFIX \
            --with-xml2=$PREFIX \
            --with-openjpeg=$PREFIX \
            --with-spatialite=$PREFIX \
            --with-pg=$PREFIX/bin/pg_config \
            --with-sqlite3=$PREFIX \
            --with-curl \
            --with-python \
            $OPTS


if [[ $(uname) == Darwin ]]; then
    OPTS="-s"  # Silence log to avoid Travis-CI 4 MB limit.
else
    OPTS=""
fi

make $OPTS
make install

# Make sure GDAL_DATA and set and still present in the package.
# https://github.com/conda/conda-recipes/pull/267
ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/gdal-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/gdal-deactivate.sh
