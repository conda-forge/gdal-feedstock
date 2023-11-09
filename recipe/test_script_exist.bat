@echo off
REM As a workaround for GDAL apps unexpectedly returning error codes, this
REM script checks only for the existence of the .py files below.
REM This file should be replaced by calls to the scripts in meta.yaml once the
REM behavior is fixed in GDAL itself.

@echo on

if not exist %PREFIX%\Scripts\gdalattachpct.py exit 1

if not exist %PREFIX%\Scripts\gdal_retile.py exit 1

if not exist %PREFIX%\Scripts\gdal_proximity.py exit 1

if not exist %PREFIX%\Scripts\gdal_edit.py exit 1

if not exist %PREFIX%\Scripts\gdal_pansharpen.py exit 1

if not exist %PREFIX%\Scripts\ogrmerge.py exit 1

if not exist %PREFIX%\Scripts\ogr_layer_algebra.py exit 1
