#'  LSTfirst_2014: A function to process Landsat 8 imagery (2014) and calculate Land Surface Temperature (LST)
#'
#' This function performs several steps to calculate Land Surface Temperature (LST) from Landsat 8 imagery (2014)
#' by processing three bands: Red (Band 4), NIR (Band 5), and Thermal Infrared (Band 10).
#' The workflow includes:
#' 1. Calculating NDVI (Normalized Difference Vegetation Index)
#' 2. Calculating Proportion of Vegetation (Pveg)
#' 3. Calculating Emissivity (ε)
#' 4. Calculating Brightness Temperature (BT)
#' 5. Calculating Land Surface Temperature (LST)
#'
#' The function also plots intermediate results and saves the final LST raster to a specified directory.
#'
#' @param work_dir A character string specifying the working directory where Landsat data is stored.
#' @param shapefile_path A character string specifying the path to the shapefile used to mask and crop the raster data.
#' @param output_dir A character string specifying the directory where the output rasters will be saved.
#'
#' @returns A series of raster layers (NDVI, Pveg, Emissivity, Brightness Temperature, and LST) that are saved as TIFF files in the output directory.
#'
#' @export
#'
#' @examples
#' LSTfirst_2014(
#'   work_dir = "E:/EAGLE/R_programming/LULC_LST/Data_2014",
#'   shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/Greater_Asmara_Shapefile/Asmara.shp",
#'   output_dir = "E:/EAGLE/R_programming/LULC_LST/Data_2014/LST_2014"
#' )
#'
#' @note The function assumes that the Landsat 8 data is organized in a specific directory structure
#' as demonstrated in the code, with individual band files named according to the Landsat metadata.
#' The function uses the `terra` and `sf` packages for raster manipulation and shapefile reading.
LSTfirst_2014 <- function(work_dir, shapefile_path, output_dir) {
  # Set the working directory
  setwd(work_dir)

  # Load Landsat 8 bands for 2014
  b4_2014 <- terra::rast(paste0(work_dir, "/LC08_L2SP_169049_20140125_20200912_02_T1/LC08_L2SP_169049_20140125_20200912_02_T1_SR_B4.TIF")) # Red band (Band 4)
  b5_2014 <- terra::rast(paste0(work_dir, "/LC08_L2SP_169049_20140125_20200912_02_T1/LC08_L2SP_169049_20140125_20200912_02_T1_SR_B5.TIF")) # NIR (Band 5)
  b10_2014 <- terra::rast(paste0(work_dir, "/LC08_L2SP_169049_20140125_20200912_02_T1/LC08_L2SP_169049_20140125_20200912_02_T1_ST_B10.TIF")) # Thermal Infrared (Band 10)

  # Load the shapefile (Asmara area)
  Asmara <- sf::st_read(shapefile_path)

  # Crop and mask the raster bands using the Asmara shapefile
  band4_masked <- terra::mask(terra::crop(b4_2014, terra::ext(Asmara)), Asmara)
  band5_masked <- terra::mask(terra::crop(b5_2014, terra::ext(Asmara)), Asmara)
  band10_masked <- terra::mask(terra::crop(b10_2014, terra::ext(Asmara)), Asmara)

  # 1. **Calculate NDVI** (Normalized Difference Vegetation Index)
  ndvi <- (band5_masked - band4_masked) / (band5_masked + band4_masked)

  # Plot NDVI to check the result
  terra::plot(ndvi, main = "NDVI for 2014")

  # 2. **Calculate Proportion of Vegetation (Pveg)**
  # Calculate the minimum and maximum NDVI values
  ndvi_min <- min(ndvi[], na.rm = TRUE)
  ndvi_max <- max(ndvi[], na.rm = TRUE)

  pveg <- (ndvi - ndvi_min) / (ndvi_max - ndvi_min)
  # Plot proportion of vegetation
  terra::plot(pveg, main = "Proportion of Vegetation (Normalized NDVI) for 2014")

  # 3. **Calculate Emissivity (ε)**
  emissivity <- 0.004 * pveg + 0.986
  # Plot emissivity
  terra::plot(emissivity, main = "Emissivity for 2014")

  # 4. **Calculate Brightness Temperature (BT)**
  K1 <- 774.89
  K2 <- 1321.08
  # Convert Band 10 to Top of Atmosphere (TOA) Radiance
  toa_radiance <- band10_masked * 0.0003342 + 0.1  # This is a typical scaling factor for Band 10
  # Calculate Brightness Temperature (BT)
  brightness_temp <- terra::app(toa_radiance, fun = function(x) {
    K2 / log((K1 / x) + 1)
  })
  # Plot Brightness Temperature
  terra::plot(brightness_temp, main = "Brightness Temperature (BT) for 2014")

  # 5. **Calculate Land Surface Temperature (LST)**
  lambda <- 11.5  # Wavelength in micrometers (for Band 10)
  rho <- 1.438 * 10^4  # Constant

  # Calculate LST using the formula
  lst <- terra::app(c(brightness_temp, emissivity), fun = function(x) {
    # Extract brightness temperature (BT) and emissivity (ε)
    bt <- x[[1]]  # First layer: brightness temperature
    emis <- x[[2]]  # Second layer: emissivity
    emis[is.na(emis)] <- 0.986  # Ensure emissivity does not contain NA values
    lst_value <- bt / (1 + (lambda * bt) / rho * log(emis))
    lst_value_celsius <- lst_value - 273.15  # Convert from Kelvin to Celsius
    return(lst_value_celsius)
  })

  # Plot LST
  terra::plot(lst, main = "Land Surface Temperature (LST) in degrees Celsius for 2014")

  # Save the output rasters
  terra::writeRaster(lst, paste0(output_dir, "/LandSurfaceTemperature_2014.tif"), overwrite = TRUE)
  terra::writeRaster(ndvi, paste0(output_dir, "/NDVI_2014.tif"), overwrite = TRUE)
}

# Example of calling the function
LSTfirst_2014(
  work_dir = "E:/EAGLE/R_programming/LULC_LST/Data_2014",
  shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/Greater_Asmara_Shapefile/Asmara.shp",
  output_dir = "E:/EAGLE/R_programming/LULC_LST/Data_2014/LST_2014"
)
