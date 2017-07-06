#!/bin/bash

rm -rf $PREFIX/lib/*.la

if [ $(uname) == Darwin ]; then
    export LDFLAGS="-headerpad_max_install_names"
    OPTS="--enable-rpath"
    export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
    COMP_CC=clang
    COMP_CXX=clang++
    export MACOSX_DEPLOYMENT_TARGET="10.9"
    export CXXFLAGS="${CXXFLAGS} -stdlib=libc++"
    export LDFLAGS="${LDFLAGS} -headerpad_max_install_names"
else
    OPTS="--disable-rpath"
    COMP_CC=gcc
    COMP_CXX=g++
fi

export LDFLAGS="$LDFLAGS -L$PREFIX/lib"
export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"

./configure CC=$COMP_CC \
            CXX=$COMP_CXX \
            --with-python \
            --prefix=$PREFIX \
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
             --with-dods-root=$PREFIX \
             $OPTS

pushd swig/python

# Regenerate python bindings.
make veryclean
make generate

$PYTHON setup.py build_ext \
    --include-dirs $INCLUDE_PATH \
    --library-dirs $LIBRARY_PATH \
    --gdal-config gdal-config
$PYTHON setup.py build_py
$PYTHON setup.py build_scripts
$PYTHON setup.py install

popd
