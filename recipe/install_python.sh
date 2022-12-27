#!/bin/bash

pushd swig/python

$PYTHON -m pip install --no-deps --ignore-installed . \
        --global-option build_ext \
        --global-option "-I$INCLUDE_PATH" \
        --global-option "-L$LIBRARY_PATH"

popd
