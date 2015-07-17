cat <<EOF
MAP 
  CONFIG "PROJ_LIB" "/usr/share/proj/" 
  FONTSET "fonts.txt" 
  IMAGECOLOR 170 255 255
  IMAGETYPE "png"
  NAME "Nighttime Light"
  SIZE 800 640
  STATUS ON
  UNITS METERS

  IMAGEQUALITY 95
  IMAGETYPE agg
  OUTPUTFORMAT
    NAME agg
    DRIVER AGG/PNG
    IMAGEMODE RGB
  END

  PROJECTION "init=epsg:3857" END
  LEGEND
    KEYSIZE 20 10
    KEYSPACING 5 5
    LABEL
      SIZE MEDIUM
      OFFSET 0 0
      SHADOWSIZE 1 1
      TYPE BITMAP
    END # LABEL
    STATUS OFF
  END # LEGEND

  SCALEBAR
    INTERVALS 5
    SIZE 450 16
    STATUS embed
    UNITS kilometers
    LABEL
      FONT sans
      TYPE truetype
        ENCODING "UTF-8"
      SIZE 12
      COLOR 0 0 0
      ANTIALIAS true
      PARTIALS false
     END 
  END # SCALEBAR
EOF

for FILE in `ls /mnt/gum-lvm/GIS_Data_Archive/GTiff/ngdc.noaa.gov/F* | grep \.tif`; do
    cat <<EOF
  LAYER
      NAME "`basename $FILE`"
      TYPE RASTER
      PROJECTION "init=epsg:4326" END
      STATUS ON
      DATA "$FILE"
      PROCESSING "SCALE=AUTO"
  END
EOF
done

for FILE in `ls /mnt/gum-lvm/GIS_Data_Archive/GTiff/ngdc.noaa.gov/SVDNB_npp_* | grep \.tif`; do
    cat <<EOF
  LAYER
      NAME "`basename $FILE`"
      TYPE RASTER
      PROJECTION "init=epsg:4326" END
      STATUS ON
      DATA "$FILE"
      PROCESSING "SCALE=-1,10"
      PROCESSING "SCALE_BUCKETS=10"  END
EOF
done

cat <<EOF
  LAYER
	NAME "Admin"
	TYPE POLYGON
	PROJECTION "init=epsg:4326" END
	STATUS ON
	CONNECTIONTYPE OGR
        CONNECTION "/vsizip/GIS_Data_Archive/src/mappinghacks.com/world_borders.zip"
        DATA "world_borders"
#	CONNECTION "/mnt/gum-lvm/GIS_Data_Archive/SQLite/naturalearthdata.com/natural_earth_vector.sqlite"
#	DATA "ne_10m_admin_0_countries"
	CLASS
		STYLE
			WIDTH 0.5
			OUTLINECOLOR 255 255 0
		END
	END
  END
END # MAP
EOF
