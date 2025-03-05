#' Confusion Matrix Calculation for Classified Raster
#'
#' This function calculates the confusion matrix for the classification results
#' of a raster dataset, using validation data from a shapefile. The function
#' compares the predicted classification from a raster with the ground truth
#' data (validation shapefile) and calculates overall accuracy and Kappa coefficient.
#'
#' @param raster_path Character string. The file path to the raster that will
#'   be used for analysis (the masked raster).
#' @param validation_shapefile_path Character string. The file path to the shapefile
#'   containing the ground truth validation data for classification.
#' @param classified_raster_path Character string. The file path to the classified raster
#'   that contains the predicted classification values.
#'
#' @returns A confusion matrix, including overall accuracy and Kappa coefficient.
#'   If the data is incompatible, an error message is printed.
#' @export
#'
#' @examples
#' ConfusionMatrixfirst(
#'   raster_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/masked_Asmara.tif",
#'   validation_shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Validation_Data2024/validation_2024/Validation_2024.shp",
#'   classified_raster_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_Classification_2024_discrete.tif"
#' )
ConfusionMatrixfirst <- function(raster_path, validation_shapefile_path, classified_raster_path) {

  # Print a message to confirm the function is being called
  print("Function is being called...")

  # Set the working directory (optional, adjust as needed)
  setwd("E:/EAGLE/R_programming/LULC_LST/Data_2024")

  # Load the Masked Asmara raster
  print("Loading Masked Asmara raster...")
  masked_Asmara <- terra::rast(raster_path)

  # Check if the raster is loaded successfully
  if (is.null(masked_Asmara)) {
    print("Masked Asmara raster not loaded. Exiting function.")
    return()  # Exit the function if raster is not loaded
  }

  # Load the validation data (shapefile with ground truth)
  print("Loading validation data...")
  validation_2024 <- sf::st_read(validation_shapefile_path)

  # Check if validation data is loaded successfully
  if (is.null(validation_2024)) {
    print("Validation data not loaded. Exiting function.")
    return()  # Exit the function if validation data is not loaded
  }

  # Transform validation data to match the CRS of the raster
  print("Transforming validation data to the same CRS as raster...")
  validation_2024 <- sf::st_transform(validation_2024, terra::crs(masked_Asmara))

  # Load the classified raster (the predicted classification data)
  print("Loading classified raster...")
  classified_raster <- terra::rast(classified_raster_path)

  # Extract centroids of the validation polygons for sampling
  print("Extracting centroids from validation polygons...")
  validation_2024$coords <- sf::st_centroid(validation_2024$geometry)
  validation_2024$coords <- sf::st_coordinates(validation_2024$coords)

  # Extract raster values at the validation centroids
  print("Extracting raster values at validation centroids...")
  validation_raster_values <- terra::extract(classified_raster, validation_2024$coords)

  # Remove NA values (where extraction failed) from the raster values
  print("Removing NA values from raster extraction...")
  validation_raster_values <- validation_raster_values[!is.na(validation_raster_values[, 1]), ]

  # Combine extracted raster values with the class labels from the validation data
  validation_data <- data.frame(validation_raster_values, id = validation_2024$id)

  # Convert the raster values to numeric format for analysis
  print("Converting raster values to numeric...")
  validation_raster_values_numeric <- as.numeric(as.character(validation_raster_values))

  # Add predicted and actual values to the dataset
  validation_data$predicted <- validation_raster_values_numeric
  validation_data$actual <- validation_data$id

  # Ensure that the lengths of predicted and actual values match
  if (length(validation_data$predicted) == length(validation_data$actual)) {

    print("Creating confusion matrix...")
    # Create confusion matrix using caret package
    confusion_matrix <- caret::confusionMatrix(factor(validation_data$predicted), factor(validation_data$actual))

    # Print the confusion matrix
    print("Confusion Matrix:")
    print(confusion_matrix)

    # Access the overall accuracy of the classification
    overall_accuracy <- confusion_matrix$overall['Accuracy']
    print(paste("Overall Accuracy: ", overall_accuracy))

    # Access the Kappa coefficient for agreement measure
    kappa_value <- confusion_matrix$overall['Kappa']
    print(paste("Kappa Coefficient: ", kappa_value))

  } else {
    # Print an error message if predicted and actual values have different lengths
    print("The lengths of predicted and actual values do not match. Please check your data.")
  }
}
