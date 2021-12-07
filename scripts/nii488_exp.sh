#!/bin/bash
# 1) . activate miracl
# 2) cd <EXP_folder> 
# 3) nii488_exp.sh


##==========================================
XYres="3.53" #x y pixel resolution in um
Zres="3.5" # z step in um
##==========================================


for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

SampleDir="$PWD"

if [ ! -f "$SampleDir"/niftis/"$SampleFolders"_488Thr_02x_down_autofl_chan.nii.gz ] ; then

	echo "Converting 488 tif to nii.gz for "$SampleFolders""
	miracl_conv_convertTIFFtoNII.py -f "$SampleDir"/488 -o "$SampleFolders"_488Thr -d 2 -ch autofl -vx "$XYres" -vz "$Zres"

fi

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders


#Daniel Ryskamp Rijsketic 09/10/2021



