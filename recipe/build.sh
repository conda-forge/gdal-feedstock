#!/bin/bash

set -e # Abort on error.

# Get rid of any `.la` from defaults.
find $PREFIX/lib -name '*.la' -delete

# Force python bindings to not be built.
unset PYTHON

if [ $(uname) != Darwin ]; then
  export CFLAGS="-O2 -Wl,-S $CFLAGS"
  export CXXFLAGS="-O2 -Wl,-S $CXXFLAGS"
fi

export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"

# Filter out -std=.* from CXXFLAGS as it disrupts checks for C++ language levels.
re='(.*[[:space:]])\-std\=[^[:space:]]*(.*)'
if [[ "${CXXFLAGS}" =~ $re ]]; then
    export CXXFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
fi

# `--without-pam` was removed.
# See https://github.com/conda-forge/gdal-feedstock/pull/47 for the discussion.

bash configure --prefix=$PREFIX \
               --host=$HOST \
               --with-curl \
               --with-dods-root=$PREFIX \
               --with-expat=$PREFIX \
               --with-freexl=$PREFIX \
               --with-geos=$PREFIX/bin/geos-config \
               --with-geotiff=$PREFIX \
               --with-hdf4=$PREFIX \
               --with-hdf5=$PREFIX \
               --with-jpeg=$PREFIX \
               --with-kea=$PREFIX/bin/kea-config \
               --with-libiconv-prefix=$PREFIX \
               --with-libjson-c=$PREFIX \
               --with-libkml=$PREFIX \
               --with-liblzma=yes \
               --with-libtiff=$PREFIX \
               --with-libz=$PREFIX \
               --with-netcdf=$PREFIX \
               --with-openjpeg=$PREFIX \
               --with-pcre \
               --with-pg=$PREFIX/bin/pg_config \
               --with-png=$PREFIX \
               --with-poppler=$PREFIX \
               --with-spatialite=$PREFIX \
               --with-sqlite3=$PREFIX \
               --with-static-proj4=$PREFIX \
               --with-xerces=$PREFIX \
               --with-xml2=$PREFIX \
               --without-python \
               --verbose \
               $OPTS

make -j $CPU_COUNT ${VERBOSE_AT}
