#!/bin/bash

#Generates seg_ilastik.tif from ilastik segmentation output, which is used for voxelization

###Required inputs:===============================================================
#seg_ilastik_X/ilastiksegmentation folder with Ilastik output
###===============================================================================

#1)
#cd EXP_sampleX/seg_ilastik_XX

#2)
#. activate miracl

#3)
#seg_ilastik.sh

SegDir="$PWD"

IlastikSegmentation_XX=$(ls -d *lastik*egmentatio*)

IlaSeg="$SegDir"/"$IlastikSegmentation_XX"

cd "$IlaSeg"

detox -r "$IlaSeg"

FirstFile=$(ls | head -n 1)

Input="$IlaSeg"/"$FirstFile"

java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro seg_ilastik "$Input"

#Daniel Ryskamp Rijsketic 08/2021

