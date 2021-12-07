#!/bin/bash
#. activate miracl
#cd experiment folder
#vox_exp.sh

#2x downsample seg_ilastik.tif -> nifti

for SampleFolders in s*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

#Vox seg_ilastik.tif if does not exist
for dir in seg_ilastik_*; do 
 cd "$dir"
 SegDir="$PWD"
 if [ -f voxelized_seg_ilastik*.nii.gz ]; then
     cd ../
 else
       if [ -f seg_ilastik.tif ]; then
             echo Voxelizing "$SampleFolders" "$dir"
             miracl_seg_voxelize_parallel.py -s "$SegDir"/seg_ilastik.tif #w/ seg_ilastik.tif in seg_ilastik_X
             rm voxelized_seg_ilastik.tif
             cd ../
       else
             cd ../
       fi
 fi
done

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders
