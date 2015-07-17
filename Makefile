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
