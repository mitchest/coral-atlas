#########################################################
#########################################################
#####
##### August 2019
##### MOVED TO:
##### https://github.com/CoralMapping/coral-atlas-classes
#####
#########################################################
#########################################################


# library(foreign)
# library(dplyr)
# library(rgdal)
# 
# source("dbf_renaming_functions.R")
# 
# 
# ### USEAGE ###
# 
# # 1. rename_classes_dbf() cleans and renames classes and optionally adds class numbers and writes it back to disk
# 
# # 2. merge_shapefiles() joins cleaned shapefiles (2 or more) together into one output
# #    - You can pass in direct paths, or you could also pass in calls to rename_classes_dbf() with write_dbf = FALSE,
# #      that way the original shapefiles would remain untouched
# 
# 
# 
# # merge Carins-Cook and Cap-Bunker shapefiles -----------------------------
# 
# # ## GEOMORPHIC
# # rename_classes_dbf(path = "B:/0_scratchProcessing/gbr_mapping/gbr_training/20181023_GBR_CBG_geomorphic_ML.dbf",
# #                    add_class_numbers = T, write_dbf = T, classes_to_ignore = "exposed Reef Flat")
# # rename_classes_dbf(path = "B:/0_scratchProcessing/gbr_mapping/gbr_training/20171023_GBR_CCMR_geomorphic.dbf",
# #                    add_class_numbers = T, write_dbf = T)
# # 
# # merge_shapefiles(shp_paths = list("B:/0_scratchProcessing/gbr_mapping/gbr_training/20181023_GBR_CBG_geomorphic_ML.shp",
# #                                   "B:/0_scratchProcessing/gbr_mapping/gbr_training/20171023_GBR_CCMR_geomorphic.shp"),
# #                  new_shp_path = "B:/0_scratchProcessing/gbr_mapping/gbr_training/gbr_cc_cbg_geomorphic.shp")
# 
# ## BENTHIC
# 
# 
# 
# # Carins Cook -----------------------------------------------------
# 
# ## GEOMORPHIC
# # rename_classes_dbf(path = "../../GBR/gee_training/cairns_cook_geomorphic/20171023_GBR_CCMR_geomorphic.dbf",
# #                    class_column = "class_na_1",
# #                    add_class_numbers = T, geo_or_benthic = "geo", write_dbf = T)
# # 
# # ## BENTHIC
# # rename_classes_dbf(path = "../../GBR/gee_training/cairns_cook_benthic/20171023_GBR_CCMR_Benthic.dbf",
# #                    add_class_numbers = T, geo_or_benthic = "benthic", write_dbf = T)
# 
# 
# 
# # Fiji --------------------------------------------------------------------
# 
# ## GEOMORPHIC
# rename_classes_dbf(path = "../../fiji/fiji_kubulau_kadavu_geo_diss2.dbf",
#                    class_column = "GC_geo",
#                    add_class_numbers = T, geo_or_benthic = "geo", write_dbf = T)
# 
# ## BENTHIC
# rename_classes_dbf(path = "../../fiji/fiji_kubulau_kadavu_benthic_diss2.dbf",
#                    class_column = "GC_benthic",
#                    add_class_numbers = T, geo_or_benthic = "benthic", write_dbf = T)