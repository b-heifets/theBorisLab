#!/bin/bash
# . activate miracl
# cd <sample folder>
# vox_consensus.sh

#2x downsample sample*_consensus.tif -> nifti

SampleDir="$PWD"
consensusDir="$SampleDir"/consensus
SampleFolder=${PWD##*/} 

###add if vox does not exist 
if [ ! -f ./consensus/voxelized_seg_consensus.nii.gz ]; 
	then
if [ -f ./consensus/"$SampleFolder"_consensus.tif ];
	then 
		echo " " ; echo "Consensus exists for "$SampleFolder", running voxelization" ; echo " "
		cd "$consensusDir"
		file=$(ls sample*_consensus.tif)
		echo "$file"
		cd ..
		
		miracl_seg_voxelize_parallel.py -s "$consensusDir"/"$file" #w/ sample*_consensus.tif in sampleX/consensus

		cd consensus
		rm voxelized_seg_consensus.tif
		cd ..
        else 
		echo " " ; echo "Making consensus tif for "$SampleFolder", w/ cells detected by >= 3/5 raters"  ; echo " "
fi
	else 
		echo " " ; echo "voxelized_seg_consensus.nii.gz exists for "$SampleFolder", skipping"  ; echo " "
fi

	
	

#Daniel Ryskamp Rijsketic 9/16/21
