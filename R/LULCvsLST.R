#' LULC vs LST Analysis Function for 2014
#'
#' This function performs a series of analyses comparing Land Surface Temperature (LST)
#' and Land Use/Land Cover (LULC) classes. It includes resampling the LST raster,
#' extracting values from the rasters, calculating mean LST by class, performing an
#' ANOVA test for differences between classes, and fitting a linear regression model.
#' It also creates a boxplot of LST by class.
#'
#' @param LST_file Path to the LST raster file (in .tif format).
#' @param Classified_file Path to the classified raster file (in .tif format).
#' @param output_dir Optional parameter specifying the output directory to set as
#' the working directory. If not provided, the current working directory remains unchanged.
#'
#' @returns A list containing the following elements:
#'   - `class_means`: Data frame with the mean LST for each land cover class.
#'   - `anova`: Summary of the ANOVA test results.
#'   - `lm_summary`: Summary of the linear regression model.
#'
#' @export
#' @examples
#' LULCvsLST(LST_file = "E:/EAGLE/R_programming/LULC_LST/Data_2014/LST_2014/LandSurfaceTemeprature_2014.tif",
#'                Classified_file = "E:/EAGLE/R_programming/LULC_LST/Data_2014/Masked_Asmara_Classification_2014.tif",
#'                output_dir = "E:/EAGLE/R_programming/LULC_LST/Data_2014")

LULCvsLST <- function(LST_file, Classified_file, output_dir = NULL) {

  # Set the working directory if a path is provided
  if (!is.null(output_dir)) {
    setwd(output_dir)  # Set working directory
  }

  # Load the raster files using the terra package
  LST <- terra::rast(LST_file)  # Load LST raster
  Classified_Raster <- terra::rast(Classified_file)  # Load classified raster

  # Resample the LST raster to match the resolution and extent of the Classified_Raster
  LST_resampled <- terra::resample(LST, Classified_Raster, method = "bilinear")  # Resample LST to match the classification raster

  # Extract values from the LST and Classified rasters
  LST_values <- terra::values(LST_resampled)  # Extract LST values
  Class_values <- terra::values(Classified_Raster)  # Extract land cover class values

  # Remove NA values
  valid_data <- na.omit(data.frame(LST = LST_values, Class = Class_values))

  # Rename columns
  colnames(valid_data) <- c("LST", "Class")  # Rename columns

  # Aggregate the LST data by land cover class and calculate the mean LST for each class
  class_means <- aggregate(LST ~ Class, data = valid_data, FUN = mean)

  # Print the mean LST for each land cover class
  print(class_means)

  # Create a boxplot to visualize the distribution of LST for each land cover class
  boxplot <- ggplot2::ggplot(valid_data, ggplot2::aes(x = factor(Class), y = LST)) +
    ggplot2::geom_boxplot(fill = "skyblue", color = "black") +
    ggplot2::labs(title = "LST by Land Use/Land Cover Class for 2014",
                  x = "Land Use/Land Cover Class",
                  y = "Land Surface Temperature (LST)") +
    ggplot2::theme_minimal()

  # Print the boxplot
  print(boxplot)

  # Perform a one-way ANOVA to check for significant differences in LST across land cover classes
  anova_result <- stats::aov(LST ~ factor(Class), data = valid_data)
  print("ANOVA Result:")
  print(summary(anova_result))

  # Perform a linear regression to model LST as a function of land cover class
  lm_model <- stats::lm(LST ~ factor(Class), data = valid_data)
  print("Linear Regression Model:")
  print(summary(lm_model))

  # Return the results
  return(list(class_means = class_means, anova = summary(anova_result), lm_summary = summary(lm_model)))
}

# Example usage for 2014:

# Define the paths to  2014 LST and Classified rasters
LST_file_2014 <- "E:/EAGLE/R_programming/LULC_LST/Data_2014/LST_2014/LandSurfaceTemeprature_2014.tif"
Classified_file_2014 <- "E:/EAGLE/R_programming/LULC_LST/Data_2014/Masked_Asmara_Classification_2014.tif"

# Optionally, set the working directory (change this as needed)
output_dir_2014 <- "E:/EAGLE/R_programming/LULC_LST/Data_2014"

# Call the function to perform the analysis for 2014
results_2014 <- LULCvsLST(LST_file_2014, Classified_file_2014, output_dir_2014)

# Print the results, particularly the class means of LST
print(results_2014$class_means)
