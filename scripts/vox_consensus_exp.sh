#!/bin/bash
# . activate miracl
# cd <sample folder>
# vox_consensus_exp.sh

#2x downsample sample*_consensus.tif -> nifti

for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

vox_consensus.sh

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders
	
	

#Daniel Ryskamp Rijsketic 9/16/21
