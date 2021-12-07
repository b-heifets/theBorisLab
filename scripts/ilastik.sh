#!/bin/bash

#This script creates the ilastik-based active cell segmentation

###Required inputs:===============================================================
#./ilastik_projects/EXP_rater*.ilp #trained ilastik project in experiment folder
#EXP/sampleX/ochann/638_tif_series
###===============================================================================

#1) cd <seg_ilastik_X>

#2) . activate miracl

#3) ilastik.sh

SegDir="$PWD"
rater=${SegDir: -1}

cd ..

SampleDir="$PWD"
SampleFolder=${PWD##*/}

ProjectDir=/home/bear/Documents/ilastik_projects

cd "$ProjectDir"
EXP=$(echo *.ilp | awk -F'_' '{print $1}')

if [ -f "$ProjectDir"/"$EXP"_rater"$rater".ilp ] ; then

if [ ! -d "$SegDir"/IlastikSegmentation ] ; #If processing stopped midway, delete IlastikSegmentation to restart or comment out if/then/else/fi to resume
	then
	    echo "Running Ilastik for "$EXP" "$SampleFolder" rater "$rater""
	    run_ilastik.sh --headless --project="$ProjectDir"/"$EXP"_rater"$rater".ilp --export_source="Simple Segmentation" --output_format=tif --output_filename_format="$SampleDir"/seg_ilastik_"$rater"/IlastikSegmentation/{nickname}.tif "$SampleDir"/ochann/"$SampleFolder"_Ch2_*.tif
	else
	    echo "IlastikSegmentation exists for "$SampleFolder", skipping "
fi
fi



#seg_ilastik.sh #To minimize disc usage, add seg_ilastik.sh to a script that creates the consensus, voxelizes it and deletes the seg_ilastik.tif files for each rater

#Daniel Ryskamp Rijsketic 08/15/2021

