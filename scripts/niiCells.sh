#!/bin/bash
# 1) . activate miracl
# 2) cd <sample_folder>
# 3) niiCells.sh


##==========================================
XYres="3.53" #x y pixel resolution in um
Zres="3.5" # z step in um
##==========================================


SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -f "$SampleDir"/niftis/"$SampleFolder"_02x_down_cells_chan.nii.gz ] ; then

	echo "Converting 488 tif to nii.gz for "$SampleFolder""
	miracl_conv_convertTIFFtoNII.py -f "$SampleDir"/ochann -o "$SampleFolder" -d 2 -ch cells -vx "$XYres" -vz "$Zres"

fi


#Daniel Ryskamp Rijsketic 09/10/2021
