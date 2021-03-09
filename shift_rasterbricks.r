
# identifying best shift in each pair
# add up shifts from top to bottom
# match rasterbrick with each shift
# shift each rasterbrick

rasterbrick_dir = "D:/Data.local/Wytham Drone projects 2019/rasterbricks"
imgshifts = readRDS("imageshifts.rds")

# identify bestShift ####

add_bestShift <- function(imgshift) {
    coreg = imgshift[["coreg"]]
    bestShift = which.max(coreg$mi)
    bestx = coreg$x[bestShift]
    besty = coreg$y[bestShift]
    imgshift[["bestShift"]] = c("x" = bestx, "y" = besty)
    return(imgshift)
}

imgshifts = purrr::map(imgshifts, add_bestShift)

# aggregate shifts ####
agg_shift = list("x" = 0, "y" = 0)
for (i in length(imgshifts):1) {
    this_bestShift = imgshifts[[i]]$bestShift
    agg_shift$x = agg_shift$x + this_bestShift["x"]
    agg_shift$y = agg_shift$y + this_bestShift["y"]
    imgshifts[[i]][["agg_shift"]] = agg_shift
}

# match slave image to each imgshift element and perform the shift ####
match_and_shift_raster <- function(imgshift, rasterbrick_dir) {
    slave_img = list.files(rasterbrick_dir, pattern = imgshift$slave_img, full.names = T)
    shifted_raster = raster::shift(brick(slave_img), dx = imgshift[["agg_shift"]]$x, dy = imgshift[["agg_shift"]]$y)
    writeRaster(shifted_raster, file.path(dirname(slave_img), paste0(tools::file_path_sans_ext(basename(slave_img)), "_shifted.tif")))
}

purrr::map(imgshifts, match_and_shift_raster, rasterbrick_dir)
