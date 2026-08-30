$ErrorActionPreference = "Stop"

$expectedMachine = 0xAA64
$paths = @(
    (Join-Path $env:LIBRARY_BIN "gdal.dll"),
    (Join-Path $env:LIBRARY_BIN "gdalinfo.exe"),
    (Join-Path $env:LIBRARY_BIN "gdal_translate.exe"),
    (Join-Path $env:LIBRARY_BIN "gdalwarp.exe")
)

foreach ($path in $paths) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Missing Windows ARM64 artifact: $path"
    }

    $stream = [System.IO.File]::OpenRead($path)
    $reader = [System.IO.BinaryReader]::new($stream)
    try {
        if ($stream.Length -lt 64 -or $reader.ReadUInt16() -ne 0x5A4D) {
            throw "Invalid DOS header in $path"
        }

        $stream.Position = 0x3C
        $peOffset = $reader.ReadUInt32()
        if ($peOffset + 6 -gt $stream.Length) {
            throw "Invalid PE header offset in $path"
        }

        $stream.Position = $peOffset
        if ($reader.ReadUInt32() -ne 0x00004550) {
            throw "Invalid PE signature in $path"
        }

        $machine = $reader.ReadUInt16()
        if ($machine -ne $expectedMachine) {
            throw ("Expected AA64 machine 0x{0:X4}, got 0x{1:X4} in {2}" -f $expectedMachine, $machine, $path)
        }

        Write-Host ("Verified AA64 PE machine for {0}" -f $path)
    }
    finally {
        $reader.Dispose()
    }
}
