library(ranger)
library(ggplot2)
library(dplyr)
library(tidyr)


ee_data <- read.csv("cairns-cook_geomorphic_object_sample.csv", stringsAsFactors = F) %>%
  select(-system.index, -.geo) %>%
  rename(class = Class_na_1)


ee_data_plot <- gather(ee_data, "variable", "value",
                       b1:waves_1)

ggplot(ee_data_plot, aes(y = value, x = class)) +
  #geom_violin(aes(fill = class)) +
  geom_boxplot(aes(fill = class)) +
  facet_wrap(~variable, scales = "free")

# run RF to find threshold characteristics
rf_fit <- ranger(class ~ b1+b2+b3+b4+b5+depth+slope+waves, data = ee_data, num.trees = 500, importance = "permutation")

print(rf_fit)
sort(importance(rf_fit))
  