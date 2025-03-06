# Define the function
LinearRegressionfirst<- function(LST_path, NDVI_path, output_plot_path = NULL) {

  # Load the rasters
  LST_2024 <- terra::rast(LST_path)
  NDVI_2024 <-terra::rast(NDVI_path)

  # Ensure the rasters have the same extent and resolution (align them if necessary)
  NDVI_2024 <- terra::resample(NDVI_2024, LST_2024, method = "bilinear")

  # Extract raster values and convert to data frame
  LST_values <- terra::values(LST_2024)
  NDVI_values <- terra::values(NDVI_2024)

  # Remove NA values from both LST_values and NDVI_values
  data <- data.frame(LST = LST_values, NDVI = NDVI_values)

  # Remove rows with NA values (for both LST and NDVI)
  data <- na.omit(data)

  # Ensure columns are named correctly (in case column names are not as expected)
  colnames(data) <- c("LST", "NDVI")

  # Perform linear regression between LST and NDVI
  lm_model <- lm(LST ~ NDVI, data = data)

  # Print the summary of the linear regression model
  print(summary(lm_model))

  # Extract the R-squared value from the model
  r_squared <- summary(lm_model)$r.squared

  # Create the plot
  plot <- ggplot2::ggplot(data, ggplot2::aes(x = NDVI, y = LST)) +
    ggplot2::geom_point(color = "blue", alpha = 0.5) +  # scatter plot of data points
    ggplot2::geom_smooth(method = "lm", color = "red") +  # linear regression line
    ggplot2::labs(title = paste("Linear Regression between LST and NDVI\nR-squared =", round(r_squared, 4)),
                  x = "NDVI",
                  y = "Land Surface Temperature (LST)") +
    ggplot2::theme_minimal()

  # Optionally save the plot
  if (!is.null(output_plot_path)) {
    ggplot2::ggsave(output_plot_path, plot)
  }

  # Return the plot and the regression model summary
  return(list(plot = plot, lm_model = lm_model))
}

# Example usage of the function
result <- Linear_Regressionfirst(
  LST_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/LST_2024/LandSurfaceTemeprature_2024.tif",
  NDVI_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/LST_2024/NDVI_2024.tif",
  output_plot_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/LST_NDVI_regression_plot.png"
)

# Access the model summary
summary(result$lm_model)

# Access the plot
print(result$plot)
