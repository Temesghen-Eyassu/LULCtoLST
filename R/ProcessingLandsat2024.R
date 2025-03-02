ProcessingLandsat2024 <- function(landsat_dir, shapefile_path, output_path, bands = c(1, 2, 3, 4, 5, 7)) {

  # Set the working directory
  setwd(landsat_dir)

  # List the Landsat band files based on the provided bands
  band_files <- paste0("LC08_L2SP_169049_20240309_20240316_02_T1_SR_B", bands, ".TIF")

  # Print the band files to check if the paths are correct
  print("Band files to be loaded:")
  print(band_files)

  # Check if the band files exist
  missing_files <- band_files[!file.exists(band_files)]
  if (length(missing_files) > 0) {
    stop("The following band files are missing: ", paste(missing_files, collapse = ", "))
  }

  # Read the Landsat bands using terra::rast, with error handling
  landsat_bands <- lapply(band_files, function(x) {
    tryCatch({
      terra::rast(x)
    }, error = function(e) {
      message(paste("Error reading band file:", x))
      NULL  # Return NULL if there's an error reading the file
    })
  })

  # Remove any NULL values from the landsat_bands list (failed loads)
  landsat_bands <- Filter(Negate(is.null), landsat_bands)

  # Stack the Landsat bands
  if (length(landsat_bands) != length(bands)) {
    stop("Mismatch between number of successfully loaded bands and expected bands. Found ",
         length(landsat_bands), " layers, but expected ", length(bands), " layers.")
  }

  # Stack the rasters into a single object
  Landsat_stack <- terra::rast(landsat_bands)  # Stack the rasters

  # Visualize the stacked bands (show the first 3 bands in RGB)
  terra::plot(Landsat_stack[[c(4, 3, 2)]], main = "True Color Composite (Bands 4, 3, 2)")

  # Create a False Color Composite (Bands 5, 4, 3: NIR, Red, Green)
  terra::plotRGB(Landsat_stack, r = 5, g = 4, b = 3, stretch = "lin", main = "False Color Composite (Bands 5, 4, 3)")

  # Read the shapefile for the boundary using sf::st_read
  Asmara_shape <- sf::st_read(shapefile_path)

  # Ensure CRS of both shapefile and Landsat stack are the same
  if (terra::crs(Asmara_shape) != terra::crs(Landsat_stack)) {
    # Reproject the shapefile to the CRS of the Landsat stack
    Asmara_shape <- sf::st_transform(Asmara_shape, terra::crs(Landsat_stack))
    message("Reprojected shapefile CRS to match Landsat stack.")
  }

  # Crop the Landsat stack using the Asmara boundary
  Cropped_Asmara <- terra::crop(Landsat_stack, Asmara_shape)
  terra::plot(Cropped_Asmara, main = "Cropped Landsat Image")

  # Mask the cropped Landsat image using the Asmara boundary
  masked_Asmara <- terra::mask(Cropped_Asmara, Asmara_shape)
  terra::plot(masked_Asmara, main = "Masked Landsat Image")

  # Save the masked image to the specified output path
  terra::writeRaster(masked_Asmara, output_path, overwrite = TRUE)

  # Return the masked image object for further processing if needed
  return(masked_Asmara)
}
