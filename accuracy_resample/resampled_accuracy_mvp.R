library(ggplot2)
library(dplyr)
library(tidyr)

source("resampled_accuracy_functions.R")



# load and prep data ------------------------------------------------------

###### Could indlude the class simplification and filtering here - quicker and less error prone??

## HERON

heron_benthic_points <- read.csv("Heron_Benthic_int.csv", stringsAsFactors = F) %>%
  filter(Class_name_MAP.Simple %in% c("Coral/Algae", "Rock", "Rubble", "Sand")) %>%
  filter(FD_Dominant.Simple %in% c("Coral/Algae", "Rock", "Rubble", "Sand"))

## LIGHTHOUSE

## MOOREA

## KARIMUNJAWA

## HAWAI'I


# standard accuracy metrics -----------------------------------------------

## HERON
heron_benthic_confmat <- get_conf_mat(true_id = heron_benthic_points$Class_name_MAP.Simple,
                                      pred_class = heron_benthic_points$FD_Dominant.Simple)
heron_benthic_confmat
run_all_accuracies(heron_benthic_confmat)
producer_accuracy(heron_benthic_confmat)
user_accuracy(heron_benthic_confmat)

## LIGHTHOUSE

## MOOREA

## KARIMUNJAWA

## HAWAI'I



# resampled accuracy ------------------------------------------------------

## HERON
heron_benthic_resampled <- get_resampled_accuracy(true_id = heron_benthic_points$Class_name_MAP.Simple,
                                                  pred_class = heron_benthic_points$FD_Dominant.Simple,
                                                  nboot = 500, fraction = 0.632, plot = T)


## LIGHTHOUSE

## MOOREA

## KARIMUNJAWA

## HAWAI'I
