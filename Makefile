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

tab/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).SVDNB_npp_vcmslcfg.avg_rade9.sqlite: tab/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).SVDNB_npp_*_vcmslcfg.avg_rade9.tif.txt
	$(foreach f,$+,echo "CREATE TABLE tbl_$(subst _vcmslcfg.avg_rade9.tif.txt,,$(subst tab/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).SVDNB_npp_,,$(f))) (cat integer, uid integer, id_0 integer, iso varchar(3), name_0 varchar(255), id_1 integer, name_1 varchar(255), varname_1 varchar(255), nl_name_1 varchar(255), hasc_1 varchar(255), ccn_1 varchar(255), cca_1 varchar(255), type_1 varchar(255), engtype_1 varchar(255), validfr_1 varchar(255),validto_1 varchar(255), remarks_1 varchar(255), id_2 integer, name_2 varchar(255), varname_2 varchar(255), nl_name_2 varchar(255), hasc_2 varchar(255), ccn_2 varchar(255), cca_2 varchar(255), type_2 varchar(255), engtype_2 varchar(255), validfr_2 varchar(255), validto_2 varchar(255), remarks_2 varchar(255), id_3 integer, name_3 varchar(255), varname_3 varchar(255), nl_name_3 varchar(255), hasc_3 varchar(255), ccn_3 varchar(255), cca_3 varchar(255), type_3 varchar(255), engtype_3 varchar(255), validfr_3 varchar(255), validto_3 varchar(255), remarks_3 varchar(255), id_4 integer, name_4 varchar(255), varname_4 varchar(255), ccn_4 varchar(255), cca_4 varchar(255), type_4 varchar(255), engtype_4 varchar(255), validfr_4 varchar(255), validto_4 varchar(255), remarks_4 varchar(255), id_5 integer, name_5 varchar(255), ccn_5 varchar(255), cca_5 varchar(255), type_5 varchar(255), engtype_5 varchar(255), region varchar(255), varregion varchar(255), unam varchar(255), zone varchar(255), shape_length double precision, shape_area double precision, rast_n double precision, rast_min double precision, rast_max double precision, rast_range double precision, rast_mean double precision, rast_stddev double precision, rast_variance double precision, rast_cf_var double precision, rast_sum double precision, rast_first_quartile double precision, rast_median double precision, rast_third_quartile double precision, rast_percentile_90 double precision); .separator |; .import $(f) tbl_$(subst _vcmslcfg.avg_rade9.tif.txt,,$(subst tab/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).SVDNB_npp_,,$(f)))" | sqlite3 $@;)
