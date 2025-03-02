#' Processing Landsat 8 with clipping and masking for 2024
#'
#' This function processes Landsat 8 surface reflectance data by clipping and masking
#' it according to a provided shapefile boundary. The function accepts a directory
#' of Landsat data, a shapefile for clipping, and outputs a masked Landsat image.
#'
#' @param landsat_dir A character string representing the directory path where the Landsat data files are stored.
#' @param shapefile_path A character string representing the file path to the shapefile containing the boundary (e.g., administrative area) used for clipping and masking the Landsat image.
#' @param output_path A character string specifying the path where the output masked Landsat image will be saved.
#' @param bands A numeric vector specifying the Landsat bands to be processed. Defaults to bands 1, 2, 3, 4, 5, and 7, which correspond to the blue, green, red, NIR, SWIR1, and SWIR2 bands.
#'
#' @returns A SpatRaster object (from the `terra` package) representing the masked Landsat image after clipping to the provided shapefile's boundary.
#' @export
#'
#' @examples
#' # Example usage:
#' ProcessingLandsat2024(
#'   landsat_dir = "E:/EAGLE/R_programming/LULC_LST/Data_2024/LC08_L2SP_169049_20240309_20240316_02_T1/",
#'   shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Greater_Asmara_Shapefile/Asmara.shp",
#'   output_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_2024.tif",
#'   bands = c(1, 2, 3, 4, 5, 7)
#' )
ProcessingLandsat2024 <- function(landsat_dir, shapefile_path, output_path, bands = c(1, 2, 3, 4, 5, 7)) {

  # Set the working directory
  setwd(landsat_dir)

  # List the Landsat band files based on the provided bands
  band_files <- paste0("LC08_L2SP_169049_20240309_20240316_02_T1/LC08_L2SP_169049_20240309_20240316_02_T1_SR_B", bands, ".tif")

  # Check if the band files exist
  if (any(!file.exists(band_files))) {
    stop("One or more band files are missing. Please check the file paths.")
  }

  # Read the Landsat bands using terra::rast, assuming 'terra' is pre-loaded
  landsat_bands <- lapply(band_files, function(x) terra::rast(x))

  # Stack the Landsat bands using terra::c()
  Landsat_stack <- terra::c(landsat_bands)  # Use terra::c() for stacking

  # Check for correct stacking
  if (length(Landsat_stack) != length(bands)) {
    stop("Mismatch between number of bands and the stacked raster layers.")
  }

  # Visualize the stacked bands (show the first 3 bands in RGB)
  terra::plot(Landsat_stack[[c(4, 3, 2)]], main = "True Color Composite (Bands 4, 3, 2)")

  # Create a False Color Composite (Bands 5, 4, 3: NIR, Red, Green)
  terra::plotRGB(Landsat_stack, r = 5, g = 4, b = 3, stretch = "lin", main = "False Color Composite (Bands 5, 4, 3)")

  # Read the shapefile for the boundary using sf::st_read, assuming 'sf' is pre-loaded
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
