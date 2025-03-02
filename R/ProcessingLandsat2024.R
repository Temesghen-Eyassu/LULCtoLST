process_landsat_data <- function(landsat_dir, shapefile_path, output_path, bands = c(1, 2, 3, 4, 5, 7)) {

  # Set the working directory
  setwd(landsat_dir)

  # List the Landsat band files based on the provided bands
  band_files <- paste0("LC08_L2SP_169049_20240309_20240316_02_T1/LC08_L2SP_169049_20240309_20240316_02_T1_SR_B", bands, ".tif")

  # Read the Landsat bands using terra::rast, assuming 'terra' is pre-loaded
  landsat_bands <- lapply(band_files, function(x) terra::rast(x))

  # Stack the Landsat bands
  Landsat_stack <- terra::c(landsat_bands)  # Use terra::c() for stacking

  # Check for correct stacking
  if (length(Landsat_stack) != length(bands)) {
    stop("Mismatch between number of bands and the stacked raster layers.")
  }

  # Visualize the stacked bands (show the first 3 bands in RGB)
  plot(Landsat_stack[[c(4, 3, 2)]], main = "True Color Composite (Bands 4, 3, 2)")

  # Create a False Color Composite (Bands 5, 4, 3: NIR, Red, Green)
  plotRGB(Landsat_stack, r = 5, g = 4, b = 3, stretch = "lin", main = "False Color Composite (Bands 5, 4, 3)")

  # Read the shapefile for the boundary using sf::st_read, assuming 'sf' is pre-loaded
  Asmara_shape <- sf::st_read(shapefile_path)

  # Ensure CRS of both shapefile and Landsat stack are the same
  if (crs(Asmara_shape) != crs(Landsat_stack)) {
    # Reproject the shapefile to the CRS of the Landsat stack
    Asmara_shape <- sf::st_transform(Asmara_shape, crs(Landsat_stack))
    message("Reprojected shapefile CRS to match Landsat stack.")
  }

  # Crop the Landsat stack using the Asmara boundary
  Cropped_Asmara <- terra::crop(Landsat_stack, Asmara_shape)
  plot(Cropped_Asmara, main = "Cropped Landsat Image")

  # Mask the cropped Landsat image using the Asmara boundary
  masked_Asmara <- terra::mask(Cropped_Asmara, Asmara_shape)
  plot(masked_Asmara, main = "Masked Landsat Image")

  # Save the masked image to the specified output path
  writeRaster(masked_Asmara, output_path, overwrite = TRUE)

  # Return the masked image object for further processing if needed
  return(masked_Asmara)
}
