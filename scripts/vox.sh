#!/bin/bash
#. activate miracl
#cd seg_ilastik_X folder
#vox.sh

#2x downsample seg_ilastik.tif -> nifti

SegDir="$PWD"

miracl_seg_voxelize_parallel.py -s "$SegDir"/seg_ilastik.tif #w/ seg_ilastik.tif in seg_ilastik_X

rm voxelized_seg_ilastik.tif


#Daniel Ryskamp Rijsketic 8/4/21

