###Required inputs:===============================================================
#reg_final/annotation_hemi_split_10um_clar_vox.tif
#638
###===============================================================================

#1)
#cd EXP_sampleX

#2)
#. activate miracl

#3)
#ABA_638_ds_exp.sh


for SampleFolders in sample*; do  ### comment out to run from individual sample folders
cd $SampleFolders  ### comment out to run from individual sample folders

ABA_638_ds () {

#Inputs
cd reg_final
ABA="$PWD"/gubra_ano_split_10um_clar_vox.tif ### or annotation_hemi_split_10um_clar_vox.tif
echo "$ABA"

cd ../
cd *ochann #assumes only one folder with 638 in name and 638 autofl image series saved there
AutoflDir="$PWD"
detox -r "$AutoflDir"
FirstFile=$(ls | head -n 1)
Autofl="$AutoflDir"/"$FirstFile"
echo "$Autofl"

#Extracting intensity count column
cd ../

#For running scripts, replace Fiji with /usr/local/miracl/depends/Fiji.app/ImageJ-linux64 for full version
/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro ABA_638_merge_downsampled "$ABA"#"$Autofl" \;

}

SampleDir="$PWD"
SampleFolder="$(basename $SampleDir)"

if [ ! -f "$SampleDir"/"$SampleFolder"_ABA_638_downsample.tif ] ; then echo "Making ABA_638_downsample.tif for "$SampleDir"" ; ABA_638_ds ; else echo "ABA_638_downsample.tif exists for "$SampleDir", skipping"; fi

cd ../  ### comment out to run from individual sample folders
done  ### comment out to run from individual sample folders

#Daniel Ryskamp Rijsketic 08/15/2021


