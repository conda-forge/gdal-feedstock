cd build
if errorlevel 1 exit 1

rd /s /q swig\python

FOR /F "tokens=*" %%g IN ('%PYTHON% -c "import numpy; print(numpy.get_include())"') do (SET Python_NumPy_INCLUDE_DIR=%%g)

cmake %CMAKE_ARGS% "-UPython*" ^
      -DPython_EXECUTABLE="%PYTHON%" ^
      -DPython_NumPy_INCLUDE_DIR="%Python_NumPy_INCLUDE_DIR%" ^
      -DGDAL_PYTHON_INSTALL_PREFIX:PATH="%STDLIB_DIR%\.." ^
      -DBUILD_PYTHON_BINDINGS:BOOL=ON ^
      -DGDAL_USE_EXTERNAL_LIBS=OFF ^
      -DGDAL_BUILD_OPTIONAL_DRIVERS:BOOL=OFF ^
      -DOGR_BUILD_OPTIONAL_DRIVERS:BOOL=OFF ^
      "%SRC_DIR%"
if errorlevel 1 exit /b 1

cmake --build . --target python_generated_files
if errorlevel 1 exit /b 1

cd swig\python
if errorlevel 1 exit /b 1

%PYTHON% setup.py install
if errorlevel 1 exit /b 1
