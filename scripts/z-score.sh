#!/bin/bash 

if [ "$1" == "help" ]; then echo " " 
    echo " z-score.sh <optional: enter # for fslmaths -thr for raw; omit arg for consensus>" ; echo " "
    echo " Default threshold is 0.1 (for segmented/voxelized data in atlas space)"
    echo " Determine threshold with fsleyes" 
    echo " Run from folder with *_gubra_space.nii.gz (from Run rev_warp.sh or rev_warp_cells.sh)"
    echo " Outputs z-scored volume"
    echo " z-score = (sample volume - mean pixel intensity in brain)/standard dev of intensity in brain"
    echo " " ; exit 0
fi

[[ -z "$1" ]] && thr=0.1 || thr=($1) #default option (use for segmented data || user arg 1)

#1) Threshold the original image to zero out pixels outside of the brain
mkdir z-scored

for i in *_gubra_space.nii.gz ; do fslmaths $i -thr 0.1 z-scored/$i; done
cd z-scored
touch threshold_before_z-scoring
echo "$thr" >> threshold_before_z-scoring

#2) Obtain the mean intensity for all nonzero voxels (-M) in the image and then subtract that mean intensity from the sample image
niftis=(*.nii.gz)
niftis_means=( $(for i in "${niftis[@]}"; do fslstats $i -M ; done) ) 
for i in "${!niftis[@]}"; do echo "Non-zero mean of ${niftis[i]} is ${niftis_means[i]}" ; done

N=$(ls -1q *_gubra_space.nii.gz | wc -l) ; let N_minus_1="$N"-1
for i in $(seq 0 "$N_minus_1"); do fslmaths "${niftis[$i]}" -sub $(echo "${niftis_means[$i]}") "${niftis[$i]%???????}"_mean_corrected.nii.gz ; done #Make Z score numerator

numerator=(*_mean_corrected.nii.gz)

#3) Calculate the standard deviation of the image for nonzero voxels
SD=( $(for i in "${niftis[@]}"; do fslstats $i -S ; done) ) 
for i in "${!niftis[@]}"; do echo "Non-zero SD of ${niftis[i]} is ${SD[i]}" ; done

#4) Then z-score the images
for i in $(seq 0 "$N_minus_1"); do fslmaths "${numerator[$i]}" -div "${SD[$i]}" ${niftis[$i]%???????}_z-scored.nii.gz ; done

rm *_mean_corrected.nii.gz
rm *_gubra_space.nii.gz

cd ..

echo "Boom, you z-scored the nii.gz files!"


#Daniel Ryskamp Rijsketic & Austen Casey 11/23/21







 

