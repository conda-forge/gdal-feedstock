#!/bin/bash

if [ $(uname) == Darwin ]; then
  export LDFLAGS="-headerpad_max_install_names"
  OPTS="--enable-rpath"
else
  OPTS="--with-pg=$PREFIX/bin/pg_config --disable-rpath"
fi

export LDFLAGS="$LDFLAGS -L$PREFIX/lib"
export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"

./configure --prefix=$PREFIX \
            --with-hdf4=$PREFIX \
            --with-hdf5=$PREFIX \
            --with-xerces=$PREFIX \
            --with-netcdf=$PREFIX \
            --with-geos=$PREFIX/bin/geos-config \
            --with-static-proj4=$PREFIX \
            --with-libz=$PREFIX \
            --with-png=$PREFIX \
            --with-jpeg=$PREFIX \
            --with-libtiff=$PREFIX \
            --with-openjpeg=$PREFIX \
            --without-pam \
            --with-python \
            --with-libjson-c=$PREFIX \
            --with-expat=$PREFIX \
            --with-freexl=$PREFIX \
            --with-xml2=$PREFIX \
            --with-spatialite=$PREFIX \
            --enable-debug \
            $OPTS

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
