#!/bin/bash

#first make *bin.nii.gz and save to sample folder and run warp_to_native.sh 

###Required inputs:===============================================================
#reg_final/gubra_ano_split_10um_clar_vox.tif
#ochann/tif series
#sample folder/*bin.nii.gz
###===============================================================================

#1)
#cd <sample dir>

#2)
#. activate miracl

#3)
#nii_to_native.sh

#Inputs for ABAseg

dir="$PWD"
ABA="$dir"/reg_final/gubra_ano_split_10um_clar_vox.tif
echo "$ABA"

cd ochann
Raw_0000=$(find *.tif -maxdepth 0 -type f | head -n 1)
Raw="$dir"/ochann/"$Raw_0000"
cd ..
echo "$Raw"

cd reg_final
bin=$(ls ./*bin.nii.gz)
base=`basename "$bin"`
cd ..
cluster="$dir"/reg_final/"$base"
echo "$cluster"

/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro 2xDSnii_to_native_res "$ABA"#"$Raw"#"$cluster" \; 

#Daniel Ryskamp Rijsketic 8/30/2021
