#!/bin/bash

###Required inputs:===============================================================
#clar_allen_reg
#consensus/"$SampleFolder"_consensus_gubra_space.nii.gz
###===============================================================================

#1)
#cd <sample folder>

#2)
#. activate miracl

#3) update 3 letter orientation code
ort="ALS" ########### Update (AIR=LH ASR=RH for ultraII, PLS for glued hemisphere with Zeiss Lightsheet7 or ALS for brain in agarose)


#4)
#rev_warp_consensus_glue.sh


#for SampleFolders in sample*; do  ### comment out to run from individual sample folders
#cd $SampleFolders  ### comment out to run from individual sample folders


SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -f "$SampleFolder"_consensus_gubra_space.nii.gz ] ; then

cd clar_allen_reg
clar_allen_regDir="$PWD"
if [ -f clar_res_org_seg.nii.gz ] ; then rm clar_res_org_seg.nii.gz ; fi
if [ -f voxelized_seg_consensus_ort.nii.gz ] ; then rm voxelized_seg_consensus_ort.nii.gz ; fi
if [ -f vox_seg_cFos_res.nii.gz ] ; then rm vox_seg_cFos_res.nii.gz ; fi
if [ -f vox_seg_cFos_swp.nii.gz ] ; then rm vox_seg_cFos_swp.nii.gz ; fi
if [ -f warp_clar_allen_script.log ] ; then rm warp_clar_allen_script.log ; fi
cd ../ 

if [ -f ort2std.txt ] ; then
rm ort2std.txt
fi
touch ort2std.txt
echo "tifdir="$SampleDir"" >> ort2std.txt 
echo "ortcode="$ort"" >> ort2std.txt

echo " " ; echo "Warping voxelized_seg_consensus for "$SampleFolders" to Gubra space" ; echo " "
miracl_reg_warp_clar_data_to_gubra.sh -r "$clar_allen_regDir" -i "$SampleDir"/consensus/voxelized_seg_consensus.nii.gz -o "$SampleDir"/ort2std.txt -s cFos
mv reg_final/voxelized_seg_consensus_cFos_channel_allen_space.nii.gz "$SampleDir"/"$SampleFolder"_consensus_gubra_space.nii.gz
fi

#cd ../  ### comment out to run from individual sample folders
#done  ### comment out to run from individual sample folders

#Daniel Ryskamp Rijsketic 08/2021


