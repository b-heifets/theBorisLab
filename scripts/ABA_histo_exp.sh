#!/bin/bash

#1) open terminal from sample folder after running registration in miracl

#2)
#. activate miracl

#3)
#ABA_histo.sh

#4) copy data from to excel template to convert intensity pixel counts to volumes based on xyz dimensions and to get cell densities

#===============================================================
#Required inputs:
#reg_final/*ABA_488_downsample.tif
#===============================================================


for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

histo_function () {

cd reg_final
#Extracting intensity count column
mkdir ABA_histogram_of_pixel_intensity_counts

find . -path "*ABA_488_downsample.tif" -exec java -jar /usr/local/miracl/depends/Fiji.app/jars/ij-1.53c.jar -ijpath /usr/local/miracl/depends/Fiji.app -macro ABA_region_volumes  "{}" \;

cd ABA_histogram_of_pixel_intensity_counts


#Sum ABA histograms of all slices
#Extract 4th column containing counts for each pixel intensity (rows 0 - 65534 = corresponding intensity for 16-bit images)
find -name "ABA_histogram.csv" -type f -print0 | xargs  cut -d, -f4 > temp.csv 

#remove CSV header
sed -i '1d' temp.csv

#split CSV into multiple CSVs (1 per slice)
split -l 65535 -d -a 4 --additional-suffix=.csv temp.csv ABA_histogram_slice_ 
rm temp.csv 

#concatenate csv columns into one CSV
rm ABA_histogram.csv ; paste *.csv  | awk '{ print $0; }' > ABA_histogram_stack.csv

#sum columns into one CSV
perl -anle '$x+=$_ for(@F);print $x;$x=0;' ABA_histogram_stack.csv >  ABA_histogram_total.csv

rm ABA_histogram_slice_*.csv
rm ABA_histogram_stack.csv # comment out to have csv with pixel intensity counts for each slice

#To run in terminal after running FIJI macro, cd to folder with CSV and run:
#find -name "ABA_histogram.csv" -type f -print0 | xargs  cut -d, -f4 > temp.csv ; sed -i '1d' temp.csv ; split -l 65535 -d -a 4 --additional-suffix=.csv temp.csv ABA_histogram_slice_ ; rm temp.csv ; rm ABA_histogram.csv ; paste *.csv  | awk '{ print $0; }' > ABA_histogram_stack.csv ; perl -anle '$x+=$_ for(@F);print $x;$x=0;' ABA_histogram_stack.csv >  ABA_histogram_total.csv ; rm ABA_histogram_slice_*.csv


###Rename ABA_histogram_total.csv in /ABA_histogram_of_pixel_intensity_counts and copy to sample folder
StacksDir="$PWD"
mv ABA_histogram_total.csv ../
cd ../
ParentFolder=${PWD##*/}
for f in ABA_histogram_total.csv ;  do mv "$f" "$(basename "$(pwd)")"_"$f" ;  done #Append parent folder name (e.g., reg_final)
mv "$ParentFolder"_ABA_histogram_total.csv ../
cd ../
GrantParentDir=$(pwd)
GrandParentFolder=${PWD##*/}
for f in "$ParentFolder"_ABA_histogram_total.csv ;  do mv "$f" "$(basename "$(pwd)")"_"$f" ;  done #Append grandparent folder name (e.g., KNK_sample2_)
Filename="$GrandParentFolder"_"$ParentFolder"_ABA_histogram_total.csv
Filename2=$(printf '%s\n' "${Filename/reg_final_}") #trim "reg_final_" from filename
#Filename3=$(printf '%s\n' "${Filename2/ample}") #trim "ample" from filename)
mv "$Filename" "$Filename2"
Source=""$GrantParentDir"/"$Filename2""
cp "$Source" "$StacksDir"

}

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -f "$SampleDir"/"$SampleFolder"_ABA_histogram_total.csv ] ; then echo "Getting region volumes for "$SampleDir"" ; histo_function ; else echo "Region volumes exist for "$SampleDir", skipping"; fi

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders

#Daniel Ryskamp Rijsketic 08/15/2021

