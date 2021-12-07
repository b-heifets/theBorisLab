#!/bin/bash

#first run tstat1_cluster.sh (run from GLM_stats folder) and warp_to_native.sh (run from experiment folder with sample folders)

###Required inputs:===============================================================
#reg_final/annotation_hemi_split_10um_clar_vox.tif
#638 tif series
#native_2xDS_cluster_bin_tstat*.nii.gz
###===============================================================================

#1)
#cd <EXP_sampleX>

#2)
#. activate miracl

#3)
#ABAcluster_638.sh

#Inputs for ABAseg

dir="$PWD"
ABA="$dir"/reg_final/annotation_hemi_split_10um_clar_vox.tif
echo "$ABA"

cd ochann
Raw_0000=$(find *.tif -maxdepth 0 -type f | head -n 1)
Raw="$dir"/ochann/"$Raw_0000"
cd ..
echo "$Raw"

cd reg_final
tstat1=$(ls ./*cluster_bin_tstat1_*.nii.gz)
base=`basename "$tstat1"`
cd ..
cluster="$dir"/reg_final/"$base"
echo "$cluster"

#Convert seg objects to ABA intensities and generate 75 slice substacks
/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro ABAcluster_638_native_res_tstat1 "$ABA"#"$Raw"#"$cluster"

#Daniel Ryskamp Rijsketic 8/30/2021
