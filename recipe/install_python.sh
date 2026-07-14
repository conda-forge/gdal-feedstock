#!/bin/bash

set -xe

# now re-configure with BUILD_PYTHON_BINDINGS:BOOL=ON

cd build

rm -rf swig/python

Python_NumPy_INCLUDE_DIR=$($PYTHON -c "import numpy; print(numpy.get_include())")

# Pass the interpreter explicitly (mirroring install_python.bat) rather than using
# Python_LOOKUP_VERSION: the version-based find_package searches for "python3.14" and
# cannot locate the free-threaded "python3.14t" interpreter (cp314t variant).
cmake "-UPython*" "-U*LATER_PLUGIN" \
      -DGDAL_USE_ADBCDRIVERMANAGER=OFF \
      -DPython_EXECUTABLE="$PYTHON" \
      -DPython_NumPy_INCLUDE_DIR=${Python_NumPy_INCLUDE_DIR} \
      -DBUILD_PYTHON_BINDINGS:BOOL=ON \
      ${SRC_DIR} || (cat CMakeFiles/CMakeError.log;false)

cmake --build . --target python_generated_files
cd swig/python

$PYTHON setup.py build_ext

$PYTHON -m pip install --no-deps --ignore-installed --no-build-isolation .
