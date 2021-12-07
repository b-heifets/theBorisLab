#!/bin/bash

###Required inputs:===============================================================
#clar_allen_reg
#seg_ilastik_XX/voxelized_seg_ilastik.nii.gz
###===============================================================================

#1)
#cd EXP_sampleX

#2)
#. activate miracl

#3) update 3 letter orientation code
ort="PLS" ########### Update (AIR=LH ASR=RH for ultraII, PLS for glued hemisphere with Zeiss Lightsheet7 or ALS for brain in agarose)
hemi="LH"

#4)
#rev_warp.sh

#for SampleFolders in sample*; do  ### comment out to run from individual sample folders
#cd $SampleFolders  ### comment out to run from individual sample folders

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"
mkdir seg_allen_space

cd clar_allen_reg
clar_allen_regDir="$PWD"
if [ -f clar_res_org_seg.nii.gz ] ; then rm clar_res_org_seg.nii.gz ; fi
if [ -f voxelized_seg_consensus_ort.nii.gz ] ; then rm voxelized_seg_consensus_ort.nii.gz ; fi
if [ -f vox_seg_cFos_res.nii.gz ] ; then rm vox_seg_cFos_res.nii.gz ; fi
if [ -f vox_seg_cFos_swp.nii.gz ] ; then rm vox_seg_cFos_swp.nii.gz ; fi
if [ -f warp_clar_allen_script.log ] ; then rm warp_clar_allen_script.log ; fi
cd ../ 

if [ ! -f "$SampleDir"/ort2std.txt ] #if ort2std.txt does not exist, then ___, else ___
then
	touch ort2std.txt
	echo "Creating ort2std.txt with "$ort" for "$hemi"" 
	echo "tifdir="$SampleDir"/"$SampleFolder"" >> ort2std.txt 
	echo "ortcode="$ort"" >> ort2std.txt
else
   	echo "ort2std.txt exists -> skipping"
fi

ort=ort2std.txt

for dir in seg_ilastik_*; do 
	cd "$dir"
        SegDir="$PWD"
	echo Warping vox_seg_ilastik to Gubra space "$SampleFolders" "$dir"
	miracl_reg_warp_clar_data_to_gubra.sh -r "$clar_allen_regDir" -i "$SegDir"/voxelized_seg_ilastik.nii.gz -o "$SampleDir"/"$ort" -s cFos
	seg_ilastik_XX="$(basename $SegDir)"
	mv reg_final/voxelized_seg_ilastik_cFos_channel_allen_space.nii.gz "$SampleDir"/seg_allen_space/"$SampleFolder"_vox_"$seg_ilastik_XX"_gubra_space.nii.gz
	rmdir "$SegDir"/reg_final
	cd ../
done

#cd ../  ### comment out to run from individual sample folders
#done  ### comment out to run from individual sample folders

#Daniel Ryskamp Rijsketic 06/2021


