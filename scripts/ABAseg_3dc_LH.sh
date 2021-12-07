#!/bin/bash

#3D cell counting of seg_ilastik_ds.tif using annotation_hemi_split_10um_clar_vox.tif

#first run ilastikseg_ds.sh with IlastikSegmetation folder with in seg_ilastik_XX (XX = rater initials)

###Required inputs:===============================================================
#reg_final/annotation_hemi_split_10um_clar_vox.tif
#seg_ilastik_XX/seg_ilastik_ds.tif
###===============================================================================

#1)
#cd EXP_sampleX/seg_ilastik_XX

#2)
#. activate miracl

#3)
#ABAseg_3dc.sh

#Inputs for ABAseg
SegDir="$PWD"
Seg="$PWD"/seg_ilastik_ds.tif
cd ../
cd reg_final
ABA="$PWD"/annotation_hemi_split_10um_clar_vox.tif

#Convert seg objects to ABA intensities and generate 75 slice substacks
/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro ABAseg_75sliceSubstacks_LH "$Seg"#"$ABA"

#3D object count (cd ABAseg_stacks directory -> . activate miracl -> 3dc.sh 
#saves to sample folder and ABAseg_stacks folder

cd "$SegDir"/ABAseg_stacks_75slices_LH

find . -path "*ExcludeEdges.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_ExcludeEdges  "{}" \;

find . -path "*IncludeEdges.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_IncludeEdges  "{}" \; 

#Find 75 slice substack counting errors, split substacks with errors, rerun 3D count 
for f in *.tif_*.csv; do
        case $f in 
                *_IncludeEdges.tif_I.csv)
			error=$(awk 'FNR == 3 {print}' $f)
			if [[ $error == *"error"* ]]; then
 			 echo "ERROR" in $f
			 t=$f
			 TifWithError=${t::-6}
			 java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_75include_split "$TifWithError"
			 rm $f
			 rm "$TifWithError"
			 find . -path "*ExcludeMid.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_ExcludeEdges  "{}" \;
			 find . -path "*IncludeMid.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_IncludeEdges  "{}" \;
			fi
                        ;;
                *_ExcludeEdges.tif_E.csv)
			error=$(awk 'FNR == 3 {print}' $f)
			if [[ $error == *"error"* ]]; then
 			 echo "ERROR" in $f
			 t=$f
			 TifWithError=${t::-6}
			 java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_77exclude_split "$TifWithError"
			 rm $f
			 rm "$TifWithError"
			 find . -path "*ExcludeMid.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_ExcludeEdges  "{}" \;
			 find . -path "*IncludeMid.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_IncludeEdges  "{}" \;
			fi
                        ;;
        esac
done

#Find e27 and i25 slice substack counting errors, split substacks with errors, rerun 3D count 
for f in *.tif_*.csv; do
        case $f in 
                *_IncludeMid.tif_I.csv)
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
                *_ExcludeMid.tif_E.csv)
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

find "all.csv" | xargs cut -d, -f16,37,39,40,42,43,45 > Seg_3Dcount_75slices_LH.csv #extracts columns from all.csv 

rm all.csv
#rm *E.csv
#rm *I.csv

###Rename Seg_3Dcount.csv in ABAseg_stacks and copy to sample folder
StacksDir="$PWD"
mv Seg_3Dcount_75slices_LH.csv ../
cd ../
ParentFolder=${PWD##*/}
for f in Seg_3Dcount_75slices_LH.csv ;  do mv "$f" "$(basename "$(pwd)")"_"$f" ;  done #Append parent folder name (e.g., seg_ilastik_DR_)
mv "$ParentFolder"_Seg_3Dcount_75slices_LH.csv ../
cd ../
GrantParentDir=$(pwd)
GrandParentFolder=${PWD##*/}
for f in "$ParentFolder"_Seg_3Dcount_75slices_LH.csv ;  do mv "$f" "$(basename "$(pwd)")"_"$f" ;  done #Append grandparent folder name (e.g., KNK_sample2_)
Filename="$GrandParentFolder"_"$ParentFolder"_Seg_3Dcount_75slices_LH.csv
Filename2=$(printf '%s\n' "${Filename/seg_ilastik_}") #trim "seg_ilastik_" from filename
#Filename3=$(printf '%s\n' "${Filename2/ample}") #trim "ample" from filename)
mv "$Filename" "$Filename2"
Source=""$GrantParentDir"/"$Filename2""
cp "$Source" "$StacksDir"

#Daniel Ryskamp Rijsketic ~04/19/2021
