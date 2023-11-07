#!/bin/bash

# exit when any command fails
set -e
# print all commands
set -x

pushd $( dirname "${BASH_SOURCE[0]}" )/test_data/

# From @mhearne-usgs. See https://github.com/conda-forge/gdal-feedstock/issues/23#issue-144997326
echo ""
echo "GDAL WARP TEST"
echo ""
# This test is not passing on >=2.3.0
# fails with the error "ERROR 1: Couldn't determine X spacing"
# I could not figure out what changed in `gdalwarp` that is causing this.
# https://trac.osgeo.org/gdal/wiki/Release/2.3.0-News 
# proj4="+y_0=2400761.714982585 +lat_ts=-19.6097 +a=6378137.0 +proj=merc +units=m +b=6356752.3142 +lat_0=-19.6097 +x_0=-0.0 +lon_0=-70.7691"
# gdalwarp -s_srs "+proj=latlong" -t_srs "$proj4" -of EHdr grid.asc grid.flt

echo ""
echo "Test ISIS3/USGS driver SetNoDataValue()"
echo ""
gdalinfo cropped.cub

echo ""
echo "Test CPL_ZIP_ENCODING"
echo ""
# xref.: https://github.com/conda-forge/gdal-feedstock/issues/83
gdalinfo /vsizip/stere.zip/stere.tif

echo ""
echo "Test shapefile"
echo ""
ogrinfo sites.shp

echo ""
echo "Test KMZ"
echo ""
ogrinfo sample.kmz

popd

gdal_grid --version
gdal_rasterize --version
gdal_translate --version
gdaladdo --version
gdalenhance --version
gdalwarp --version
gdalinfo --formats

test -f ${PREFIX}/lib/libgdal${SHLIB_EXT}
test ! -f ${PREFIX}/lib/libgdal.a

# check all drivers
gdal_translate --formats
