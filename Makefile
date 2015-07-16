maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).$(DATA).$(DATE).png: template.map
	mkdir -p `dirname $@`
	shp2img -m $< -o $@ -e $(XMIN) $(YMIN) $(XMAX) $(YMAX)

#maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).$(DATA).$(DATE).map
maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).$(DATA).$(DATE).map: template.map

