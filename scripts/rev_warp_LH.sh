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
ort="AIR" ########### Update (AIR=LH ASR=RH for ultraII, PLS for glued hemisphere with Zeiss Lightsheet7 or ALS for brain in agarose)
hemi="LH"

#4)
#rev_warp.sh

for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders
sample=${PWD##*/} 

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

cd clar_allen_reg
clar_allen_regDir="$PWD"
cd ../ 

#Create ort2std.txt
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

#Warp vox_seg_ilastik to Allen space
mkdir consensus_seg_allen_space
for dir in seg_ilastik_*; do 
	cd "$dir"
        SegDir="$PWD"
	seg_ilastik_XX="$(basename $SegDir)"
	if [ ! -f "$SampleDir"/consensus_seg_allen_space/"$SampleFolder"_vox_"$seg_ilastik_XX"_allen_space.nii.gz ] #if does not exist, then ___, else ___
		then
			echo Warping vox_seg_ilastik to Allen space "$SampleFolders" "$dir"
			miracl_reg_warp_clar_data_to_allen.sh -r "$clar_allen_regDir" -i "$SegDir"/voxelized_seg_ilastik.nii.gz -o "$SampleDir"/"$ort" -s cFos
			mv reg_final/voxelized_seg_ilastik_cFos_channel_allen_space.nii.gz "$SampleDir"/consensus_seg_allen_space/"$SampleFolder"_vox_"$seg_ilastik_XX"_allen_space.nii.gz
			rmdir "$SegDir"/reg_final
			cd ..
		else
   			echo ""$SampleFolder"_vox_"$seg_ilastik_XX"_allen_space.nii.gz exists -> skipping"
			cd ..
	fi
done

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders



#Daniel Ryskamp Rijsketic 06/2021


