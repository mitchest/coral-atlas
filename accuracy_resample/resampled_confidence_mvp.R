library(ggplot2)
library(foreign)
library(ranger)
library(dplyr)
library(tidyr)
library(purrr)

source("resampled_accuracy_functions.R")


# load and prep data ------------------------------------------------------

# the input shapefile should be point or polygons that represent a class (so should have a class name column)
# the other columns of the attributes should be predictor values for those points/polys (i.e. image data values, other predictors like depth slope in this case)
# the names of these predictors are hard coded into the modelling code in resampled_accuracy_functions.R

## HERON
heron_benthic <- read_dbf(path = "mvp_shapefiles/mvp_heron_confidence_benthic.dbf", simplify_classes = T)
heron_geomorphic <- read_dbf("mvp_shapefiles/mvp_heron_confidence_geomorphic.dbf", simplify_classes = T)

## LIGHTHOUSE
lighthouse_benthic <- read_dbf(path = "mvp_shapefiles/mvp_lighthouse_confidence_benthic.dbf", simplify_classes = T)
lighthouse_geomorphic <- read_dbf("mvp_shapefiles/mvp_lighthouse_confidence_geomorphic.dbf", simplify_classes = T)

## MOOREA
moorea_benthic <- read_dbf(path = "mvp_shapefiles/mvp_moorea_confidence_benthic.dbf", simplify_classes = T)
moorea_geomorphic <- read_dbf("mvp_shapefiles/mvp_moorea_confidence_geomorphic.dbf", simplify_classes = T)

## KARIMUNJAWA
kari_benthic <- read_dbf(path = "mvp_shapefiles/mvp_karimunjawa_confidence_benthic.dbf", simplify_classes = T)
kari_geomorphic <- read_dbf(path = "mvp_shapefiles/mvp_karimunjawa_confidence_geomorphic.dbf", simplify_classes = T)

## HAWAI'I
hawaii_benthic <- read_dbf(path = "mvp_shapefiles/mvp_hawaii_confidence_benthic.dbf", simplify_classes = T)
hawaii_geomorphic <- read_dbf(path = "mvp_shapefiles/mvp_hawaii_confidence_geomorphic.dbf", simplify_classes = T)



# confidence map resampling -----------------------------------------------

## HERON
heron_geomorphic <- calculate_confidence_level(classes_to_ignore = c("DeepWater-Nodata", "Cloud-Shade", "Land"),
                                               segments = heron_geomorphic, 
                                               nboot = 300, fraction = 0.368, method = "mode",
                                               write_output_to_dbf = T)
#geomorphic_confidence_stats <- get_confidence_stats(heron_geomorphic)

# benthic
heron_benthic <- calculate_confidence_level(classes_to_ignore = c("DeepWater-Nodata", "Cloud-Shade", "Land"),
                                            segments = heron_benthic, 
                                            nboot = 300, fraction = 0.368, method = "mode",
                                            write_output_to_dbf = T)
#benthic_confidence_stats <- get_confidence_stats(benthic_segments)

## LIGHTHOUSE
lighthouse_geomorphic <- calculate_confidence_level(classes_to_ignore = c("DeepWater-Nodata", "Cloud-Shade", "Land"),
                                               segments = lighthouse_geomorphic, 
                                               nboot = 300, fraction = 0.368, method = "mode",
                                               write_output_to_dbf = T)
lighthouse_benthic <- calculate_confidence_level(classes_to_ignore = c("DeepWater-Nodata", "Cloud-Shade", "Land"),
                                               segments = lighthouse_benthic, 
                                               nboot = 300, fraction = 0.368, method = "mode",
                                               write_output_to_dbf = T)

## MOOREA
moorea_geomorphic <- calculate_confidence_level(classes_to_ignore = c("DeepWater-Nodata", "Cloud-Shade", "Land","B Breaking Waves RC"),
                                                    segments = moorea_geomorphic, 
                                                    nboot = 300, fraction = 0.368, method = "mode",
                                                    write_output_to_dbf = T)
moorea_benthic <- calculate_confidence_level(classes_to_ignore = c("DeepWater-Nodata", "Cloud-Shade", "Land","B Breaking Waves RC"),
                                                 segments = moorea_benthic, 
                                                 nboot = 300, fraction = 0.368, method = "mode",
                                                 write_output_to_dbf = T)

## KARIMUNJAWA
kari_geomorphic <- calculate_confidence_level(classes_to_ignore = c("DeepWater-Nodata", "Cloud-Shade", "Land","B Breaking Waves RC"),
                                                segments = kari_geomorphic, 
                                                nboot = 300, fraction = 0.368, method = "mode",
                                                write_output_to_dbf = T)
kari_benthic <- calculate_confidence_level(classes_to_ignore = c("DeepWater-Nodata", "Cloud-Shade", "Land","B Breaking Waves RC"),
                                             segments = kari_benthic, 
                                             nboot = 300, fraction = 0.368, method = "mode",
                                             write_output_to_dbf = T)


## HAWAI'I
hawaii_geomorphic <- calculate_confidence_level(classes_to_ignore = c("DeepWater-Nodata", "Cloud-Shade", "Land"),
                                              segments = hawaii_geomorphic, 
                                              nboot = 300, fraction = 0.368, method = "mode",
                                              write_output_to_dbf = T)
hawaii_benthic <- calculate_confidence_level(classes_to_ignore = c("DeepWater-Nodata", "Cloud-Shade", "Land", "B Breaking Waves E10", "B Breaking Waves ORF", "B Breaking Waves RC"),
                                           segments = hawaii_benthic, 
                                           nboot = 300, fraction = 0.368, method = "mode",
                                           write_output_to_dbf = T)



