#!/bin/bash 


#For help message run: flip.sh help
if [ "$1" == "help" ]; then echo " "
    echo " flip.sh <input(s)>  #For multiple inputs use 'inputs*.nii.gz' or 'input1 input2'" ; echo " " 
    echo " Flip nii.gz input(s) in the x/horizontal dimension (for overlaying L and R sides of the brain)"
    echo " Make folder with nii.gz files and cd to this folder before running" 
    echo " Default input: *_gubra_space.nii.gz" ; echo "" ; exit 0
fi

#Options:
[[ -z "$1" ]] && inputs=(*_gubra_space.nii.gz) || inputs=($1) #Default option || user arg 1

#Flip file in x
for i in "${inputs[@]}"; do fslswapdim $i -x y z flip_$i ; done

#Apply header from original file
for i in "${inputs[@]}"; do fslcpgeom $i flip_$i ; done



#Daniel Ryskamp Rijsketic 11/17/21
