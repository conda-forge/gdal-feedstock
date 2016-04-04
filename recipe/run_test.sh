#!/bin/sh

# From @mhearne-usgs. See https://github.com/conda-forge/gdal-feedstock/issues/23#issue-144997326
echo "1 2 3 4" > grid.asc
echo "5 6 7 8" >> grid.asc
echo "9 10 11 12" >> grid.asc
echo "13 14 15 16" >> grid.asc

echo "ncols 4" > grid.hdr
echo "nrows 4" >> grid.hdr
echo "xllcenter -70.0" >> grid.hdr
echo "yllcenter -19.0" >> grid.hdr
echo "cellsize 5" >> grid.hdr
echo "odata_value -9999" >> grid.hdr

proj4="+y_0=2400761.714982585 +lat_ts=-19.6097 +a=6378137.0 +proj=merc +units=m +b=6356752.3142 +lat_0=-19.6097 +x_0=-0.0 +lon_0=-70.7691"

gdalwarp -s_srs "+proj=latlong" -t_srs "$proj4" -of EHdr grid.asc grid.flt
