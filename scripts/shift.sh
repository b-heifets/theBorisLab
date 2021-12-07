#!/bin/bash 


#For help message run: shift.sh help
if [ "$1" == "help" ]; then echo " " 
    echo " shift.sh <input(s)> <# of pixels> <L or R for direction of shift> #For multiple inputs use '<inputs>*.nii.gz' or '<input1> <input2>'" ; echo " "
    echo " After alinging original and flipped volumes with nudge.sh, use shift.sh to better align them with the atlas." 
    echo " Defaults: inputs=(flip_*_gubra_space.nii.gz) pixels=4 direction=L" ; echo " "
    echo " With fslroi -1 means use full dimension, so if you need to shift left by 1, instead shift right 1 and then left by 2."
    echo " If you specify direction, also specify pixels."
    echo " Note that L and R is based on the direction in the nii.gz, so look for the L and R in fsleyes"
    echo " For a few shifts at a time run: for i in {2..6} ; do shift.sh flip_sample23_cells_gubra_space.nii.gz $i L ; done" 
    echo " Use fsleyes for checking alignment"
    echo " See script for troubleshooting" ; echo " " ; exit 0
fi

#Options:
[[ -z "$1" ]] && inputs=(flip_*_gubra_space.nii.gz) || inputs=($1) #Default option || user arg 1
[[ -z "$2" ]] && pixels=4 || pixels=($2) #Number of pixels to shift by in x 
[[ -z "$3" ]] && direction=L || direction=($3) #L or R 

echo "Inputs: "${inputs[@]}""
echo "Shifting brain(s) by "$pixels" pixels to the "$direction"."

#Shift
if [ "$direction" == "L" ]; then
        for i in "${inputs[@]}"; do fname=$(basename $i .nii.gz) ; fslroi $i "$fname"_L_"$pixels".nii.gz -"$pixels" 369 0 -1 0 -1 ; fslcpgeom $i "$fname"_L_"$pixels".nii.gz; done
    else
        for i in "${inputs[@]}"; do fname=$(basename $i .nii.gz) ; fslroi $i "$fname"_R_"$pixels".nii.gz "$pixels" 369 0 -1 0 -1 ; fslcpgeom $i "$fname"_R_"$pixels".nii.gz; done
fi


#Daniel Ryskamp Rijsketic 11/17/21
