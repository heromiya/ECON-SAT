#export ROI=PHL
#export XMIN=113
#export YMIN=5
#export XMAX=133
#export YMAX=19

export DATA=DMSP
export DATE=199200
#export FILE=F182013.v4c.stable_lights.avg_lights_x_pct.tif

for ARG in `cat ROI.lst`; do
	export ROI=`echo $ARG | cut -f 1 -d '|'`
	export XMIN=`echo $ARG | cut -f 2 -d '|'`
	export YMIN=`echo $ARG | cut -f 3 -d '|'`
	export XMAX=`echo $ARG | cut -f 4 -d '|'`
	export YMAX=`echo $ARG | cut -f 5 -d '|'`
    for FILE in `ls ngdc.noaa.gov | grep -e \.tif$ | grep -v -e web.stable_lights.avg_vis.`; do
	export FILE
	make maps/${ROI}_${XMIN}_${YMIN}_${XMAX}_${YMAX}.$FILE.png
    done 
# _web.stable_lights.avg_vis
    for PRODUCT in .stable_lights.avg_lights_x_pct; do 
	export PRODUCT
	make pdf/${ROI}_${XMIN}_${YMIN}_${XMAX}_${YMAX}${PRODUCT}.pdf
    done
	make pdf/${ROI}_${XMIN}_${YMIN}_${XMAX}_${YMAX}.SVDNB_npp.vcmslcfg.avg_rade9.pdf


done

exit 0
