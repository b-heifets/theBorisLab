#!/bin/bash
#. activate miracl
#cd <experiment folder>
#reg_exp_LH.sh

for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -f "$SampleDir"/reg_final/gubra_ano_split_10um_clar_downsample.nii.gz ] ; then 

miracl_reg_clar-allen_whole_brain_iDISCO.sh -i niftis/"$SampleFolder"_02x_down_autofl_chan.nii.gz -o PLS -m split -s lh -v 10 -b 0

fi

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders


#Daniel Ryskamp Rijsketic ~07/19/2021
