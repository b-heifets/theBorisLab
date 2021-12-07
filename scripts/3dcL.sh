#!/bin/bash

#FIJI 3D cell counting!

#run from sample folder

Dir="$PWD"

cd "$Dir"
#===============================================================
ABA_488_ds.sh 
#===============================================================
#Merges ABA with 2x ds 488 images (warped annotation_hemi_split_10um_clar_vox.tif in reg_final = "ABA")
#Required inputs:
#reg_final/annotation_hemi_split_10um_clar_vox.tif
#488
#Output: /SSD4/DBSexp/sample1a/reg_final/sampleX_ABA_488_downsample.tif

cd "$Dir"
#===============================================================
ABA_histo.sh
#===============================================================
#Required inputs:
#reg_final/ABA_488_downsample.tif
#Outputs: 
#./sampleX/sampleX_ABA_histogram_total.csv
#./sampleX/reg_final/ABA_histogram_of_pixel_intensity_counts/sampleX_ABA_histogram_total.csv
#

cd "$Dir"
#===============================================================
ABA_histo_in_tissue_DR.sh #first determine threshold for 488 mask with ABA_488mask_merge.ijm (input: ABA_488_downsample.tif from ABA_488_ds.sh) and adjust in ABA_within_tissue.ijm ##########################################################################
#===============================================================
#Required inputs:
#reg_final/ABA_488_downsample.tif
#reg_final/ABA_in_tissue.tif
#./sampleX/sampleX_ABA_histogram_in_tissue_total.csv
#./sampleX/reg_final/ABA_histogram_of_pixel_intensity_counts_in_tissue/sampleX_ABA_histogram_in_tissue_total.csv


#cd EXP_sampleX/seg_ilastikX
#===============================================================
###ilastikseg_ds.sh 
#===============================================================
#Convert ilastik output into seg_ilastik_ds.tif (2x downsampled segmentation) 
#seg_ilastik_ds.tif is similar to voxelized_seg_ilastik.tif except bilinear downsampling method in FIJI preserves more detected cells
#requires: seg_ilastik_XX/IlastikSegmentation_XX folder with Ilastik output where XX = rater initials
#OR if seg_ilastik.tif already exists run: 
#cd EXP_sampleX/seg_ilastik_XX ; seg_ilastik_ds.sh #to convert seg_ilastik.tif to seg_ilastik_ds.tif

#cd EXP_sampleX/seg_ilastikX
#3D cell counting of seg_ilastik_ds.tif using annotation_hemi_split_10um_clar_vox.tif
#===============================================================
for dir in seg_ilastik_*; do cd "$dir" ; ABAseg_3dc_LH.sh ; done
#===============================================================
#Required inputs:
#reg_final/annotation_hemi_split_10um_clar_vox.tif
#seg_ilastik_XX/seg_ilastik_ds.tif #5 raters per experiment
#Outputs:
#./sampleX/EXP_sampleX_1_Seg_3Dcount_75slices.csv #1 is from seg_ilastik_1
#Output: ./sampleX/seg_ilastik_X/ABAseg_stacks_75slices/EXP_sampleX_1_Seg_3Dcount_75slices.csv


#Optional:

#===============================================================
###ABA_in_seg_res.sh
#===============================================================
#converts warped ABA to 2x downsamped resoluion (from native) and saves in reg_final
#can merge with warped ABA for quick assesment of registration accuracy involving FIJI macro 
#Required inputs:
#reg_final/annotation_hemi_split_10um_clar_vox.tif
#seg_ilastik_XX/IlastikSegmentation_XX/seg_ilastik_ds.tif
#Note: update xyz resolution in ABA_in_seg_res.ijm as needed
#Output: ParentFolderSeg+"_ABA_SegRes.tif

#===============================================================
###ABA_seg_merge.sh
#===============================================================
#To quickly check ABA set 
#Required inputs:
#reg_final/annotation_hemi_split_10um_clar_vox.tif
#seg_ilastik_XX/IlastikSegmentation_XX/SegmentationOutput
#occasionally ITK ok but not FIJI and 3D slicer needed to fix: use Slicer to match 488 ds 2x with warped ABA -> resample ABA with nearest neighbor -> used as input of ABAseg_3dc_corrected.sh
#ABAseg_3dc_for_corrected_ABA.sh



