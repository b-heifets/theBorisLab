#!/bin/bash
# 1) . activate miracl
# 2) cd <EXP_folder> 
# 3) nii488_exp.sh


##==========================================
XYres="3.53" #x y pixel resolution in um
Zres="3.5" # z step in um
##==========================================


#for SampleFolders in sample*; do  ### comment out to run from individual sample folders
#cd $SampleFolders  ### comment out to run from individual sample folders

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -f "$SampleDir"/niftis/"$SampleFolder"_02x_down_ochann_bkg_subtracted.nii.gz ] ; then

	echo "Converting ochann_wo_488 tif to nii.gz for "$SampleFolder""
	miracl_conv_convertTIFFtoNII.py -f "$SampleDir"/ochann_bkg_subtracted -o "$SampleFolder" -d 2 -ch ochann_bkg_subtracted -vx "$XYres" -vz "$Zres"

fi

#cd ../  ### comment out to run from individual sample folders
#done  ### comment out to run from individual sample folders


#Daniel Ryskamp Rijsketic 09/10/2021



