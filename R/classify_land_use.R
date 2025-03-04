#' Land Use Land Cover Classification Using Random Forest
#'
#' This function classifies a land use/land cover raster using Random Forest (RF)
#' based on provided training data. It reads a raster and shapefile of training
#' data, extracts spectral values from the raster at the centroids of polygons
#' in the shapefile, and trains a Random Forest model to predict the classes
#' across the raster. The function then saves the classified raster and plots it.
#'
#' @param raster_path A character string specifying the path to the input raster file.
#' @param shapefile_path A character string specifying the path to the input shapefile.
#' @param output_raster_path A character string specifying the path to save the output classified raster.
#'
#' @returns A raster object containing the classified land use/land cover classes.
#' @export
#'
#' @examples
#' classified_raster <- classify_land_use(
#'   raster_path = "path/to/raster.tif",
#'   shapefile_path = "path/to/training_data.shp",
#'   output_raster_path = "path/to/output_classified_raster.tif"
#' )
classify_land_use <- function(raster_path, shapefile_path, output_raster_path) {

  # Load the raster and training data
  masked_raster <- terra::rast(raster_path)
  training_data <- sf::st_read(shapefile_path)

  # Ensure both datasets are in the same CRS
  training_data <- sf::st_transform(training_data, terra::crs(masked_raster))

  # Check if the 'class_name' column exists and extract unique class labels
  if (!"class_name" %in% colnames(training_data)) {
    stop("'class_name' column not found in the shapefile")
  }

  # Convert the 'id' to factor if it's not already
  training_data$id <- as.factor(training_data$id)

  # Extract the coordinates of the centroids of the polygons
  training_data$coords <- sf::st_centroid(training_data$geometry)
  training_data$coords <- sf::st_coordinates(training_data$coords)

  # Extract raster values at the coordinates of the centroids
  raster_values <- terra::extract(masked_raster, training_data$coords)

  # Combine the raster values with the class labels
  training_data_combined <- cbind(raster_values, id = training_data$id)

  # Remove rows with NA values in raster values
  training_data_combined <- na.omit(training_data_combined)

  # Train the Random Forest model
  rf_model <- randomForest::randomForest(id ~ ., data = training_data_combined, ntree = 100)

  # Predict the classes for the entire raster (this will give discrete classes)
  predicted_raster <- terra::predict(masked_raster, rf_model, type = "response")

  # Convert the output into a factor with discrete levels
  predicted_raster_classified <- terra::as.factor(predicted_raster)

  # Save the classified raster
  terra::writeRaster(predicted_raster_classified, output_raster_path, overwrite = TRUE)

  # Plot the classified raster
  terra::plot(predicted_raster_classified, main = "Classified Raster")

  # Return the classified raster object
  return(predicted_raster_classified)
}

#' @examples
#' classified_raster <- classify_land_use(
#'   raster_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_2024.tif",
#'   shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/TrainingData_2025/Training_2024.shp",
#'   output_raster_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_Classification_2024_discrete.tif"
#' )
