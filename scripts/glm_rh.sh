#!/bin/bash 

#add sample*_gubra_space.nii.gz files for 2 groups to a folder
#rename as <group1_>sample*_gubra_space.nii.gz and <group2_>sample*_gubra_space.nii.gz

#. activate miracl 
#cd <GLM folder dir> 
#glm_rh.sh 

#input: ./<condition1/2-prefix>_sample*_gubra_space.nii.gz 
#main output: in GLM_stats folder *_tfce_corrp_tstat1.nii.gz = corrected p values where group 1 activity > group 2
#main output: in GLM_stats folder *_tfce_corrp_tstat2.nii.gz = corrected p values where group 1 activity < group 2
#main output: in GLM_stats folder *_tstat1.nii.gz = t-statistics where group 1 activity > group 2
#main output: in GLM_stats folder *_tstat2.nii.gz = t-statistics where group 1 activity < group 2

group1=$(find *.nii.gz -maxdepth 0 -type f | head -n 1 | cut -d _ -f 1) #get prefix for group1
group2=$(find *.nii.gz -maxdepth 0 -type f | tail -n 1 | cut -d _ -f 1) #get prefix for group2
group1_N=$(ls -1q "$group1"_* | wc -l) #get N for group1
echo "$group1" "$group1_N"
group2_N=$(ls -1q "$group2"_* | wc -l) #get N for group2
echo "$group2" "$group2_N"

GLMFolderName=${PWD##*/} 
mkdir "$GLMFolderName"_thr0.1

#Make mask for voxel inclusion in the analysis (i.e., voxels with activity in bin_template)
for file in  *_gubra_space.nii.gz ; do
echo "Removing noise from "$file""
fslmaths $file -thr 0.1 "$GLMFolderName"_thr0.1/$file
done

cd "$GLMFolderName"_thr0.1

echo "Generating empty sum_gubra_space.nii.gz for summing activity maps"
file1=$(find *.nii.gz -maxdepth 0 -type f | head -n 1)
fslmaths "$file1" -sub "$file1" sum_gubra_space.nii.gz 

for file in *_sample*_gubra_space.nii.gz ; do
echo "Adding $file to sum_gubra_space.nii.gz"
fslmaths $file -add sum_gubra_space.nii.gz sum_gubra_space.nii.gz
done
echo "sum_gubra_space.nii.gz complete"

mkdir GLM_stats/ ; cp /usr/local/miracl/atlases/ara/gubra/gubra_template_wo_OB_25um_full_bin_right.nii.gz ./GLM_stats/ ; cp /usr/local/miracl/atlases/ara/gubra/gubra_ano_split_25um_uthr40000.nii.gz ./GLM_stats/

mv ./sum_gubra_space.nii.gz ./GLM_stats/

cd GLM_stats

fslmaths sum_gubra_space.nii.gz -bin bin_sum_gubra_space.nii.gz

fslmaths bin_sum_gubra_space.nii.gz -s 0.05 -thr 0.45 -bin s_thr_bin_sum_gubra_space.nii.gz

fslmaths s_thr_bin_sum_gubra_space.nii.gz -add gubra_template_wo_OB_25um_full_bin_right.nii.gz sum_activity_template_mask.nii.gz

fslmaths sum_activity_template_mask.nii.gz -thr 2 thr2_sum_activity_template_mask.nii.gz

fslmaths thr2_sum_activity_template_mask.nii.gz -bin GLM_mask_RH.nii.gz

cd ..


#GLM-based voxel-wise t-tests 

if [ ! -f ./GLM_stats/all_norm.nii.gz ] ; then fslmerge -t GLM_stats/all_norm.nii.gz *.nii.gz ; fi

cd GLM_stats

design_ttest2 design "$group1_N" "$group2_N" #N for group 1 and 2 (ABC order for prefix)

if [ ! -f all_norm_s50.nii.gz ] ; then fslmaths all_norm.nii.gz -s 0.05 all_norm_s50.nii.gz ; fi

randomise_parallel -i all_norm_s50.nii.gz -m GLM_mask_RH.nii.gz -o "$GLMFolderName"_"$group1"-"$group1_N"_"$group2"-"$group2_N" -d design.mat -t design.con -T -n 5000

 
#Daniel Ryskamp Rijsketic & Austen Casey 9/21/21
