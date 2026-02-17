#!/bin/bash

set -xe

# now re-configure with BUILD_PYTHON_BINDINGS:BOOL=ON

cd build

rm -rf swig/python

Python_LOOKUP_VERSION=$($PYTHON -c "import sys; print(str(sys.version_info.major)+'.'+str(sys.version_info.minor)+'.'+str(sys.version_info.micro))")

Python_NumPy_INCLUDE_DIR=$($PYTHON -c "import numpy; print(numpy.get_include())")

cmake "-UPython*" "-U*LATER_PLUGIN" \
      -DGDAL_USE_ADBCDRIVERMANAGER=OFF \
      -DPython_LOOKUP_VERSION=${Python_LOOKUP_VERSION} \
      -DPython_NumPy_INCLUDE_DIR=${Python_NumPy_INCLUDE_DIR} \
      -DBUILD_PYTHON_BINDINGS:BOOL=ON \
      ${SRC_DIR} || (cat CMakeFiles/CMakeError.log;false)

cmake --build . --target python_generated_files
cd swig/python

$PYTHON setup.py build_ext

$PYTHON -m pip install --no-deps --ignore-installed --no-build-isolation .
