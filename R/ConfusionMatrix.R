#' Confusion Matrix Function for Validation of Classified Raster
#'
#' This function computes a confusion matrix by comparing the predicted values
#' from a classified raster with the actual values from a validation shapefile.
#' It also computes the overall accuracy and Kappa coefficient based on the
#' confusion matrix.
#'
#' @param validation_shapefile_path A character string representing the path
#' to the shapefile containing the ground truth validation data. This shapefile
#' should have polygon features with an associated class label (id).
#'
#' @param classified_raster_path A character string representing the path to
#' the classified raster file. This raster should contain pixel values representing
#' the predicted class for each pixel.
#'
#' @returns A confusion matrix object with various metrics, including accuracy and Kappa.
#' The confusion matrix is printed to the console, and accuracy and Kappa values are also displayed.
#'
#' @export
#'
#' @examples
#' # Example usage of the function
#' ConfusionMatrix(
#'   validation_shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/Validation_2014/Validation_2014/Validation_2014.shp",
#'   classified_raster_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/Masked_Asmara_Classification_2014.tif"
#' )
#'
ConfusionMatrix <- function(validation_shapefile_path, classified_raster_path) {

  # Check if the function is being called
  print("Function is being called...")

  # Set the working directory (optional, adjust as needed)
  # This directory should contain your data files or it can be customized
  setwd("E:/EAGLE/R_programming/LULC_LST/Data_2014")

  # Load the validation data (shapefile with ground truth)
  print("Loading validation data...")
  validation_2014 <- sf::st_read(validation_shapefile_path)

  # Check if validation data is loaded
  if (is.null(validation_2014)) {
    print("Validation data not loaded. Exiting function.")
    return()
  }

  # Load the classified raster
  print("Loading classified raster...")
  classified_raster <- terra::rast(classified_raster_path)

  # Extract centroids from the validation polygons
  print("Extracting centroids from validation polygons...")
  validation_2014$coords <- sf::st_centroid(validation_2014$geometry)
  validation_2014$coords <- sf::st_coordinates(validation_2014$coords)

  # Extract the raster values at the validation centroids
  print("Extracting raster values at validation centroids...")
  validation_raster_values <- terra::extract(classified_raster, validation_2014$coords)

  # Check for any missing (NA) values in the raster extraction
  print("Removing NA values from raster extraction...")
  validation_raster_values <- validation_raster_values[!is.na(validation_raster_values[, 1]), ]

  # Combine raster values with class labels (id from validation data)
  validation_data <- data.frame(validation_raster_values, id = validation_2014$id)

  # Ensure that the values are numeric
  print("Converting raster values to numeric...")
  validation_raster_values_numeric <- as.numeric(as.character(validation_raster_values))

  # Combine predicted values and actual values
  validation_data$predicted <- validation_raster_values_numeric
  validation_data$actual <- validation_data$id

  # Check that the lengths of predicted and actual match
  if (length(validation_data$predicted) == length(validation_data$actual)) {

    print("Creating confusion matrix...")
    # Use caret package to compute confusion matrix
    confusion_matrix <- caret::confusionMatrix(factor(validation_data$predicted), factor(validation_data$actual))

    # Print the confusion matrix
    print("Confusion Matrix:")
    print(confusion_matrix)

    # Access the overall accuracy
    overall_accuracy <- confusion_matrix$overall['Accuracy']
    print(paste("Overall Accuracy: ", overall_accuracy))

    # Access the Kappa coefficient
    kappa_value <- confusion_matrix$overall['Kappa']
    print(paste("Kappa Coefficient: ", kappa_value))

  } else {
    print("The lengths of predicted and actual values do not match. Please check your data.")
  }
}

# Test the function call with sample file paths
ConfusionMatrix(
  validation_shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/Validation_2014/Validation_2014/Validation_2014.shp",
  classified_raster_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/Masked_Asmara_Classification_2014.tif"
)



