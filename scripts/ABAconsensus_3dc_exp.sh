#!/bin/bash

#For region based cell counts
#3D cell counting of sampleX_consensus.tif using annotation_hemi_split_10um_clar_vox.tif (warped ABA)

#first run ilastik.sh and consensus.sh

###Required inputs:===============================================================
#reg_final/gubra_ano_split_10um_clar_vox.tif
#consensus/sampleX_consensus.tif
###===============================================================================

#1)
#cd EXP_sampleX

#2)
#. activate miracl

#3)
#ABAconsensus_3dc.sh


for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ -d "$SampleDir"/consensus ] ; then
if [ ! -f "$SampleDir"/"$SampleFolder"_consensus_3Dcount_25slices.csv ] ; then 

		echo "Running 3D cell counting for "$SampleDir""	
		ABAconsensus_3dc.sh
	else
		echo ""$SampleFolder"_consensus_3Dcount_25slices.csv exists, skipping"

fi
fi 

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders
	
	

#Daniel Ryskamp Rijsketic 9/28/21
