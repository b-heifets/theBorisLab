#!/bin/bash

#create binary mask of top hot/cold spot clusters (this script), warp to native space for each sample (warp_tstat1.sh), then you can either: 
#1) get cell densities within clusters and assign to ABA regions, CSV outputs -> Grecia -> ADX 
#2) overlay raw data with cluster mask to check validity and anatomical localization of activity 

###Required inputs:===============================================================
#run registration first
###===============================================================================

#1)
#cd <GLM_stats_folder>

#2)
#. activate miracl




#3) set percentile for thresholding tstat1 (clusters where group1 has more activity than group2)
###===============================================================================
tstat_percentile=99
###===============================================================================




#4)
#tstat1_cluster.sh



#Outputs in reg_final (same name as input file)



tstat1=$(ls ./*_tstat1.nii.gz| tail -1) #input clarity nii
base=`basename "$tstat1"`


if [[ ! -f "$outfile" ]]; 
	then
		echo "Creating clusters for "$base""
		fslmaths "$base" -thr 0 tstat1_thr0.nii.gz
		thr=$(fslstats tstat1_thr0.nii.gz -P "$tstat_percentile")
		echo "Threshold for "$tstat_percentile"th percentile is "$thr""
		Output=cluster_bin_tstat1_percentile"$tstat_percentile"_thr${thr%?}.nii.gz
		fslmaths "$base" -thr "$thr" -bin "$Output"
		cluster -i "$base" -t ${thr%?} -o cluster_index_tstat1_percentile"$tstat_percentile"_thr${thr%?} --osize=cluster_size_tstat1_percentile"$tstat_percentile"_thr${thr%?} > cluster_info_tstat1_percentile"$tstat_percentile"_thr${thr%?}.txt
		echo ""$Output" complete" 
	else	
		echo ""$Output" already exists ... skipping" 
fi


#Daniel Ryskamp Rijsketic 08/28/2021





