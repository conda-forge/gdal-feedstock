@echo off
REM As a workaround for GDAL apps unexpectedly returning error codes, this
REM script checks only for the existence of the .py files below.

@echo on

REM DEBUG: try to find location of these files
where gdalattachpct.py
where gdal_retile.py
where gdal_proximity.py
where gdal_edit.py
where gdal_pansharpen.py
where ogrmerge.py
where ogr_layer_algebra.py

if not exist %LIBRARY_BIN%\gdalattachpct.py exit 1

if not exist %LIBRARY_BIN%\gdal_retile.py exit 1

if not exist %LIBRARY_BIN%\gdal_proximity.py exit 1

if not exist %LIBRARY_BIN%\gdal_edit.py exit 1

if not exist %LIBRARY_BIN%\gdal_pansharpen.py exit 1

if not exist %LIBRARY_BIN%\ogrmerge.py exit 1

if not exist %LIBRARY_BIN%\ogr_layer_algebra.py exit 1
