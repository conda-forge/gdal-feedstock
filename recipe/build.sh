#!/bin/bash

if [ $(uname) == Darwin ]; then
    PGFLAG=""
    export LDFLAGS="-headerpad_max_install_names"
else
    PGFLAG="--with-pg=$PREFIX/bin/pg_config"
fi

CPPFLAGS="-I$PREFIX/include" LDFLAGS="-L$PREFIX/lib" \
./configure --prefix=$PREFIX \
            --with-hdf4=$PREFIX \
            --with-hdf5=$PREFIX \
            --with-xerces=$PREFIX \
            --with-netcdf=$PREFIX \
            --with-geos=$PREFIX/bin/geos-config \
            --with-static-proj4=$PREFIX \
            --with-openjpeg=$PREFIX \
            --with-libjson-c=$PREFIX \
            --with-expat=$PREFIX \
            --with-freexl=$PREFIX \
            --with-liblzma=$PREFIX \
            --with-spatialite=$PREFIX \
            --with-jpeg=$PREFIX \
            --with-libtiff=$PREFIX \
            --with-png=$PREFIX \
            --with-libz=$PREFIX \
            --with-xml2=$PREFIX \
            --disable-rpath \
            --without-pam \
            --with-python \
            --enable-debug \
            $PGFLAG

make
make install

# Make sure GDAL_DATA and set and still present in the package.
# https://github.com/conda/conda-recipes/pull/267
ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/gdal-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/gdal-deactivate.sh
