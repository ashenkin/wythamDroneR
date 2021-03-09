
# Match rasters in each directory: (merged|transparent)
# make an ordered raster stack
# shift stack or each layer
# then make a raster stack?
# save shifted stack as tif

# whenever stack is made, need to make sure that layers are ordered properly.  Search for blue/red/green/edge/nir.

library(raster)

output_directory = "D:/Data.local/Wytham Drone projects 2019/rasterbricks"

tif_dirs = list( "000-190227" = "G:/Shared drives/Wytham Drone Flights/reflectance results/000-190227/reflectance/merged_tiles/",
                 "2-030419" = "G:/Shared drives/Wytham Drone Flights/reflectance results/2-030419/reflectance/merged_tiles/",
                 "3-050419" = "G:/Shared drives/Wytham Drone Flights/reflectance results/3-050419/reflectance/merged_tiles/",
                 "6-120419" = "G:/Shared drives/Wytham Drone Flights/reflectance results/6-120419/reflectance/merged_tiles/",
                 "9-160419" = "G:/Shared drives/Wytham Drone Flights/reflectance results/9-160419/reflectance/merged_tiles/",
                 "10-180419" = "G:/Shared drives/Wytham Drone Flights/reflectance results/10-180419/reflectance/merged_tiles/",
                 "11-190419" = "G:/Shared drives/Wytham Drone Flights/reflectance results/11-190419/reflectance/",
                 "12-210419" = "G:/Shared drives/Wytham Drone Flights/reflectance results/12-210419/reflectance/",
                 "13-230419" = "G:/Shared drives/Wytham Drone Flights/reflectance results/13-230419/reflectance/merged_tiles/",
                 "14-260419" = "G:/Shared drives/Wytham Drone Flights/reflectance results/14-260419/reflectance/",
                 "15-290419" = "G:/Shared drives/Wytham Drone Flights/reflectance results/15-290419/reflectance/",
                 "16-020519" = "G:/Shared drives/Wytham Drone Flights/reflectance results/16-020519/reflectance/merged_tiles/",
                 "17-050519" = "G:/Shared drives/Wytham Drone Flights/reflectance results/17-050519/reflectance/",
                 "18-070519" = "G:/Shared drives/Wytham Drone Flights/reflectance results/18-070519/reflectance/",
                 "19-100519" = "G:/Shared drives/Wytham Drone Flights/reflectance results/19-100519/reflectance/"
)

order_rededge <- function(filepaths) {
    # order files from blue to nir
    filenames = basename(filepaths)
    filepaths_ordered = c()
    i = 1
    for (pat in c("blue", "green", "red(?![ _]?edge)", "edge", "nir")) {
        whichfile = which(grepl(pat, filenames, perl = T))
        filepaths_ordered[i] = filepaths[whichfile]
        i = i + 1
    }
    return(filepaths_ordered)
}

for (i in 1:length(tif_dirs)) {
    tifs = list.files(tif_dirs[[i]], pattern = "\\.tif$", full.names = T)
    thisbrick = raster::brick(purrr::map(order_rededge(tifs), raster))
    writeRaster(thisbrick, filename = file.path(output_directory, paste0(names(tif_dirs)[i],"_brick.tif")), format = "GTiff")
    rm(thisbrick)
}
