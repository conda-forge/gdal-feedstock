from osgeo import gdal
from osgeo import ogr
from osgeo import osr

# this module does some tests
import tests

# Set GDAL_DATA. This is done normally done by the activate script,
# but this doesn't happen in the testing environment
import os
if 'LIBRARY_PREFIX' in os.environ:
    # Windows
    gdalData = os.path.join(os.environ['LIBRARY_PREFIX'], 'share', 'gdal')
else:
    # Linux/OSX
    gdalData = os.path.join(os.environ['PREFIX'], 'share', 'gdal')

os.environ['GDAL_DATA'] = gdalData

driver = gdal.GetDriverByName("netCDF")
assert driver is not None

driver = gdal.GetDriverByName("HDF4")
assert driver is not None

driver = gdal.GetDriverByName("HDF5")
assert driver is not None

driver = gdal.GetDriverByName("GTiff")
assert driver is not None

driver = gdal.GetDriverByName("PNG")
assert driver is not None

driver = gdal.GetDriverByName("JPEG")
assert driver is not None

# only available when libkea successfully linked in
driver = gdal.GetDriverByName("KEA")
assert driver is not None

# only available when xerces-c++ successfully linked in
driver = ogr.GetDriverByName("GML")
assert driver is not None

# only available when openjpeg successfully linked in 
driver = gdal.GetDriverByName("JP2OpenJPEG")
assert driver is not None

# only available when curl successfully linked in 
driver = gdal.GetDriverByName("WCS")
assert driver is not None

def has_geos():
    pnt1 = ogr.CreateGeometryFromWkt( 'POINT(10 20)' )
    pnt2 = ogr.CreateGeometryFromWkt( 'POINT(30 20)' )
    ogrex = ogr.GetUseExceptions()
    ogr.DontUseExceptions()
    hasgeos = pnt1.Union( pnt2 ) is not None
    if ogrex:
        ogr.UseExceptions()
    return hasgeos

assert has_geos(), 'GEOS not available within GDAL'

def has_proj():
    sr1 = osr.SpatialReference()
    sr1.ImportFromEPSG(4326) # lat long
    sr2 = osr.SpatialReference()
    sr2.ImportFromEPSG(28355) # GDA94 / MGA zone 55
    osrex = osr.GetUseExceptions()
    osr.UseExceptions()
    hasproj = True
    # use exceptions to determine if we have proj and epsg files
    # otherwise we can't reliably determine if it has failed
    try:
        trans = osr.CoordinateTransformation(sr1, sr2)
    except RuntimeError:
        hasproj = False
    return hasproj

assert has_proj(), 'PROJ not available within GDAL'
