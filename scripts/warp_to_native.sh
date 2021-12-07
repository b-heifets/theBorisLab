#!/bin/bash

###Required inputs:===============================================================
#run registration first
###===============================================================================

#Outputs in reg_final (same name as input file)

#For help message run: flip.sh help
if [ "$1" == "help" ]; then echo " "
    echo " warp_to_native.sh <input(s)>  #For multiple inputs use 'inputs*.nii.gz' or 'input1 input2'" ; echo " " 
    echo " First copy file to warp into sample folder (must be in atlas space)"
    echo " Run this script to warp nii.gz in sample folder to native space "
    echo " Overlay with raw data to check validity and anatomical localization of activity"
    echo " Default input: *bin.nii.gz" ; echo "" ; exit 0
fi

#Options:
[[ -z "$1" ]] && inputs=(*bin.nii.gz) || inputs=($1) #Default option || user arg 1

#for SampleFolders in sample*; do  ### comment out to run from individual sample folders 
#cd $SampleFolders  ### comment out to run from individual sample folders 

SampleDir="$PWD"
SampleFolder=${PWD##*/}



regdir=$PWD/clar_allen_reg
regdirfinal=$PWD/reg_final



# Function to check if file exists then runs other command
function ifdsntexistrun() 
{  

	local outfile="$1"; 
	local outstr="$2"; 
	local fun="${@:3}";  

	if [[ ! -f ${outfile} ]]; then

		printf "\n $outstr \n"; 
		echo "$fun"; 
		eval "${fun}";

	else  
		
		printf "\n $outfile already exists ... skipping \n"; 

	fi ; 

}

# Tforms
antswarp="$regdir"/allen_clar_ants1Warp.nii.gz
antsaff="$regdir"/allen_clar_ants0GenericAffine.mat

# Out lbls
wrplbls="$regdirfinal"/annotation_hemi_split_10um_clar_downsample.nii.gz
smclarres="$regdirfinal"/clar_downsample_res10um.nii.gz

#additional variables for warpallenlbls function
initform="$regdir"/init_tform.mat


for i in "${inputs[@]}"; do 

    echo " "
    echo "inputs: $i"
    echo " "

    fname=$(basename $i .nii.gz)

    #Output:
    wrpout="$regdirfinal"/native_2xDS_"$fname".nii.gz

    # Warp from ABA to native space:
    ifdsntexistrun "$wrpout" "Applying ants deformation to Allen labels" antsApplyTransforms -d 3 -r "$smclarres" -i $i -n NearestNeighbor -t "$antswarp" "$antsaff" "$initform" -o "$wrpout" --float

done


#cd ../  ### comment out to run from individual sample folders
#done  ### comment out to run from individual sample folders


### example of warp to native command
#antsApplyTransforms -d 3 -r /SSD4/DOI_NE/DOI_NE_RH_tdT/sample1/reg_final/clar_downsample_res10um.nii.gz -i /SSD4/DOI_NE/DOI_NE_RH_tdT/sample1/sample1_consensus_vox_allen_space.nii.gz -n NearestNeighbor -t /SSD4/DOI_NE/DOI_NE_RH_tdT/sample1/clar_allen_reg/allen_clar_ants1Warp.nii.gz /SSD4/DOI_NE/DOI_NE_RH_tdT/sample1/clar_allen_reg/allen_clar_ants0GenericAffine.mat /SSD4/DOI_NE/DOI_NE_RH_tdT/sample1/clar_allen_reg/init_tform.mat -o /SSD4/DOI_NE/DOI_NE_RH_tdT/sample1/reg_final/sample1_consensus_vox_native_space.nii.gz --float



#miracl_reg_clar-allen_whole_brain.sh modified by Daniel Ryskamp Rijsketic 08/26/2021


