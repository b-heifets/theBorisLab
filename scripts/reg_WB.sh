#!/bin/bash
#. activate miracl
#cd <experiment folder> 
#reg_WB.sh


SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -f "$SampleDir"/gubra_ano_split_10um_clar_downsample.nii.gz ] ; then 

miracl_reg_clar-allen_whole_brain_iDISCO.sh -i niftis/"$SampleFolder"_02x_down_autofl_chan.nii.gz -o ALS -m split -v 10 -b 1

fi


#Daniel Ryskamp Rijsketic ~07/19/2021
