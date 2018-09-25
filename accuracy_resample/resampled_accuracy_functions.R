get_conf_mat <- function(true_id, pred_class) {
  table(as.character(pred_class),
        as.character(true_id))
  # note danger here that it relies on always having at least one case for each class (that is, it relies on the alphabetical factor ordering to ensure confusion matrices are identical in structure)
}

# dim_check <- function(x, len = 4) { # DANGER - hard coded to 4 classes, use len = if error matrix is different size
#   dim(x)[1] != len | dim(x)[2] != len
# }

dim_check <- function(x) {
  if (dim(x)[1] == dim(x)[2]) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

percentage_agreement <- function(conf_mat) {
  # sum(as.character(data[true_id[[reps]], "veg_class"]) == as.character(pred_class[[reps]])) / length(pred_class[[reps]])
  #if(dim_check(conf_mat)) {return(NA)}
  sum(diag(conf_mat)) / sum(conf_mat) # xtab method quicker?
}

cohens_kappa <- function(conf_mat) {
  #if(dim_check(conf_mat)) {return(NA)}
  # props <- conf_mat / sum(conf_mat)
  # cor_prob <- sum(diag(props))
  # chance_prob <- sum( apply(props, 1, sum) * apply(props, 2, sum) )
  # below seems to be a touch quicker...
  cor_prob <- sum(diag(conf_mat)) / sum(conf_mat)
  chance_prob <- crossprod(colSums(conf_mat) / sum(conf_mat), rowSums(conf_mat) / sum(conf_mat))[1]
  (cor_prob - chance_prob)/(1 - chance_prob)
}

# entropy and purity stolen from {IntNMF} package
entropy <- function(conf_mat) {
  #if(dim_check(conf_mat)) {return(NA)}
  inner_sum <- apply(conf_mat, 1, function(x) {
    c_size <- sum(x)
    sum(x * ifelse(x != 0, log2(x/c_size), 0))
  })
  -sum(inner_sum)/(sum(conf_mat) * log2(ncol(conf_mat)))
}

purity <- function(conf_mat) {
  #if(dim_check(conf_mat)) {return(NA)}
  sum(apply(conf_mat, 1, max)) / sum(conf_mat)
}

# disagreemetns kind of stolen from {diffeR} package
disagreement <- function(conf_mat) {
  #if(dim_check(conf_mat)) {return(NA)}
  1 - (sum(diag(conf_mat)) / sum(conf_mat))
}

quantity_disagreement <- function(conf_mat) {
  #if(dim_check(conf_mat)) {return(NA)}
  sum(abs(apply(conf_mat, 1, sum) - apply(conf_mat, 2, sum))) / 2 / sum(conf_mat)
}

allocation_disagreement <- function(conf_mat) {
  #if(dim_check(conf_mat)) {return(NA)}
  disagreement(conf_mat) - quantity_disagreement(conf_mat)
}

producer_accuracy <- function(conf_mat) {
  #if(dim_check(conf_mat)) {ret <- data.frame(NA,NA,NA,NA); names(ret) <- names(conf_mat); return()} # DANGER - hard coded to 4 classes
  ret <- diag(conf_mat) / apply(conf_mat, 1, sum)
  names(ret) <- paste0(names(ret),"_prod")
  data.frame(as.list(ret))
}

user_accuracy <- function(conf_mat) {
  #if(dim_check(conf_mat)) {ret <- data.frame(NA,NA,NA,NA); names(ret) <- names(conf_mat); return()} # DANGER - hard coded to 4 classes
  ret <- diag(conf_mat) / apply(conf_mat, 2, sum)
  names(ret) <- paste0(names(ret),"_user")
  data.frame(as.list(ret))
}

run_all_accuracies <- function(conf_mat) {
  print("overall accuracy: ")
  cat(percentage_agreement(conf_mat), '\n')
  print("kappa: ")
  cat(cohens_kappa(conf_mat), '\n')
  print("entropy: ")
  cat(entropy(conf_mat), '\n')
  print("purity: ")
  cat(purity(conf_mat), '\n')
  print("allocation disagreement: ")
  cat(allocation_disagreement(conf_mat), '\n')
  print("quantity disagreement: ")
  cat(quantity_disagreement(conf_mat), '\n')
}

# function to monte-carlo resample data point and generate a confusion matrix
## -> relies on consistent field naming between data sets - otherwise modify the data= argument to the validation and map class fields
get_sample_confmat <- function(true_id, pred_class, fraction = 0.67) {
  data <- data.frame(true_id, pred_class) %>%
    group_by(pred_class) %>%
    sample_frac(fraction)
  get_conf_mat(true_id = data$true_id, 
               pred_class = data$pred_class)
}

# function to perform accuracy resampling - basically resampling the full error matrix
## nboot= is the number of iterations, fraction= is the resampling fraction, plot= denotes whether to make an accuracy plot
get_resampled_accuracy <- function(true_id, pred_class, nboot = 100, fraction = 0.632, plot = T) {
  # build confusion matrices for the resampled data
  conf_mats <- replicate(n = nboot, expr = {get_sample_confmat(true_id = true_id, pred_class = pred_class, fraction = fraction)}, simplify = F)
  # build index of complete cases then subset (with enoug hresampling you eventually stumble on a combination where you don't sample all categories)
  conf_mats_complete <- unlist(lapply(conf_mats, dim_check))
  conf_mats <- conf_mats[conf_mats_complete]
  # build the sampling distribution of accuracy metrics
  overall <- unlist(lapply(conf_mats, percentage_agreement))
  user <- bind_rows(lapply(conf_mats, user_accuracy))
  producer <- bind_rows(lapply(conf_mats, producer_accuracy))
  # collate the data
  accuracy <- data.frame(overall = overall, user, producer) %>%
    gather("metric", "value")
  # summarise it to reportable/plottable values
  accuracy_summary <- accuracy %>%
    group_by(metric) %>%
    summarise(mean = mean(value),
              low95 = quantile(value, 0.025),
              up95 = quantile(value, 0.975),
              min = min(value),
              max = max(value))
  # plot it
  # get levels so overall is first
  plt_levels <- c("overall", unique(accuracy_summary$metric)[unique(accuracy_summary$metric)!="overall"])
  plt <- accuracy_summary %>%
    mutate(metric = factor(metric,  levels = plt_levels)) %>%
    #gather("statistic", "value", mean:max) %>%
    ggplot(aes(x = metric, fill = metric)) + 
    geom_bar(aes(y = mean), stat = "identity") +
    geom_errorbar(aes(ymin = low95, ymax = up95)) +
    ylab("Accuracy value (%)") + xlab("Accuracy measure") +
    theme_bw()
  if (plot) {
    print(plt)
    print(accuracy_summary)
    return(list(accuracy_summary = accuracy_summary, accuracy_plot = plt))
  } else {
    print(accuracy_summary)
    return(accuracy_summary)
  }
}

## functions to simplify the geomorphic/benthic class labels - classes don't have to exist, it's a logical grep
simplify_benthic <- function(benthic_segments) {
  benthic_segments$Class_simp <- benthic_segments$Class_name
  benthic_segments$Class_simp[grepl("Sand", benthic_segments$Class_simp)] <- "Sand"
  benthic_segments$Class_simp[grepl("BMA", benthic_segments$Class_simp)] <- "BMA"
  benthic_segments$Class_simp[grepl("Rock", benthic_segments$Class_simp)] <- "Rock"
  benthic_segments$Class_simp[grepl("Coral", benthic_segments$Class_simp)] <- "Coral"
  benthic_segments$Class_simp[grepl("Seagrass", benthic_segments$Class_simp)] <- "Seagrass"
  benthic_segments$Class_simp[grepl("Rubble", benthic_segments$Class_simp)] <- "Rubble"
  benthic_segments$Class_simp[grepl("Plateau", benthic_segments$Class_simp)] <- "Plateau"
  benthic_segments$Class_simp[grepl("Deep Slope", benthic_segments$Class_simp)] <- "Deep Slope"
  benthic_segments
}
## as above
simplify_geomorphic <- function(geomorphic_segments) {
  geomorphic_segments$Class_simp <- geomorphic_segments$Class_name
  geomorphic_segments$Class_simp[grepl("Deep Slope", geomorphic_segments$Class_simp)] <- "Deep Slope"
  geomorphic_segments$Class_simp[grepl("Slope 3",geomorphic_segments$Class_simp)] <- "Slope"
  geomorphic_segments$Class_simp[grepl("Plateau",geomorphic_segments$Class_simp)] <- "Plateau"
  geomorphic_segments
}

# function to read in .dbf file and warn if there's already confidence values in there
## simplify_classes refers to above two functions
## geo_or_benthic= denotes whether the class simpificaiton applied to geomorphic or benthic
##                 function tries to figure it out, if not nees to specify geo_or_benthic = "geo" or geo_or_benthic = "benthic"
read_dbf <- function(path, simplify_classes, geo_or_benthic = NULL) {
  # figure out what type of mapping the input shapefile is
  if (simplify_classes & is.null(geo_or_benthic)) {
    if (grepl("geo", path)) {geo_or_benthic <- "geo"}
    else if (grepl("benthic", path)) {geo_or_benthic <- "benthic"}
    else stop("Couldn't figure out if input was geomorphic or benthic - please speficy with geo_or_benthic= argument")
  } else {
    if (geo_or_benthic == "geo") {geo_or_benthic <- "geo"}
    if (geo_or_benthic == "benthic") {geo_or_benthic <- "benthic"}
  }
  # read in the dbf and simplify if needed
  infile <- read.dbf(path, as.is = T)
  if ("confidence" %in% names(infile)) warning("Shapfile being loaded already has confidence values - they wil be overwritten")
  if (simplify_classes) {
    if (geo_or_benthic == "geo") {infile <- simplify_geomorphic(infile)}
    if (geo_or_benthic == "benthic") {infile <- simplify_benthic(infile)}
  }
  attr(infile, "path") <- path
  infile
}

# function for random monte carlo resampling and model fitting
fit_rf_to_sample <- function(data, fraction) {
  sampled_data <- data %>%
    group_by(Class_simp) %>% # hard coded in this variable name
    sample_frac(fraction)
  # fit the model to the sampled data
  rf_fit <- ranger(formula = Class_simp ~ blue_ssr + green_ssr + red_ssr + blue_sfr + green_sfr + red_sfr + depth + slope + waves,
                   data = sampled_data, num.trees = 200, min.node.size = 1)
  as.character(predict(object = rf_fit, data = data)$predictions)
}

# function to help calculate the mode/count for the sampling distribution
Mode <- function(x) {
  ux <- unique(x)
  uxt <- tabulate(match(x, ux))
  return(list(mode = ux[which.max(uxt)],
              n = max(uxt)))
}

# helper function to calculate number of times the mapped class is equal to the sample distribution
equal_to_mapped <- function(x, y) {
  sum(x == y)
}

# function to take a segmentation shapefile dbf, resample and calculate confience levels based on a rndom forest model
## method = 'mode' denotes confidence calculated as % of sample distribution classified as the mode
## method = 'mapped' denotes confidence calculated as % of sample distribution equal to mapped value
## method = 'binary' denotes confidence calculated as whether mode of sample distribution equals mapped value
## nboot= is number of resamples, fraction= is the fraction of data to resample
calculate_confidence_level <- function(classes_to_ignore, segments, nboot = 10, fraction = 0.368, 
                                       method = "mapped", write_output_to_dbf = F) {
  if (!method %in% c("mapped", "mode", "binary")) stop("method= must be one of 'mapped', 'mode' or 'binary'")
  # get vector of classes to ignore/keep
  classes <- unique(segments$Class_simp)[!unique(segments$Class_simp) %in% classes_to_ignore]
  # get an index of the above classes within the shape file
  seg_class_idx <- segments$Class_simp %in% classes # hard coded class name column
  # get that subset of the data for modelling
  seg_model_dat <- segments[seg_class_idx,]
  # monte carlo resample the segmetns, fit models, and predict out to whole set
  seg_sample_dist <- replicate(n = nboot, expr = {fit_rf_to_sample(seg_model_dat, fraction = fraction)}, simplify = T)
  # find the confidence level - based on method supplied to method= argument
  if (method == "mode") {
    seg_mode <- apply(seg_sample_dist, 1, Mode)
    seg_confidence <- unlist(lapply(seg_mode, `[[`, 2)) / ncol(seg_sample_dist)
  } else if (method == "mapped") {
    seg_confidence <- unlist(map2(as.list(as.data.frame(t(seg_sample_dist), stringsAsFactors = F)),
                                  as.list(seg_model_dat$Class_simp),
                                  equal_to_mapped)) / ncol(seg_sample_dist)
  } else {
    seg_mode <- apply(seg_sample_dist, 1, Mode)
    seg_confidence <- as.integer(unlist(lapply(seg_mode, `[[`, 1)) == seg_model_dat$Class_simp)
  }
  # write the confidence vlaues back into the appropriate shape file slots
  segments$confidence <- -1
  segments$confidence[seg_class_idx] <- seg_confidence
  # write the confidence values back to the .dbf file
  if (write_output_to_dbf) {
    write.dbf(dataframe = segments, file = attr(segments, "path"))
  }
  invisible(segments) # so you don't have to store a return if you don't want
}

# function to get confidence level summary stats for each class
get_confidence_stats <- function(segments) {
  segments %>%
    select(Class_simp, confidence) %>%
    group_by(Class_simp) %>%
    summarise(mean = mean(confidence),
              up95 = quantile(confidence, 0.975),
              low95 = quantile(confidence, 0.025)) %>%
    arrange(desc(mean))
}
