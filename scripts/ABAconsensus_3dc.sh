#!/bin/bash

#For region based cell counts
#3D cell counting of sampleX_consensus.tif using annotation_hemi_split_10um_clar_vox.tif (warped ABA)

#first run ilastik.sh and consensus.sh

###Required inputs:===============================================================
#reg_final/gubra_ano_split_10um_clar_vox.tif
#consensus/sampleX_consensus.tif
###===============================================================================

#1)
#cd EXP_sampleX

#2)
#. activate miracl

#3)
#ABAconsensus_3dc.sh

#Inputs for ABAseg
SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"
SegDir="$PWD"/consensus
Seg="$SegDir"/"$SampleFolder"_consensus.tif
cd reg_final
ABA="$PWD"/gubra_ano_split_10um_clar_vox.tif

#Convert seg objects to ABA intensities and generate 25 slice substacks using full verion of FIJI
/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro ABAconsensus_25sliceSubstacks "$Seg"#"$ABA" 

#3D object count
cd "$SegDir"/ABAconsensus_stacks_25slices

find . -path "*ExcludeEdges.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_ExcludeEdges  "{}" \; #lite version of FIJI

find . -path "*IncludeEdges.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_IncludeEdges  "{}" \; 


#Find e27 and i25 slice substack counting errors, split substacks with errors, rerun 3D count 
for f in *.tif_*.csv; do
        case $f in 
                *_IncludeEdges.tif_I.csv)
			error=$(awk 'FNR == 3 {print}' $f)
			if [[ $error == *"error"* ]]; then
 			 echo "ERROR" in $f
			 t=$f
			 TifWithError=${t::-6}
			 java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_25include_split "$TifWithError"
			 rm $f
			 rm "$TifWithError"
			 find . -path "*ExcludeSmall.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_ExcludeEdges  "{}" \;
			 find . -path "*IncludeSmall.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_IncludeEdges  "{}" \;
			fi
                        ;;
                *_ExcludeEdges.tif_E.csv)
			error=$(awk 'FNR == 3 {print}' $f)
			if [[ $error == *"error"* ]]; then
 			 echo "ERROR" in $f
			 t=$f
			 TifWithError=${t::-6}
			 java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_27exclude_split "$TifWithError"
			 rm $f
			 rm "$TifWithError"
			 find . -path "*ExcludeSmall.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_ExcludeEdges  "{}" \;
			 find . -path "*IncludeSmall.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_IncludeEdges  "{}" \;
			fi
                        ;;
        esac
done


#concatenate csvs

cat *csv > all.csv

find "all.csv" | xargs cut -d, -f16,37,39,40,42,43,45 > consensus_3Dcount_25slices.csv #extracts columns from all.csv 

rm all.csv
#rm *E.csv
#rm *I.csv

###Copy CSV output to sample folder and rename
cp consensus_3Dcount_25slices.csv "$SampleDir"/"$SampleFolder"_consensus_3Dcount_25slices.csv



#Daniel Ryskamp Rijsketic 09/27/2021
