pdf/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX)$(PRODUCT).pdf: maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX)*$(PRODUCT).tif.png
	mkdir -p `dirname $@`
	convert $+ $@
pdf/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).SVDNB_npp.vcmslcfg.avg_rade9.pdf: maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).SVDNB_npp_*_vcmslcfg.avg_rade9.tif.png 
	mkdir -p `dirname $@`
	convert $+ $@


maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).$(FILE).png: template.map
	mkdir -p `dirname $@`
	shp2img -m $< -o tmp.map.png -e $(XMIN) $(YMIN) $(XMAX) $(YMAX) -l "$(FILE) Admin"
	convert -pointsize 16 -gravity north -font fonts/OpenSans-Regular.ttf -annotate 0 "$(FILE)" -fill white tmp.map.png $@

#maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).$(DATA).$(DATE).map
#maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).$(DATA).$(DATE).map: template.map

template.map: gen.template.map.sh 
	bash $< > $@

tab/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).$(FILE).sqlite:
	mkdir -p `dirname $@`
	v.in.ogr -o dsn=GIS_Data_Archive/src/gadm.org/gadm27.sqlite output=gadm_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX) layer=gadm spatial=$(LONMIN),$(LATMIN),$(LONMAX),$(LATMAX) --overwrite
	g.region vect=gadm_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX) res=`gdalinfo ngdc.noaa.gov/$(FILE) | grep "Pixel Size" | sed 's/.*(\([.0-9]*\).*/\1/'`
	rm -rf tmp.vrt && gdal_translate -of VRT -projwin $(LONMIN) $(LATMAX) $(LONMAX) $(LATMIN) ngdc.noaa.gov/$(FILE) tmp.vrt
	r.in.gdal -o input=tmp.vrt output=rast_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX) --overwrite
	v.rast.stats -ce vector=gadm_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX) raster=rast_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX) colprefix=rast
	v.out.ogr -c input=gadm_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX) dsn=$@ type=area format=SQLite
#	v.db.select gadm_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX) > $@

tab/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).SVDNB_npp_vcmslcfg.avg_rade9.sqlite: tab/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).SVDNB_npp_*_vcmslcfg.avg_rade9.tif.sqlite
	$(foreach f,$+,ogr2ogr -f SQLite -append -update $@ $(f) -nln tbl_$(subst _vcmslcfg.avg_rade9.tif.sqlite,,$(subst tab/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).SVDNB_npp_,,$(f))) `ogrinfo $(f) |  awk '/1:/{print $$2}'`;)

