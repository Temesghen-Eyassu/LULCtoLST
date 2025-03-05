ConfusionMatrixfirst <- function(raster_path, validation_shapefile_path, classified_raster_path) {

  # Check if the function is being called
  print("Function is being called...")

  # Set the working directory (optional, adjust as needed)
  setwd("E:/EAGLE/R_programming/LULC_LST/Data_2024")

  # Load the Masked Asmara raster
  print("Loading Masked Asmara raster...")
  masked_Asmara <- terra::rast(raster_path)

  # Check if the raster is loaded
  if (is.null(masked_Asmara)) {
    print("Masked Asmara raster not loaded. Exiting function.")
    return()
  }

  # Load the validation data (shapefile with ground truth)
  print("Loading validation data...")
  validation_2024 <- sf::st_read(validation_shapefile_path)

  # Check if validation data is loaded
  if (is.null(validation_2024)) {
    print("Validation data not loaded. Exiting function.")
    return()
  }

  # Ensure validation data is in the same CRS as the raster
  print("Transforming validation data to the same CRS as raster...")
  validation_2024 <- sf::st_transform(validation_2024, terra::crs(masked_Asmara))

  # Load the classified raster
  print("Loading classified raster...")
  classified_raster <- terra::rast(classified_raster_path)

  # Extract centroids from the validation polygons
  print("Extracting centroids from validation polygons...")
  validation_2024$coords <- sf::st_centroid(validation_2024$geometry)
  validation_2024$coords <- sf::st_coordinates(validation_2024$coords)

  # Extract the raster values at the validation centroids
  print("Extracting raster values at validation centroids...")
  validation_raster_values <- terra::extract(classified_raster, validation_2024$coords)

  # Check for any missing (NA) values in the raster extraction
  print("Removing NA values from raster extraction...")
  validation_raster_values <- validation_raster_values[!is.na(validation_raster_values[, 1]), ]

  # Combine raster values with class labels (id from validation data)
  validation_data <- data.frame(validation_raster_values, id = validation_2024$id)

  # Ensure that the values are numeric
  print("Converting raster values to numeric...")
  validation_raster_values_numeric <- as.numeric(as.character(validation_raster_values))

  # Combine predicted values and actual values
  validation_data$predicted <- validation_raster_values_numeric
  validation_data$actual <- validation_data$id

  # Check that the lengths of predicted and actual match
  if (length(validation_data$predicted) == length(validation_data$actual)) {

    print("Creating confusion matrix...")
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

# Test the function call
ConfusionMatrixfirst(
  raster_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/masked_Asmara.tif",
  validation_shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Validation_Data2024/validation_2024/Validation_2024.shp",
  classified_raster_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_Classification_2024_discrete.tif"
)
