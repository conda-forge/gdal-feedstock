call "%RECIPE_DIR%\set_bld_opts.bat"

SET CL=%CL% /std:c++17

nmake /f makefile.vc %BLD_OPTS%
if errorlevel 1 exit 1

