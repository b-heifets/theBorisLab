#!/bin/bash

#Create ilastik segmentation

###Required inputs:===============================================================
#EXP_rater*.ilp #trained ilastik project in experiment folder
#EXP/sampleX/ochann/638_tif_series
###===============================================================================

#1) cd <EXP_folder>

#2) . activate miracl

#3) ilastik_exp.sh


for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

SampleDir="$PWD"

for i in {1..5}; do 
	if [ ! -d "$SampleFolders"/seg_ilastik_$i ] ; 
	  then
		mkdir seg_ilastik_$i
	fi
done


for i in {1..5}; do 
	cd seg_ilastik_$i
	ilastik.sh
	cd "$SampleDir" 
done


cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders


#Daniel Ryskamp Rijsketic 08/15/2021

