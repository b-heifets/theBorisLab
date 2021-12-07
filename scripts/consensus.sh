#!/bin/bash

#This script makes a consensus tif. If a pixel was classified as a cell by at least 3 raters using Ilastik, then preserve it as a cell
#Previous to this create ilastik segmentation for 5 raters by running ilastik.sh

###Required inputs:===============================================================
#EXP/sampleX/seg_ilastik_1/IlastikSegmentation/tif series from simple segmentation with Ilastik
#EXP/sampleX/seg_ilastik_2/IlastikSegmentation/tif series from simple segmentation with Ilastik
#EXP/sampleX/seg_ilastik_3/IlastikSegmentation/tif series from simple segmentation with Ilastik
#EXP/sampleX/seg_ilastik_4/IlastikSegmentation/tif series from simple segmentation with Ilastik
#EXP/sampleX/seg_ilastik_5/IlastikSegmentation/tif series from simple segmentation with Ilastik
###===============================================================================

# . activate miracl 
# cd <sample folder>
# consensus.sh

#main output: <EXPdir>/<SampleFolder>_consensus.tif

SampleDir="$PWD"
SampleFolder=${PWD##*/} 


cd seg_ilastik_4/IlastikSegmentation
seg4=$(ls -1 --file-type | grep -v '/$' | wc -l)  #ls number of files
cd .. ; cd ..
cd seg_ilastik_5/IlastikSegmentation
seg5=$(ls -1 --file-type | grep -v '/$' | wc -l)
cd .. ; cd ..

if [[ "$seg5" -gt 0 ]]; #if number of files in seg_ilastik_5 is greater than 0, then: 
	then 
if [[ "$seg4" == "$seg5" ]];
	then 

if [ -f ""$SampleDir"/consensus/"$SampleFolder"_consensus.tif" ];
	then 
		echo "Consensus exists for "$SampleFolder", skipping"
        else 
		echo " "
        	echo "Making consensus tif for "$SampleFolder", w/ cells detected by >= 3/5 raters" 
		echo " "
		mkdir consensus
		for i in {1..5} ; do 
			cd seg_ilastik_$i/IlastikSegmentation 
			declare IlaSeg$i="$PWD"
			declare FirstFile$i=$(ls | head -n 1) 
			cd "$SampleDir"
		done 
		/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro seg_consensus "$IlaSeg1"/"$FirstFile1"#"$IlaSeg2"/"$FirstFile2"#"$IlaSeg3"/"$FirstFile3"#"$IlaSeg4"/"$FirstFile4"#"$IlaSeg5"/"$FirstFile5" \; 
fi 

        else 
		echo " "
        	echo "seg_ilastik_5 not ready, skipping consensus for "$SampleFolder""
		echo " "
fi 
	else
		echo " "
		echo "seg_ilastik_5 not ready, skipping consensus for "$SampleFolder""
		echo " "
fi



#Daniel Ryskamp Rijsketic 9/16/21





