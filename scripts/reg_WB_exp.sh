#!/bin/bash
#. activate miracl
#cd <experiment folder> 
#reg_WB_exp.sh

for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -f "$SampleDir"/gubra_ano_split_10um_clar_downsample.nii.gz ] ; then 

miracl_reg_clar-allen_whole_brain_iDISCO.sh -i niftis/"$SampleFolder"_02x_down_autofl_chan.nii.gz -o ALS -m split -v 10 -b 1

fi

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders

#Austen Casey 10/12/2021
