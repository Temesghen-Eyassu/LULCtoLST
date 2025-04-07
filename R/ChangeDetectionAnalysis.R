#' Change Detection Analysis and Area Calculation
#'
#' This function performs change detection analysis between two classified raster maps
#' (for the years 2014 and 2024), generates a change detection map, calculates the
#' area change for each class, and optionally plots the results.
#'
#' @param classified_2014_path A string specifying the file path of the classified
#' raster map for the year 2014.
#' @param classified_2024_path A string specifying the file path of the classified
#' raster map for the year 2024.
#' @param plot_area_change A logical value indicating whether to plot the area change
#' by class. Default is TRUE.
#' @param save_plot A logical value indicating whether to save the generated change
#' detection map plot as a PNG file. Default is FALSE.
#' @param plot_filename A string specifying the file name to save the plot, if
#' `save_plot` is TRUE. Default is "change_detection_map.png".
#'
#' @returns A data frame with the area (in square kilometers) for each change class
#' detected in the analysis.
#'
#' @import ggplot2
#' @import terra
#'
#' @export
#'
#' @examples
#' change_area_results <- ChangeDetectionAnalysis(
#'   classified_2014_path="E:/EAGLE/R_programming/LULC_LST/Data_2014/Masked_Asmara_Classification_2014.tif",
#'   classified_2024_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_Classification_2024_discrete.tif",
#'   plot_area_change = TRUE,
#'   save_plot = TRUE,
#'   plot_filename = "change_detection_map.png"
#' )
ChangeDetectionAnalysis <- function(classified_2014_path, classified_2024_path, plot_area_change = TRUE, save_plot = FALSE, plot_filename = "change_detection_map.png") {

  # Load the classified raster files
  classified_2014 <- terra::rast(classified_2014_path)
  classified_2024 <- terra::rast(classified_2024_path)

  # Copy the classified maps to preserve original data
  class_2014_copy <- classified_2014
  class_2024_copy <- classified_2024

  # Multiply nominal values by 10 (if necessary for your analysis)
  class_2014_copy <- class_2014_copy * 10

  # Perform change detection by adding the two raster maps
  change_map_2014_2024 <- class_2014_copy + class_2024_copy

  # Define legend labels for change detection classes
  legend_labels_2014_2024 <- c(
    "11" = "Built Up Area to Built Up Area (no change)",
    "12" = "Built Up Area to Water Bodies",
    "13" = "Built Up Area to Agricultural Area",
    "14" = "Built Up Area to Natural Vegetation",
    "15" = "Built Up Area to Open Area",
    "21" = "Water Bodies to Built Up Area",
    "22" = "Water Bodies to Water Bodies (no change)",
    "23" = "Water Bodies to Agricultural Area",
    "24" = "Water Bodies to Natural Vegetation",
    "25" = "Water Bodies to Open Area",
    "31" = "Agricultural Area to Built Up Area",
    "32" = "Agricultural Area to Water Bodies",
    "33" = "Agricultural Area to Agricultural Area (no change)",
    "34" = "Agricultural Area to Natural Vegetation",
    "35" = "Agricultural Area to Open Area",
    "41" = "Natural Vegetation to Built Up Area",
    "42" = "Natural Vegetation to Water Bodies",
    "43" = "Natural Vegetation to Agricultural Area",
    "44" = "Natural Vegetation to Natural Vegetation (no change)",
    "45" = "Natural Vegetation to Open Area",
    "51" = "Open Area to Natural Vegetation",
    "52" = "Open Area to Water Bodies",
    "53" = "Open Area to Agricultural Area",
    "54" = "Open Area to Natural Vegetation",
    "55" = "Open Area to Open Area (no change)"
  )

  # Map custom colors to the legend labels
  colors_2014_2024 <- c(
    "11" = "red",
    "12" = "cyan",
    "13" = "lightyellow",
    "14" = "lightgreen",
    "15" = "lightgray",
    "21" = "red",
    "22" = "blue",
    "23" = "orange",
    "24" = "lightgreen",
    "25" = "black",
    "31" = "brown",
    "32" = "skyblue",
    "33" = "yellow",
    "34" = "lightgreen",
    "35" = "lightgray",
    "41" = "lightcoral",
    "42" = "lightblue",
    "43" = "yellow",
    "44" = "green",
    "45" = "darkgray",
    "51" = "brown",
    "52" = "darkblue",
    "53" = "orange",
    "54" = "yellowgreen",
    "55" = "gray"
  )

  # Convert the change detection map to a data frame for ggplot
  change_map_2014_2024_df <- as.data.frame(change_map_2014_2024, xy = TRUE)
  colnames(change_map_2014_2024_df) <- c("x", "y", "change_class")
  change_map_2014_2024_df$change_class <- as.factor(change_map_2014_2024_df$change_class)

  # Plot the change detection map (raster plot) using ggplot2
  plot <- ggplot2::ggplot(change_map_2014_2024_df, ggplot2::aes(x = x, y = y, fill = change_class)) +
    ggplot2::geom_raster() +
    ggplot2::scale_fill_manual(
      values = colors_2014_2024,
      labels = legend_labels_2014_2024,
      name = "Change Classes"
    ) +
    ggplot2::coord_equal() +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "bottom") +
    ggplot2::labs(
      title = "Change Detection Map: 2014 to 2024",
      x = "Longitude",
      y = "Latitude"
    )

  # Display the plot
  print(plot)

  # Optionally save the plot as a PNG file
  if (save_plot) {
    ggplot2::ggsave(plot_filename, plot = plot, width = 10, height = 8, units = "in", dpi = 300)
  }

  # --- AREAL CHANGE CALCULATION --- #
  # Get the resolution of the raster to calculate area (in square meters)
  res_x <- terra::res(change_map_2014_2024)[1]
  res_y <- terra::res(change_map_2014_2024)[2]

  # Calculate the pixel area in square meters
  pixel_area_m2 <- res_x * res_y

  # Convert pixel area to square kilometers (1 km² = 1,000,000 m²)
  pixel_area_km2 <- pixel_area_m2 / 1e6

  # Count the occurrences of each unique change class (i.e., how many pixels correspond to each class) using Base R
  change_area_count <- table(change_map_2014_2024_df$change_class)

  # Convert the table into a data frame for further calculation
  change_area_count_df <- data.frame(
    change_class = names(change_area_count),
    pixel_count = as.numeric(change_area_count)
  )

  # Calculate the area in square kilometers
  change_area_count_df$area_km2 <- change_area_count_df$pixel_count * pixel_area_km2

  # View the resulting areas in square kilometers for each class
  print(change_area_count_df)

  # Optionally plot the area change by class (Barplot)
  if (plot_area_change) {
    barplot(change_area_count_df$area_km2, names.arg = change_area_count_df$change_class,
            col = colors_2014_2024[change_area_count_df$change_class], las = 2,
            main = "Area Change by Class (2014 to 2024)",
            ylab = "Area (km²)", xlab = "Change Class")
  }

  # Return the results (change map, area calculation table)
  return(change_area_count_df)
}

# Example usage of the function
change_area_results <- ChangeDetectionAnalysis(
  "E:/EAGLE/R_programming/LULC_LST/Data_2014/Masked_Asmara_Classification_2014.tif",
  "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_Classification_2024_discrete.tif",
  plot_area_change = TRUE,  # Set to TRUE to plot area change by class
  save_plot = TRUE,         # Set to TRUE to save the change detection map as a PNG file
  plot_filename = "change_detection_map.png"  # The name of the file to save

)


