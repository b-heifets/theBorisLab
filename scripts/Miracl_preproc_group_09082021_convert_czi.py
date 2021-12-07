#Group brain activity mapping analysis pipeline  (Dan Barbosa w/ macros by Dan Rijsketic, Halpern & Heifets labs) - Adapted by Dan R 09/08/21 

import os
import glob
import czifile
from PIL import Image
import sys
        
# open cmd line
# . activate miracl
# change directory to experiment folder
# python3 <script>.py
# also change variables below according to experiment (e.g., to add side)

#define parameters #these need to be changed according to experiments
xres = "3.53"
zres = "3.5"
thr488 = 'no' #yes or no 

subjects = list(glob.glob("/SSD2/Psi_NE/Psi_NE_LH_cfos/sample*")) # this will look for sample*/czi/sample*.czi).

for i in range (len(subjects)):
    dpSub = subjects[i]
    sj_lbl = dpSub[dpSub.rfind('sample'):]
    cmd_cd = "cd %s" %dpSub
    os.system(cmd_cd)
    tif_dir = "%s/tif" %dpSub
    autfldir = "%s/488" %dpSub
    czi_file = "%s/czi/%s.czi" %(dpSub,sj_lbl)
    print(czi_file)
    if not os.path.exists(tif_dir) and not os.path.exists(autfldir):
        print("ONLY CZI FILES IDENTIFIED. RUNNING CZI2TIF CONVERSION.")
        mktifdir = "mkdir %s/tif" %dpSub
        os.system(mktifdir)
        cmd_cziconv = '/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro Conv_czi_to_tif %s' %czi_file
        os.system(cmd_cziconv)
    zfiles = '%s/tif/*' %dpSub
    autofldir = "%s/488" %dpSub
    if not os.path.exists(autofldir):
        frames = list(glob.glob(zfiles))
        czi_image = czifile.imread(czi_file)
        dims = czi_image.shape
        xsize = dims[-2]
        ysize = dims[-3]
        zsize = dims[-4]
        #print(dims)
        print(xsize)
        print(ysize)
        print(zsize)
        xmax = int(xsize - 1)
        ymax = int(ysize - 1)
        if (xsize % 2) != 0 and (ysize % 2) == 0:
            print("CROPPING TO MAKE X DIM EVEN")
            for j in range (len(frames)):
                image = Image.open(frames[j])
                original_file_path = frames[j]
                cropped_image = image.crop((0,0,xmax,ysize))
                #print(original_file_path)
                cropped_image.save(original_file_path)        
        if (ysize % 2) != 0 and (xsize % 2) == 0:
            print("CROPPING TO MAKE Y DIM EVEN")
            for j in range (len(frames)):
                image = Image.open(frames[j])
                original_file_path = frames[j]
                cropped_image = image.crop((0,0,xsize,ymax))
                #print(original_file_path)
                cropped_image.save(original_file_path) 
        if (xsize % 2) != 0 and (ysize % 2) != 0:
            print("CROPPING TO MAKE X AND Y DIM EVEN")
            for j in range (len(frames)):
                image = Image.open(frames[j])
                original_file_path = frames[j]
                cropped_image = image.crop((0,0,xmax,ymax))
                #print(original_file_path)
                cropped_image.save(original_file_path) 
    #create folder for each channel and move each channel to its folder
    if not os.path.exists(autofldir):
        cmd_mkautofl = "mkdir %s/488 ; mkdir %s/ochann" %(dpSub,dpSub)
        os.system(cmd_mkautofl)
        cmd_mvautofl = "mv %s/tif/%s_Ch1_*.tif %s/488/" %(dpSub,sj_lbl,dpSub)
        os.system(cmd_mvautofl)
        if thr488 == 'yes':
            print("LET'S THRESHOLD 488 TIFS TO REMOVE BACKGROUND")
            cmd_thr488 = "/usr/local/miracl/depends/Fiji.app/ImageJ-linux64 --ij2 -macro 488_min_adjust_DOI %s/488/%s_Ch1_0000.tif" %(dpSub, sj_lbl)
            os.system(cmd_thr488)
        cmd_mvchann = "mv %s/tif/%s_Ch2_*.tif %s/ochann/" %(dpSub,sj_lbl,dpSub) 
        os.system(cmd_mvchann)
        cmd_rmtifdir = "rm -rf %s/tif" %dpSub
        os.system(cmd_rmtifdir)
    #1ST: CONVERSION FROM TIFF TO NII (~ 15 min) #May need even # of pixels in x and y for tif to nii, so select all, adjust and crop both channels if needed
    autoflnii = "%s/niftis/%s_02x_down_autofl_chan.nii.gz" %(dpSub,sj_lbl)
    if not os.path.exists(autoflnii):
        cmd_convert = "cd %s ; miracl_conv_convertTIFFtoNII.py -f %s/488 -o %s -d 2 -ch autofl -vx %s -vz %s" % (dpSub, dpSub, sj_lbl, xres, zres)
        print("LET'S CONVERT AUTOFL TO NII")
        os.system(cmd_convert)
    cellsnii = "%s/niftis/%s_02x_down_cells_chan.nii.gz" %(dpSub,sj_lbl)
    if not os.path.exists(cellsnii):
        cmd_convert2 = "cd %s ; miracl_conv_convertTIFFtoNII.py -f %s/ochann -o %s -d 2 -ch cells -vx %s -vz %s" % (dpSub, dpSub, sj_lbl, xres, zres)
        print("LET'S CONVERT CELLS TO NII")
        os.system(cmd_convert2)

