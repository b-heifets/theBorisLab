#!/bin/bash

#Generates seg_ilastik.tif from ilastik segmentation output, which is used for voxelization

###Required inputs:===============================================================
#seg_ilastik_XX/IlastikSegmentation_XX folder with Ilastik output
###===============================================================================

#1)
#cd EXP_sampleX/seg_ilastik_XX

#2)
#. activate miracl

#3)
#seg_ilastik_raters.sh

#for SampleFolders in s*; do  ### comment out to run from individual sample folders
#cd $SampleFolders  ### comment out to run from individual sample folders

#Vox seg_ilastik.tif if does not exist
for dir in seg_ilastik_*; do 
 cd "$dir"
 if [ -f seg_ilastik.tif ]; then
     		cd ../
 	else
		seg_ilastik.sh
     		cd ../
 fi
done

#cd ../  ### comment out to run from individual sample folders
#done  ### comment out to run from individual sample folders

#Daniel Ryskamp Rijsketic 03/2021

