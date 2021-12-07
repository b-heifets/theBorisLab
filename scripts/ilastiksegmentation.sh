#!/bin/bash

###Required inputs:===============================================================
#DOI_rater*.ilp #trained ilastik project
###===============================================================================

#1) cd EXP_folder

#2) . activate miracl

#3) ilastiksegmentation.sh


for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders


for i in {1..5}; do 
	if [ ! -d "$SampleFolders"/seg_ilastik_$i ] ; 
		then
	mkdir seg_ilastik_$i
	fi
done


for i in {1..5}; do 
	cd seg_ilastik_$i
	ilastiksegmentation_one_rater.sh
	cd .. 
done


cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders


#Daniel Ryskamp Rijsketic 08/15/2021

