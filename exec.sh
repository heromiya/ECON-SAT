#export ROI=PHL
#export XMIN=113
#export YMIN=5
#export XMAX=133
#export YMAX=19

export DATA=DMSP
export DATE=199200
#export FILE=F182013.v4c.stable_lights.avg_lights_x_pct.tif
export EPSG4326="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
export EPSG3857="+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs "

for ARG in `cat ROI.lst | grep KOR`; do
    export ROI=`echo $ARG | cut -f 1 -d '|'`
    export XMIN=`echo $ARG | cut -f 2 -d '|'`
    export YMIN=`echo $ARG | cut -f 3 -d '|'`
    export XMAX=`echo $ARG | cut -f 4 -d '|'`
    export YMAX=`echo $ARG | cut -f 5 -d '|'`
    export LATMIN=`echo $XMIN $YMIN | cs2cs -f "%.10lf" $EPSG3857 +to $EPSG4326 | awk '{print $2}'`
    export LATMAX=`echo $XMAX $YMAX | cs2cs -f "%.10lf" $EPSG3857 +to $EPSG4326 | awk '{print $2}'`
    export LONMIN=`echo $XMIN $YMIN | cs2cs -f "%.10lf" $EPSG3857 +to $EPSG4326 | awk '{print $1}'`
    export LONMAX=`echo $XMAX $YMAX | cs2cs -f "%.10lf" $EPSG3857 +to $EPSG4326 | awk '{print $1}'`
    for FILE in `ls ngdc.noaa.gov | grep -e \.tif$ | grep -v -e web.stable_lights.avg_vis. | grep vcmslcfg.avg_rade9.tif`; do
	export FILE
	make tab/${ROI}_${XMIN}_${YMIN}_${XMAX}_${YMAX}.$FILE.sqlite
	#maps/${ROI}_${XMIN}_${YMIN}_${XMAX}_${YMAX}.$FILE.png
    done 

#    for PRODUCT in .stable_lights.avg_lights_x_pct; do 
#	export PRODUCT
#	make pdf/${ROI}_${XMIN}_${YMIN}_${XMAX}_${YMAX}${PRODUCT}.pdf
#   done
#	make pdf/${ROI}_${XMIN}_${YMIN}_${XMAX}_${YMAX}.SVDNB_npp.vcmslcfg.avg_rade9.pdf

	make tab/${ROI}_${XMIN}_${YMIN}_${XMAX}_${YMAX}.SVDNB_npp_vcmslcfg.avg_rade9.sqlite

done


exit 0
