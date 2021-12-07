#!/bin/bash

#This script makes a consensus tif. If a pixel was classified as a cell by at least 3 raters using Ilastik, then preserve it as a cell
#Previous to this create ilastik segmentation for 5 raters by running ilastik.sh

###Required inputs:===============================================================
#EXP/sampleX/seg_ilastik_1/IlastikSegmentation/tif series from simple segmentation with Ilastik
#EXP/sampleX/seg_ilastik_2/IlastikSegmentation/tif series from simple segmentation with Ilastik
#EXP/sampleX/seg_ilastik_3/IlastikSegmentation/tif series from simple segmentation with Ilastik
#EXP/sampleX/seg_ilastik_4/IlastikSegmentation/tif series from simple segmentation with Ilastik
#EXP/sampleX/seg_ilastik_5/IlastikSegmentation/tif series from simple segmentation with Ilastik
###===============================================================================

# . activate miracl 
# cd <experiment folder>
# consensus_exp.sh

#main output: <EXPdir>/<SampleFolder>_consensus.tif

for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

consensus.sh

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders



#Daniel Ryskamp Rijsketic 9/16/21





