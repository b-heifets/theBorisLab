#!/bin/bash
#. activate miracl
#cd experiment folder
#488thr_exp.sh

#threshold bkg outside of brain and linearly adjust B&C

for SampleFolders in s*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -f 488_min ]; then
      echo "488 thresholding for "$SampleFolder""
	/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro 488_min_adjust_DOI "$SampleDir"/488/"$SampleFolder"_Ch1_0000.tif#

 else
      echo "488 already thresholded for "$SampleFolder""
fi

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders
