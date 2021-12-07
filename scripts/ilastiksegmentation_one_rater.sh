#!/bin/bash

###Required inputs:===============================================================
#DOI_rater*.ilp #trained ilastik project
###===============================================================================

#1) cd seg_ilastik_X

#2) . activate miracl

#3) ilastiksegmentation_one_rater.sh

seg_ilastik_X_Dir="$PWD"
rater=${seg_ilastik_X_Dir: -1}
echo " Running Ilastik for rater "$rater""

cd ..

SampleDir="$PWD"
SampleFolder=${PWD##*/}

cd .. ### comment out if running all samples
ExpDir="$PWD"

ilp=$(echo *.ilp | awk -F'_' '{print $1}')

if [ ! -d "$seg_ilastik_X_Dir"/ilastiksegmentation ] ; 
	then

		run_ilastik.sh --headless --project="$ExpDir"/"$ilp"_rater"$rater".ilp --export_source="Simple Segmentation" --output_format=tif --output_filename_format="$SampleDir"/seg_ilastik_"$rater"/ilastiksegmentation/{nickname}.tif "$SampleDir"/ochann/"$SampleFolder"_Ch2_*.tif
	else
		echo "ilastiksegmentation exists for "$SampleFolder", skipping "
fi

#Daniel Ryskamp Rijsketic 08/15/2021

