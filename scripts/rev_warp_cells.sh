#!/bin/bash
#. activate miracl
#cd <experiment folder>
#ochann_wo_488.sh
#subtracts 488 channel from cell channel to improve signal to noise ratio
#THEN performs tif->nifti conversion
#THEN reverse warps the background subtracted downsampled raw data to gubra space

#for SampleFolders in s*; do  ### comment out to run from individual sample folders
#cd $SampleFolders  ### comment out to run from individual sample folders

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -d "$SampleDir"/ochann_bkg_subtracted ] ; then 
    mkdir "$SampleDir"/ochann_bkg_subtracted
else 
    cd ochann_bkg_subtracted
    FirstFile=$(ls *.tif| head -n 1)
    cd ..
fi

if [ ! -f "$SampleDir"/ochann_bkg_subtracted/"$FirstFile" ]; then

      echo " " ; echo " Subtracting 488 channel from cell channel for "$SampleFolder"" ; echo " "
	/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro 488_background_subtraction_abc "$SampleDir"/488/"$SampleFolder"_Ch1_0000.tif#"$SampleDir"/ochann/"$SampleFolder"_Ch2_0000.tif

 else
      echo " " ; echo " Background already subtracted for "$SampleFolder"" ; echo " "
fi

##Tif to nii.gz converstion
##==========================================
XYres="3.53" #x y pixel resolution in um
Zres="3.5" # z step in um
##==========================================

if [ ! -f "$SampleDir"/niftis/"$SampleFolder"_02x_down_ochann_bkg_sub_chan.nii.gz ] ; then
	echo " Converting ochann_wo_488 tif to nii.gz for "$SampleFolder""
	miracl_conv_convertTIFFtoNII.py -f "$SampleDir"/ochann_bkg_subtracted -o "$SampleFolder" -d 2 -ch ochann_bkg_sub -vx "$XYres" -vz "$Zres"
else 
    echo " "$SampleFolder"_02x_down_cells_bkg_sub_chan.nii.gz exists, skipping "
fi

#3) update 3 letter orientation code
ort="PLS" ########### Update (AIR=LH ASR=RH for ultraII, PLS for glued hemisphere with Zeiss Lightsheet7 or ALS for brain in agarose)
hemi="LH"

#4)
#adapted from rev_warp_cells_glue_exp.sh

cd clar_allen_reg
clar_allen_regDir="$PWD"
if [ -f vox_seg_ochann_res.nii.gz ] ; then rm vox_seg_ochann_res.nii.gz ; fi
if [ -f vox_seg_ochann_swp.nii.gz ] ; then rm vox_seg_ochann_swp.nii.gz ; fi
if [ -f reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan_ort.nii.gz ] ; then rm reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan_ort.nii.gz ; fi
if [ -f reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan_ort_cp_org.nii.gz ] ; then rm reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan_ort_cp_org.nii.gz ; fi
if [ -f clar_allen_comb_def.nii.gz ] ; then rm clar_allen_comb_def.nii.gz ; fi
if [ -f clar_res_org_seg.nii.gz ] ; then rm clar_res_org_seg.nii.gz ; fi
cd ../ 

if [ ! -f "$SampleDir"/ort2std.txt ] #if ort2std.txt does not exist, then ___, else ___
then
	touch ort2std.txt
	echo " Creating ort2std.txt with "$ort" for "$hemi"" 
	echo "tifdir="$SampleDir"/"$SampleFolder"" >> ort2std.txt 
	echo "ortcode="$ort"" >> ort2std.txt
else
   	echo " ort2std.txt exists -> skipping"
fi

if [ ! -f "$SampleFolder"_ochann_bkg_sub_gubra_space.nii.gz ] ; then
    echo " " ; echo " Warping "$SampleFolder"_02x_down_ochann_bkg_sub_chan.nii.gz to Gubra space" ; echo " "

vox_empty () {
    cd 488
    Dir488="$PWD"
    FirstFile=$(ls | head -n 1)
    Input="$Dir488"/"$FirstFile"
    cd ..
    /usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro seg_empty "$Input"
    miracl_seg_voxelize_parallel.py -s "$SampleDir"/seg_empty.tif
    rm voxelized_seg_empty.tif
    rm seg_empty.tif
}

if [ ! -f "$SampleDir"/niftis/reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan.nii.gz ] ; then
    fslswapdim "$SampleDir"/niftis/"$SampleFolder"_02x_down_ochann_bkg_sub_chan.nii.gz z x y "$SampleDir"/niftis/reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan.nii.gz
    [[ ! -z $(find $PWD -name "voxelized_seg_*.nii.gz") ]] && echo " Using this for fslcpgeom:" $(find $PWD -name "voxelized_seg_*.nii.gz") || vox_empty
    [[ ! -z $(find $PWD -name "voxelized_seg_*.nii.gz") ]] && fslcpgeom $(find $PWD -name "voxelized_seg_*.nii.gz" | tail -n 1) "$SampleDir"/niftis/reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan.nii.gz || fslcpgeom"$SampleDir"/voxelized_seg_empty.nii.gz "$SampleDir"/niftis/reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan.nii.gz
fi

    miracl_reg_warp_clar_data_to_gubra.sh -r "$SampleDir"/clar_allen_reg -i "$SampleDir"/niftis/reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan.nii.gz -o "$SampleDir"/ort2std.txt -s ochann

    mv reg_final/reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan_ochann_channel_allen_space.nii.gz "$SampleDir"/"$SampleFolder"_ochann_bkg_sub_gubra_space.nii.gz

    rm "$SampleDir"/niftis/reo_"$SampleFolder"_02x_down_ochann_bkg_sub_chan.nii.gz
else 
    echo " " ; echo " "$SampleFolder"_02x_down_ochann_bkg_sub_chan.nii.gz exists, skipping" ; echo " "
fi

#cd ../  ### comment out to run from individual sample folders
#done  ### comment out to run from individual sample folders
 

#Daniel Ryskamp Rijsketic 09/2021 & 12/3/21


# 11/17/21 Austen Casey
