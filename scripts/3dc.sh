#!/bin/bash

#3D object count (cd ABAseg_stacks directory -> . activate miracl -> 3Doc.sh 
#saves to sample folder and ABAseg_stacks folder

#1)
#cd EXP_sampleX/seg_ilastik_XX

#2)
#. activate miracl

#3)
#3dc.sh

find . -path "*ExcludeEdges.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_ExcludeEdges  "{}" \;

find . -path "*IncludeEdges.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABAseg_3D_count_IncludeEdges  "{}" \; 

cat *csv > all.csv

find "all.csv" | xargs cut -d, -f11,12,13,14,15,16 > Seg_3Dcount.csv

rm all.csv
#rm *E.csv
#rm *I.csv

###Rename Seg_3Dcount.csv in ABAseg_stacks and copy to sample folder
StacksDir="$PWD"
mv Seg_3Dcount.csv ../
cd ../
ParentFolder=${PWD##*/}
for f in Seg_3Dcount.csv ;  do mv "$f" "$(basename "$(pwd)")"_"$f" ;  done #Append parent folder name (e.g., seg_ilastik_DR_)
mv "$ParentFolder"_Seg_3Dcount.csv ../
cd ../
GrantParentDir=$(pwd)
GrandParentFolder=${PWD##*/}
for f in "$ParentFolder"_Seg_3Dcount.csv ;  do mv "$f" "$(basename "$(pwd)")"_"$f" ;  done #Append grandparent folder name (e.g., KNK_sample2_)
Filename="$GrandParentFolder"_"$ParentFolder"_Seg_3Dcount.csv
Filename2=$(printf '%s\n' "${Filename/seg_ilastik_}") #trim "seg_ilastik_" from filename
Filename3=$(printf '%s\n' "${Filename2/ample}") #trim "ample" from filename)
mv "$Filename" "$Filename3"
Source=""$GrantParentDir"/"$Filename3""
cp "$Source" "$StacksDir"

#Daniel Ryskamp Rijsketic 03/2021

