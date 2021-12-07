#!/bin/bash

#first run ilastikseg_ds.sh from seg_ilastik_XX with IlastikSegmetation folder in seg_ilastik_XX (XX = rater initials) or open ImageJ and run conv_vox.ijm macro to convert voxelized_seg_ilastik.tif

###Required inputs:===============================================================
#reg_final/annotation_hemi_split_10um_clar_vox.tif
#seg_ilastik_XX/IlastikSegmentation_XX/seg_ilastik_ds.tif
###===============================================================================

#1)
#cd EXP_sampleX/seg_ilastik_XX

#2)
#. activate miracl

#3)
#ABA_in_seg_res.sh

#Inputs
SegDir="$PWD"
Seg="$PWD"/seg_ilastik_ds.tif
cd ../
cd reg_final
ABA="$PWD"/annotation_hemi_split_10um_clar_vox.tif

#generate ABA in seg resolution
java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABA_in_seg_res "$Seg"#"$ABA"

