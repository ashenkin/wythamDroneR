library(raster)
library(RStoolbox)
library(parallel)
library(doParallel)
library(foreach)

bluetifs = list( "000-190227" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/000-190227/reflectance/merged_tiles/blue_merged.tif")),
                 "2-030419" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/2-030419/reflectance/merged_tiles/blue_merged.tif")),
                 "3-050419" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/3-050419/reflectance/merged_tiles/blue_merged.tif")),
                 "6-120419" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/6-120419/reflectance/merged_tiles/blue_merged.tif")),
                 "9-160419" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/9-160419/reflectance/merged_tiles/blue_merged.tif")),
                 "10-180419" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/10-180419/reflectance/merged_tiles/blue_merged.tif")),
                 "11-190419" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/11-190419/reflectance/11-190419_transparent_reflectance_blue.tif")),
                 "12-210419" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/12-210419/reflectance/12-210419_transparent_reflectance_blue.tif")),
                 "13-230419" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/13-230419/reflectance/merged_tiles/blue_merged.tif")),
                 "14-260419" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/14-260419/reflectance/14-260419_transparent_reflectance_blue.tif")),
                 "15-290419" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/15-290419/reflectance/15-290419_transparent_reflectance_blue.tif")),
                 "16-020519" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/16-020519/reflectance/merged_tiles/blue_merged.tif")),
                 "17-050519" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/17-050519/reflectance/17-050519_transparent_reflectance_blue.tif")),
                 "18-070519" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/18-070519/reflectance/18-070519_transparent_reflectance_blue.tif")),
                 "19-100519" = setMinMax(raster("G:/Shared drives/Wytham Drone Flights/reflectance results/19-100519/reflectance/10 May 2019 v3_transparent_reflectance_blue.tif"))
)

clust <- parallel::makeCluster(max(1, min(length(bluetifs) - 1, parallel::detectCores() - 1)))
doParallel::registerDoParallel(clust)
imgshifts = foreach::foreach (i = 1:(length(bluetifs) - 1), .packages = c("RStoolbox", "raster")) %dopar% {
    this_imgshift = list()
    coreg = coregisterImages(slave = bluetifs[[i]], master = bluetifs[[i+1]], nSamples = 500, reportStats = T, shift = 30, shiftInc = 1)
    this_imgshift["coreg"] = coreg[coreg != "coregImg"]
    this_imgshift["slave_img"] = names(bluetifs)[i]
    this_imgshift["master_img"] = names(bluetifs)[i+1]
    this_imgshift
}

stopCluster(clust)

# temp = coregisterImages(slave = bluetifs[[6]], master = bluetifs[[7]], nSamples = 500, reportStats = T, shift = 30, shiftInc = 1)

saveRDS(imgshifts, file = "imageshifts.rds")
