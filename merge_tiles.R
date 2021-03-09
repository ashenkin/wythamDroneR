library(raster)
library(purrr)

layer_pats = c("blue_merged" = ".*noalpha.*blue.*\\.tif",
               "green_merged" = ".*noalpha.*green.*\\.tif",
               "red_merged" = ".*noalpha.*red.*\\.tif",
               "rededge_merged" = ".*noalpha.*red edge.*\\.tif",
               "nir_merged" = ".*noalpha.*nir.*\\.tif")

#proc_dir = choose.dir(caption = "Select folder with tiled images to merge")
proc_dir = "G:/Shared drives/Wytham Drone Flights/reflectance results/000-190227/reflectance/tiles/"
out_dir = file.path(proc_dir, "..", "merged_tiles")
dir.create(out_dir)
warning(paste("Creating directory", out_dir, "if it doesn't exist."))

for (i in 1:length(layer_pats)) {
    this_pat = layer_pats[i]
    outfile = paste0(names(layer_pats)[i], ".tif")
    tile_files = list.files(proc_dir, pattern = this_pat, full.names = T)
    rasters = map(tile_files, raster)
    do.call(raster::merge, c(rasters, filename = file.path(out_dir, outfile)))
}