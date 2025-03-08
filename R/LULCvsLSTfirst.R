LULCvsLSTfirst <- function(LST_file, Classified_file, output_dir = NULL) {


  # Set the working directory (if specified)
  if (!is.null(output_dir)) {
    setwd(output_dir)
  }

  # Load the rasters
  LST <- terra::rast(LST_file)
  Classified_Raster <- terra::rast(Classified_file)

  # Resample the LST raster to match the Classified_Raster
  LST_resampled <- terra::resample(LST, Classified_Raster, method = "bilinear")

  # Extract values from both rasters
  LST_values <- terra::values(LST_resampled)
  Class_values <- terra::values(Classified_Raster)

  # Remove NA values
  valid_data <- na.omit(data.frame(LST = LST_values, Class = Class_values))

  # Rename columns for clarity
  colnames(valid_data) <- c("LST", "Class")

  # Aggregate LST by Class
  class_means <- aggregate(LST ~ Class, data = valid_data, FUN = mean)

  # Print the mean LST for each class
  print(class_means)

  # Create a boxplot of LST by land use class
  boxplot <- ggplot2::ggplot(valid_data, ggplot2::aes(x = factor(Class), y = LST)) +
    ggplot2::geom_boxplot(fill = "skyblue", color = "black") +
    ggplot2::labs(title = "LST by Land Use/Land Cover Class",
                  x = "Land Use/Land Cover Class",
                  y = "Land Surface Temperature (LST)") +
    ggplot2::theme_minimal()

  # Print the boxplot
  print(boxplot)

  # Perform one-way ANOVA to check for significant differences in LST across the classes
  anova_result <- aov(LST ~ factor(Class), data = valid_data)

  # Print the summary of the ANOVA
  print("ANOVA Result:")
  print(summary(anova_result))

  # Perform linear regression (LST as a function of Class)
  lm_model <- lm(LST ~ factor(Class), data = valid_data)

  # Print the summary of the linear model
  print("Linear Regression Model:")
  print(summary(lm_model))

  # Return the class means, ANOVA results, and regression model
  return(list(class_means = class_means, anova = summary(anova_result), lm_summary = summary(lm_model)))
}



# Define the paths to your LST and Classified rasters
LST_file <- "E:/EAGLE/R_programming/LULC_LST/Data_2024/LST_2024/LandSurfaceTemeprature_2024.tif"
Classified_file <- "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_Classification_2024_discrete.tif"

# Optionally, set the working directory
output_dir <- "E:/EAGLE/R_programming/LULC_LST/Data_2024"

# Call the function
results <- LULCvsLSTfirst(LST_file, Classified_file, output_dir)

# Print the results
print(results$class_means)
