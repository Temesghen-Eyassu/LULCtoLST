#' Analyze the Relationship Between LULC Change and LST Difference
#'
#' This function analyzes the relationship between land use/land cover (LULC) change
#' and land surface temperature (LST) difference by extracting values from LULC and LST
#' raster datasets, performing correlation and regression analysis, and visualizing the relationship.
#'
#' @param lulc_change_path A string specifying the file path of the LULC change raster map.
#' @param lst_difference_path A string specifying the file path of the LST difference raster map.
#' @param output_csv_path A string specifying the file path where the combined data should be saved as CSV.
#' @param plot_relationship A logical value indicating whether to plot the relationship between LULC change and LST difference. Default is TRUE.
#'
#' @returns A list containing the correlation value, linear model summary, and the combined data.
#'
#' @import terra
#' @import ggplot2
#' @import dplyr
#' @import stats
#'
#' @export
#'
#' @examples
#' lulc_lst_analysis <- AnalyzeLULCvsLSTrelationship(
#'   lulc_change_path = "E:/EAGLE/R_programming/LULC_LST/Change_Detection/ChangeDetection.tif",
#'   lst_difference_path = "E:/EAGLE/R_programming/LULC_LST/LST_Difference/LSTDifference.tif",
#'   output_csv_path = "E:/EAGLE/R_programming/LULC_LST/LULCvsLST/combined_data.csv",
#'   plot_relationship = TRUE
#' )
#' print(lulc_lst_analysis)

AnalyzeLULCvsLSTrelationship <- function(lulc_change_path, lst_difference_path, output_csv_path, plot_relationship = TRUE) {

  # Step 1: Load the LULC Change and LST Difference raster datasets
  LULC_Change <- terra::rast(lulc_change_path)  # Load the LULC change raster
  LST_Difference <- terra::rast(lst_difference_path)  # Load the LST difference raster

  # Step 2: Convert the LULC raster to a data frame with coordinates
  coords <- as.data.frame(LULC_Change, xy = TRUE)

  # Step 3: Ensure coords has an 'ID' column
  if (!"ID" %in% colnames(coords)) {
    coords$ID <- 1:nrow(coords)  # Assign an ID column if it doesn't exist
    print("ID column added to coords.")
  }

  # Step 4: Extract values for both rasters based on the coordinates
  lulc_values <- terra::extract(LULC_Change, coords[, c("x", "y")])
  lst_values <- terra::extract(LST_Difference, coords[, c("x", "y")])

  # Step 5: Check if extracted values are dataframes, and extract the relevant columns
  if (is.data.frame(lulc_values)) {
    lulc_values <- lulc_values$class  # Extract the 'class' column from LULC
  }
  if (is.data.frame(lst_values)) {
    lst_values <- lst_values$lyr.1  # Extract the 'lyr.1' column from LST
  }

  # Step 6: Combine extracted values into a data frame
  combined_data <- data.frame(ID = coords$ID, class = lulc_values, lyr.1 = lst_values)

  # Step 7: Map LULC Change values to categories with the correct labels
  combined_data$LULC_Change_Category <- factor(combined_data$class,
                                               levels = c(11, 12, 13, 14, 15, 21, 22, 23, 24, 31, 32, 33, 34, 35, 41, 42, 43, 44, 45, 51, 52, 53, 54, 55),
                                               labels = c("Built_Up_Area", "Water_Bodies", "Agricultural_Area", "Natural_Vegetation", "Open_Area",
                                                          "Built_Up_Area", "Water_Bodies", "Agricultural_Area", "Natural_Vegetation", "Built_Up_Area",
                                                          "Water_Bodies", "Agricultural_Area", "Natural_Vegetation", "Open_Area", "Built_Up_Area",
                                                          "Water_Bodies", "Agricultural_Area", "Natural_Vegetation", "Open_Area", "Built_Up_Area",
                                                          "Water_Bodies", "Agricultural_Area", "Natural_Vegetation", "Open_Area"))

  # Step 8: Remove any rows with NA values
  combined_data <- na.omit(combined_data)

  # Step 9: Perform correlation analysis between LULC class and LST difference
  correlation <- cor(combined_data$class, combined_data$lyr.1, method = "pearson")
  print(paste("Pearson correlation coefficient: ", correlation))

  # Step 10: Fit a linear regression model
  lm_model <- lm(lyr.1 ~ class, data = combined_data)
  print(summary(lm_model))  # Print the linear model summary

  # Step 11: Visualize the relationship using ggplot2 with custom colors
  if (plot_relationship) {
    plot <- ggplot2::ggplot(combined_data, ggplot2::aes(x = class, y = lyr.1, color = LULC_Change_Category)) +
      ggplot2::geom_point(alpha = 0.5) +
      ggplot2::labs(title = "Relationship Between LULC Change and LST Difference (2014-2024)",
                    x = "LULC Change", y = "LST Difference (°C)") +
      ggplot2::theme_minimal() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1)) +
      ggplot2::scale_color_manual(values = c(
        "Built_Up_Area" = "red",
        "Water_Bodies" = "blue",
        "Agricultural_Area" = "yellow",
        "Natural_Vegetation" = "green",
        "Open_Area" = "gray"
      ))
    print(plot)
  }

  # Step 12: Check for any extreme values in LST difference
  summary(combined_data$lyr.1)

  # Step 13: Save the combined data as a CSV file
  write.csv(combined_data, output_csv_path, row.names = FALSE)
  print("Combined data has been saved to CSV.")

  # Return a list containing the correlation, model summary, and the combined data
  return(list(
    correlation = correlation,
    lm_model_summary = summary(lm_model),
    combined_data = combined_data
  ))
}

# Example usage of the function
lulc_lst_analysis <- AnalyzeLULCvsLSTrelationship(
  lulc_change_path = "E:/EAGLE/R_programming/LULC_LST/Change_Detection/ChangeDetection.tif",
  lst_difference_path = "E:/EAGLE/R_programming/LULC_LST/LST_Difference/LSTDifference.tif",
  output_csv_path = "E:/EAGLE/R_programming/LULC_LST/LULCvsLST/combined_data.csv",
  plot_relationship = TRUE  # Set to TRUE to plot the relationship
)

# Print the analysis results
print(lulc_lst_analysis)
