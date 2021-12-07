#!/bin/bash 

if [ "$1" == "help" ]; then echo " " 
    echo " ave.sh <optional: input(s)>" 
    echo " The default input is *nii.gz" 
    echo " For multiple inputs use '<inputs>*.nii.gz' or '<input1> <input2>'" ; echo " "
    echo " Run from folder with *.nii.gz"
    echo " Outputs averaged volume"
    echo " " ; exit 0
fi

[[ -z "$1" ]] && inputs=(*.nii.gz) || inputs=($1) #Default option || user arg 1

echo "Inputs: "${inputs[@]}""
echo "Averaging brains"

fsladd ave.nii.gz -m *.nii.gz


#Daniel Ryskamp Rijsketic & Austen Casey 11/23/21







 

