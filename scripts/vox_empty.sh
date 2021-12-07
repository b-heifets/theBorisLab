#!/bin/bash
#. activate miracl
#cd seg_ilastik_X folder
#vox_empty.sh

#2x downsample seg_ilastik.tif -> nifti

Dir="$PWD"

cd 488
Dir488="$PWD"
FirstFile=$(ls | head -n 1)
Input="$Dir488"/"$FirstFile"
cd ..

/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro seg_empty "$Input"

miracl_seg_voxelize_parallel.py -s "$Dir"/seg_empty.tif

rm voxelized_seg_empty.tif
rm seg_empty.tif

#Daniel Ryskamp Rijsketic 8/4/21

