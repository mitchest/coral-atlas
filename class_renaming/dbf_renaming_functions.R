# ## functions to simplify the geomorphic/benthic class labels - classes don't have to exist, it's a logical grep
# ## ## can keep adding to these over time

rename_geomorphic <- function(x, class_column, classes_to_ignore) {
  x$glob_class <- x[,class_column]
  # if there's classes to ignore
  if (!is.null(classes_to_ignore)) {
    if (sum(classes_to_ignore %in% unique(x$glob_class)) == 0) stop("The classes you're trying to ignore are not in here")
    ignore_idx <- x$glob_class %in% classes_to_ignore
    x$glob_class[ignore_idx] <- "Ignore"
  }
  # generic
  x$glob_class[grepl("Cloud",x$glob_class)] <- "Ignore"
  x$glob_class[grepl("Waves",x$glob_class)] <- "Ignore"
  x$glob_class[grepl("Land",x$glob_class)] <- "Land"
  x$glob_class[grepl("Island",x$glob_class)] <- "Land"
  x$glob_class[grepl("Outer",x$glob_class)] <- "Outer Reef Flat"
  x$glob_class[grepl("Inner",x$glob_class)] <- "Inner Reef Flat"
  x$glob_class[grepl("Patch",x$glob_class)] <- "Patch Reef"
  x$glob_class[grepl("Rim",x$glob_class)] <- "Reef Rim"
  x$glob_class[grepl("Terrestrial",x$glob_class)] <- "Reef Flat Terrestrial"
  x$glob_class[grepl("Open Comlex Lagoon",x$glob_class)] <- "Open Comlex Lagoon"
  x$glob_class[grepl("Shallow Lagoon",x$glob_class)] <- "Shallow Lagoon"
  x$glob_class[grepl("Deep Lagoon", x$glob_class)] <- "Deep Lagoon"
  x$glob_class[grepl("Small Reef",x$glob_class)] <- "Small Reef"
  x$glob_class[grepl("Reef Crest",x$glob_class)] <- "Reef Rim"
  x$glob_class[grepl("Deep Water",x$glob_class)] <- "Deep"
  x$glob_class[grepl("Plateau ",x$glob_class)] <- "Plateau"
  x$glob_class[grepl("Sheltered",x$glob_class)] <- "Slope Sheltered"
  x$glob_class[grepl("Exposed",x$glob_class)] <- "Slope Exposed"
  # cairns cook
  x$glob_class[grepl("Deep Slope 10 m + Leeward",x$glob_class, fixed = T)] <- "Slope Sheltered"
  x$glob_class[grepl("Deep Slope 10 m + Windward",x$glob_class, fixed = T)] <- "Slope Exposed"
  x$glob_class[grepl("Slope 3- 10 m Windward",x$glob_class)] <- "Slope Exposed"
  x$glob_class[grepl("Slope 3- 10 m Leeward no lagoon",x$glob_class)] <- "Slope Sheltered"
  x$glob_class[grepl("DeepWater-Nodata",x$glob_class)] <- "Deep"
  # cap bunk
  x$glob_class[grepl("Back Reef slope 10-90d",x$glob_class)] <- "Slope Sheltered"
  x$glob_class[grepl("Crest Reef",x$glob_class)] <- "Reef Rim"
  x$glob_class[grepl("Deep Lagoon (0.75 - 20 m)",x$glob_class)] <- "Deep Lagoon"
  x$glob_class[grepl("Deep Water < 20 m",x$glob_class)] <- "Deep"
  x$glob_class[grepl("Fore Reef slope 20-90d",x$glob_class)] <- "Slope Exposed"
  x$glob_class[grepl("Reef slope 20-90d Deep",x$glob_class)] <- "Slope Sheltered"
  # fiji
  x$glob_class[grepl("Lagoon", x$glob_class)] <- "Shallow Lagoon"
  x$glob_class[grepl("Sheletered",x$glob_class)] <- "Slope Sheltered"
  
  # return it
  x
}

rename_benthic <- function(x, class_column, classes_to_ignore,
                           benthic_classes = c("Rubble","Sand","Rock","Coral", "Algae", "Cor_Alg","Seagrass","Mangrove","Mud")) {
  x$glob_class <- x[,class_column]
  # if there's classes to ignore
  if (!is.null(classes_to_ignore)) {
    if (sum(classes_to_ignore %in% unique(x$glob_class)) == 0) stop("The classes you're trying to ignore are not in here")
    ignore_idx <- x$glob_class %in% classes_to_ignore
    x$glob_class[ignore_idx] <- "Ignore"
  }
  # generic
  x$glob_class[grepl("Rubble",x$glob_class)] <- "Rubble"
  x$glob_class[grepl("Sand",x$glob_class)] <- "Sand"
  x$glob_class[grepl("Rock",x$glob_class)] <- "Rock"
  x$glob_class[grepl("Coral/Algae",x$glob_class)] <- "Cor_Alg"
  x$glob_class[grepl("Coral",x$glob_class)] <- "Coral" # allows 'pure' coral class
  x$glob_class[grepl("Algae",x$glob_class)] <- "Algae" # allows 'pure' algae class
  x$glob_class[grepl("Seagrass",x$glob_class)] <- "Seagrass"
  x$glob_class[grepl("Mangrove",x$glob_class)] <- "Mangrove"
  x$glob_class[grepl("Mud",x$glob_class)] <- "Mud"
  # cairns cook
  #??
  # cap bunk
  #??
  # remove geomorphic classes if present
  x$glob_class[!x$glob_class %in% benthic_classes] <- "Ignore"
  # return it
  x
}

number_geomorphic <- function(x) {
  x$class_num <- NA
  # generic
  ###--> tiered system? (i.e. 1-10 for non-reef stuff (deep/land etc.), 11-20 for reef top, 21-30 for the rest)
  x$class_num[grepl("Ignore",x$glob_class)] <- 0
  x$class_num[grepl("Land",x$glob_class)] <- 1
  x$class_num[grepl("Deep",x$glob_class)] <- 2
  x$class_num[grepl("Shallow Lagoon",x$glob_class)] <- 11
  x$class_num[grepl("Deep Lagoon",x$glob_class)] <- 12
  x$class_num[grepl("Inner Reef Flat",x$glob_class)] <- 13
  x$class_num[grepl("Outer Reef Flat",x$glob_class)] <- 14
  x$class_num[grepl("Reef Rim",x$glob_class)] <- 15
  x$class_num[grepl("Reef Flat Terrestrial",x$glob_class)] <- 16
  x$class_num[grepl("Slope Sheltered",x$glob_class)] <- 21
  x$class_num[grepl("Slope Exposed",x$glob_class)] <- 22
  x$class_num[grepl("Plateau",x$glob_class)] <- 23
  x$class_num[grepl("Open Comlex Lagoon",x$glob_class)] <- 24
  x$class_num[grepl("Patch Reef",x$glob_class)] <- 25
  x$class_num[grepl("Small Reef",x$glob_class)] <- 26
  
  x$class_num <- as.integer(x$class_num)
  # return it
  x
}

number_benthic <- function(x) {
  x$class_num <- NA
  # generic
  ###--> tiered system? (i.e. 1-10 for non-reef stuff (deep/land etc.), 11+ ofr benthic classes
  x$class_num[grepl("Ignore",x$glob_class)] <- 0
  x$class_num[grepl("Land",x$glob_class)] <- 1
  x$class_num[grepl("Deep",x$glob_class)] <- 2
  x$class_num[grepl("Mangrove",x$glob_class)] <- 3
  x$class_num[grepl("Mud",x$glob_class)] <- 4
  x$class_num[grepl("Sand",x$glob_class)] <- 11
  x$class_num[grepl("Rubble",x$glob_class)] <- 12
  x$class_num[grepl("Rock",x$glob_class)] <- 13
  x$class_num[grepl("Seagrass",x$glob_class)] <- 14
  x$class_num[grepl("Cor_Alg",x$glob_class)] <- 15
  x$class_num[grepl("Coral",x$glob_class)] <- 16
  x$class_num[grepl("Algae",x$glob_class)] <- 17
  
  x$class_num <- as.integer(x$class_num)
  # return it
  x
}

# function to read in .dbf file and make a new column of clean class names and corresponding numbers
## geo_or_benthic= denotes whether the class simpificaiton applied to geomorphic or benthic
##                 function tries to figure it out, if not nees to specify geo_or_benthic = "geo" or geo_or_benthic = "benthic"
## class_column= denotes name of the column with the class names in (defaults to 'Class_na_1')
## add_class_numbers= denotes whether to add a column with standard corresponding class numbers
## write_dbf= denotes whether the data should be written back into the dbf file
## just_read_it= denotes whether to just read the file in and return it
rename_classes_dbf <- function(path, geo_or_benthic = NULL, class_column = "Class_na_1",
                               add_class_numbers = TRUE, write_dbf = TRUE, just_read_it = FALSE,
                               classes_to_ignore = NULL) {
  # figure out what type of mapping the input shapefile is
  if (is.null(geo_or_benthic)) {
    if (grepl("geo", path)) {geo_or_benthic <- "geo"}
    else if (grepl("benthic", path)) {geo_or_benthic <- "benthic"}
    else stop("Couldn't figure out if input was geomorphic or benthic - please speficy with geo_or_benthic= argument")
  } else {
    if (geo_or_benthic == "geo") {geo_or_benthic <- "geo"}
    if (geo_or_benthic == "benthic") {geo_or_benthic <- "benthic"}
  }
  # read in the dbf and clean
  dbf <- read.dbf(path, as.is = T)
  if (just_read_it) return(dbf)
  if ("glob_class" %in% names(dbf)) warning("Shapfile loaded already had cleaning applied - columns were overwritten")
  # rename to standard class names
  if (geo_or_benthic == "geo") {dbf <- rename_geomorphic(dbf, class_column, classes_to_ignore)}
  if (geo_or_benthic == "benthic") {dbf <- rename_benthic(dbf, class_column, classes_to_ignore)}
  if (!add_class_numbers) {
    message("Class names in new class field 'glob_class':")
    print(as.data.frame(table(dbf$glob_class)))
  }
  # add corresponding class names
  if (add_class_numbers) {
    if (geo_or_benthic == "geo") {dbf <- number_geomorphic(dbf)}
    if (geo_or_benthic == "benthic") {dbf <- number_benthic(dbf)}
  }
  message("Class names and numbers in fields 'glob_class' and 'class_num':")
  print(dbf %>% select(glob_class, class_num) %>% group_by(glob_class, class_num) %>% distinct() %>% arrange(class_num))
  # write path attribute in case you need it later
  attr(dbf, "path") <- path
  # write dbf back
  if (write_dbf) {
    write.dbf(dataframe = dbf, file = path)
    message("New columns written into shapefile")
  }
  # return invisibly in case yo uwant to inspect results
  invisible(dbf)
}


# helper function to load and trim shapefiles to required columns
load_chop_shp <- function(path, classes, nums) {
  shp <- readOGR(dsn = path, stringsAsFactors = F)
  shp <- shp[,c(classes, nums)]
}


## Function to merge shapefiles, after they have been cleaned up
# shp_paths= should be a LIST of 2 or more shapefiles 
# write_to_disk= and new_shp_path= control if and where the resulting merged shapefile should be written (if write_to_disk = F, function returns the merged shpefile)
# classes= and nums= denote the fields that contain the class names and numbers to be kept (defaults to the rename_classes_dbf() defaults)
merge_shapefiles <- function(shp_paths, write_to_disk = T, new_shp_path = NULL,
                             classes = "glob_class", nums = "class_num") {
  if (write_to_disk & is.null(new_shp_path)) stop("Provide a file name if you want to save the shapfile to disk")
  shp_list <- lapply(shp_paths, load_chop_shp, classes, nums)
  if (length(unique(unlist(lapply(shp_list, proj4string)))) > 1) {
    shp_list <- lapply(shp_list, spTransform, CRSobj = CRS("+init=epsg:4326"))
    message("Projections did not match, so they were reprojected to epsg:4326")
  }
  out_shp <- do.call("rbind", shp_list)
  if (write_to_disk) {
    writeOGR(obj = out_shp, dsn = dirname(new_shp_path), 
             layer = strsplit(basename(new_shp_path), ".", fixed = T)[[1]][1],
             driver = "ESRI Shapefile")
  } else {
    return(out_shp)
  }
}

