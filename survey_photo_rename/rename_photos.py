#### INSTRUCTIONS ####
# 1. Make directory with all photos needed to rename
# 2. Make a copy of this 'rename_photos.py' script, and put it in that directory
# 3. In the THINGS TO INPUT section below, add the appropriate info, and save the file
# 4. In your command prompt (either CMD on windows, or terminal on linux/mac), navigate to directory with photos & script
# 5. Type 'python rename_photos.py' (without the '' quotes)
# 6. Voila

######################################
########## THINGS TO INPUT ###########
######################################

# naming convention
survey_date = 'yyyymmdd' # yyyymmdd, e.g. 20181114
survey_location = 'xxxx' # 4 characters only, e.g. hero
survey_name = 'xxxx' # 4 characters only, e.g. hbom
# image/photo file extension
image_ext = ".JPG" # image file extension, e.g. .jpg, .png etc.

######################################
######################################

#####--> Don't modify from here on

#import os
import glob
import shutil

# load photo files in directory
fnames = glob.glob('*' + image_ext) # choose file extension as needed

# sort and give number
# if willing to add another python module (e.g. EXIF) could read the "Date Taken" and sort by that
# could sort by time of creation, i.e. fnames.sort(key=os.path.getctime), that could be run multiple times and not rely on original numbers
# but, replicating Picasa for the meantime, sort on file name from camera

fnames.sort(key=lambda f: int(filter(str.isdigit, f)))
# rename files, choose convention plus number
survey_concat = survey_date + '_' + survey_location + '_' + survey_name + '_'
for i, fname in enumerate(fnames):
    shutil.move(fname, "%s%04d%s" % (survey_concat, i, image_ext))