maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).$(DATA).$(DATE).png: maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).$(DATA).$(DATE).map
	shp2img -m $< -o $@ 
maps/$(ROI)_$(XMIN)_$(YMIN)_$(XMAX)_$(YMAX).$(DATA).$(DATE).map: template.map
	sed 