#!/bin/bash 


#For help message run: nudge.sh help
if [ "$1" == "help" ]; then echo " " 
    echo " nudge.sh <input(s)> <# of pixels> <L or R for direction of shift> #For multiple inputs use '<inputs>*.nii.gz' or '<input1> <input2>'" ; echo " "
    echo " nudge.sh is for shifting nii.gz content left or right by x pixels. First run flip.sh" 
    echo " Defaults: inputs=(flip_*_gubra_space.nii.gz) pixels=4 direction=L" ; echo " "
    echo " With fslroi -1 means use full dimension, so if you need to shift left by 1, instead shift right 1 and then left by 2."
    echo " If you specify direction, also specify pixels."
    echo " Note that L and R is based on the direction in the nii.gz, so look for the L and R in fsleyes"
    echo " For a few shifts at a time run: for i in {3..5} ; do nudge.sh flip_sample23_cells_gubra_space.nii.gz <dollar sign>i L ; done" 
    echo " Use fsleyes for checking alignment"
    echo " See script for troubleshooting" ; echo " " ; exit 0
fi

#Options:
[[ -z "$1" ]] && inputs=(flip_*_gubra_space.nii.gz) || inputs=($1) #Default option || user arg 1
[[ -z "$2" ]] && pixels=4 || pixels=($2) #Number of pixels to shift by in x 
[[ -z "$3" ]] && direction=L || direction=($3) #L or R 

echo "Inputs: "${inputs[@]}""
echo "Shifting brain(s) by "$pixels" pixels to the "$direction"."

#Nudge
if [ "$direction" == "L" ]; then
        for i in "${inputs[@]}"; do fslroi $i L_"$pixels"_$i -"$pixels" 369 0 -1 0 -1 ; fslcpgeom $i L_"$pixels"_$i; done
    else
        for i in "${inputs[@]}"; do fslroi $i R_"$pixels"_$i "$pixels" 369 0 -1 0 -1 ; fslcpgeom $i R_"$pixels"_$i; done
fi

#Dan Barbosa's approach: for file in reo* ; do fslswapdim $file -x y z flip_$file ; fslcpgeom $file flip_$file ; fslroi flip_$file flip_$file -4 369 0 -1 0 -1 ; fslcpgeom $file flip_$file ; fslcpgeom $file flip_$file ; done"


#Daniel Ryskamp Rijsketic 11/17/21
