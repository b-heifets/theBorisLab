#!/bin/bash

###Required inputs:===============================================================
#reg_final/*ABA_488_downsample.tif
#reg_final/ABA_in_tissue.tif
###===============================================================================

#1)
#cd EXP_sampleX

#2)
#. activate miracl

#3)
#ABA_histo_in_tissue_DR.sh


#4) copy data from to excel template to convert intensity pixel counts to volumes based on xyz dimensions and to get cell densities


for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

histo_in_tissue_function () {

#Inputs
cd reg_final
mkdir ABA_histogram_of_pixel_intensity_counts_in_tissue
ABA488="$PWD"/*ABA_488_downsample.tif #rename without EXP_sampleX if needed 
ABAtissue="$PWD"/ABA_in_tissue.tif
echo $ABA488
echo "$ABAtissue"

#Extracting intensity count column
java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABA_within_tissue_DR $ABA488 \;
java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABA_histogram_for_region_volumes_in_tissue "$ABAtissue" \;

#Sum ABA histograms of all slices
#Extract 4th column containing counts for each pixel intensity (rows 0 - 65534 = corresponding intensity for 16-bit images)
cd ABA_histogram_of_pixel_intensity_counts_in_tissue
find -name "ABA_histogram_in_tissue.csv" -type f -print0 | xargs  cut -d, -f4 > temp.csv 

#remove CSV header
sed -i '1d' temp.csv

#split CSV into multiple CSVs (1 per slice)
split -l 65535 -d -a 4 --additional-suffix=.csv temp.csv ABA_histogram_in_tissue_slice_ 
rm temp.csv 

#concatenate csv columns into one CSV
rm ABA_histogram_in_tissue.csv ; paste *.csv  | awk '{ print $0; }' > ABA_histogram_in_tissue_stack.csv

#sum columns into one CSV
perl -anle '$x+=$_ for(@F);print $x;$x=0;' ABA_histogram_in_tissue_stack.csv >  ABA_histogram_in_tissue_total.csv

rm ABA_histogram_in_tissue_slice_*.csv
rm ABA_histogram_in_tissue_stack.csv # comment out to have csv with pixel intensity counts for each slice

#To run in terminal after running FIJI macro, cd to folder with CSV and run:
#find -name "ABA_histogram_in_tissue.csv" -type f -print0 | xargs  cut -d, -f4 > temp.csv ; sed -i '1d' temp.csv ; split -l 65535 -d -a 4 --additional-suffix=.csv temp.csv ABA_histogram_in_tissue_slice_ ; rm temp.csv ; rm ABA_histogram_in_tissue.csv ; paste *.csv  | awk '{ print $0; }' > ABA_histogram_in_tissue_stack.csv ; perl -anle '$x+=$_ for(@F);print $x;$x=0;' ABA_histogram_in_tissue_stack.csv >  ABA_histogram_in_tissue_total.csv ; rm ABA_histogram_in_tissue_slice_*.csv


###Rename ABA_histogram_in_tissue_total.csv in /ABA_histogram_of_pixel_intensity_counts_in_tissue and copy to sample folder
StacksDir="$PWD"
mv ABA_histogram_in_tissue_total.csv ../
cd ../
ParentFolder=${PWD##*/}
for f in ABA_histogram_in_tissue_total.csv ;  do mv "$f" "$(basename "$(pwd)")"_"$f" ;  done #Append parent folder name (e.g., reg_final)
mv "$ParentFolder"_ABA_histogram_in_tissue_total.csv ../
cd ../
GrantParentDir=$(pwd)
GrandParentFolder=${PWD##*/}
for f in "$ParentFolder"_ABA_histogram_in_tissue_total.csv ;  do mv "$f" "$(basename "$(pwd)")"_"$f" ;  done #Append grandparent folder name (e.g., KNK_sample2_)
Filename="$GrandParentFolder"_"$ParentFolder"_ABA_histogram_in_tissue_total.csv
Filename2=$(printf '%s\n' "${Filename/reg_final_}") #trim "reg_final_" from filename
#Filename3=$(printf '%s\n' "${Filename2/ample}") #trim "ample" from filename)
mv "$Filename" "$Filename2"
Source=""$GrantParentDir"/"$Filename2""
cp "$Source" "$StacksDir"

}

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -f "$SampleDir"/"$SampleFolder"_ABA_histogram_in_tissue_total.csv ] ; then echo "Getting region volumes in tissue for "$SampleDir"" ; histo_in_tissue_function ; else echo "Region volumes in tissue exist for "$SampleDir", skipping"; fi

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders

#Daniel Ryskamp Rijsketic 08/15/2021

