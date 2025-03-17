#' LULC vs LST Analysis Function
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
#'@examples
#' LULCvsLSTfirst(LST_file = "E:/EAGLE/R_programming/LULC_LST/Data_2024/LST_2024/LandSurfaceTemeprature_2024.tif",
#'                Classified_file = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_Classification_2024_discrete.tif",
#'                output_dir = "E:/EAGLE/R_programming/LULC_LST/Data_2024")


LULCvsLSTfirst <- function(LST_file, Classified_file, output_dir = NULL) {

  # Set the working directory if a path is provided
  # This step changes the current working directory to `output_dir` if it's not NULL
  if (!is.null(output_dir)) {
    setwd(output_dir)  # Set working directory
  }

  # Load the raster files using the terra package
  # LST raster contains the land surface temperature values
  LST <- terra::rast(LST_file)  # Load LST raster

  # Classified raster represents the land use/land cover classification
  Classified_Raster <- terra::rast(Classified_file)  # Load classified raster

  # Resample the LST raster to match the resolution and extent of the Classified_Raster
  # This ensures that the two rasters align spatially for further analysis
  LST_resampled <- terra::resample(LST, Classified_Raster, method = "bilinear")  # Resample LST to match the classification raster

  # Extract values from the LST and Classified rasters
  LST_values <- terra::values(LST_resampled)  # Extract LST values from the resampled raster
  Class_values <- terra::values(Classified_Raster)  # Extract land cover class values

  # Remove NA values from the extracted data to ensure the analysis is performed on valid data points
  valid_data <- na.omit(data.frame(LST = LST_values, Class = Class_values))  # Remove NA values

  # Rename columns to make them clearer for analysis
  colnames(valid_data) <- c("LST", "Class")  # Rename columns to "LST" and "Class"

  # Aggregate the LST data by land cover class and calculate the mean LST for each class
  class_means <- aggregate(LST ~ Class, data = valid_data, FUN = mean)  # Calculate mean LST by class

  # Print the mean LST for each land cover class
  print(class_means)  # Display class means

  # Create a boxplot to visualize the distribution of LST for each land cover class
  boxplot <- ggplot2::ggplot(valid_data, ggplot2::aes(x = factor(Class), y = LST)) +
    ggplot2::geom_boxplot(fill = "skyblue", color = "black") +  # Create boxplot with customized colors
    ggplot2::labs(title = "LST by Land Use/Land Cover Class",  # Title of the plot
                  x = "Land Use/Land Cover Class",  # Label for the x-axis
                  y = "Land Surface Temperature (LST)") +  # Label for the y-axis
    ggplot2::theme_minimal()  # Use minimal theme for the plot

  # Print the boxplot to the console
  print(boxplot)  # Display the boxplot

  # Perform a one-way ANOVA to check for significant differences in LST across land cover classes
  # ANOVA tests whether the means of LST are significantly different between classes
  anova_result <- stats::aov(LST ~ factor(Class), data = valid_data)  # Perform ANOVA

  # Print the summary of the ANOVA test results
  print("ANOVA Result:")  # Display the text "ANOVA Result:"
  print(summary(anova_result))  # Display ANOVA summary

  # Perform a linear regression to model LST as a function of land cover class
  # This checks if LST can be predicted by the land cover class variable
  lm_model <- stats::lm(LST ~ factor(Class), data = valid_data)  # Fit linear model

  # Print the summary of the linear regression model
  print("Linear Regression Model:")  # Display the text "Linear Regression Model:"
  print(summary(lm_model))  # Display linear regression summary

  # Return a list containing the class means, ANOVA results, and linear regression model summary
  return(list(class_means = class_means, anova = summary(anova_result), lm_summary = summary(lm_model)))  # Return results
}

# Example usage:

# Define the paths to  LST and Classified rasters
LST_file <- "E:/EAGLE/R_programming/LULC_LST/Data_2024/LST_2024/LandSurfaceTemeprature_2024.tif"
Classified_file <- "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_Classification_2024_discrete.tif"

# Optionally, set the working directory (change this as needed)
output_dir <- "E:/EAGLE/R_programming/LULC_LST/Data_2024"

# Call the function to perform the analysis
results <- LULCvsLSTfirst(LST_file, Classified_file, output_dir)

# Print the results, particularly the class means of LST
print(results$class_means)  # Display class means from the function's result
