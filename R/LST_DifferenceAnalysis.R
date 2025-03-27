#' LST Difference Analysis and Visualization
#'
#' This function performs analysis on the Land Surface Temperature (LST) difference
#' between two years (2014 and 2024), visualizes the difference, identifies significant
#' differences, and calculates summary statistics.
#'
#' @param lst_2014_path A string specifying the file path of the LST raster for the year 2014.
#' @param lst_2024_path A string specifying the file path of the LST raster for the year 2024.
#' @param asmara_shapefile_path A string specifying the file path of the Asmara shapefile.
#' @param threshold A numeric value for the threshold to identify significant differences.
#'        Differences below this threshold are considered similar and set to NA.
#' @param plot_diff A logical value indicating whether to plot the LST difference. Default is TRUE.
#' @param plot_significant_diff A logical value indicating whether to plot significant LST differences. Default is TRUE.
#' @param save_plot A logical value indicating whether to save the plots as PNG files. Default is FALSE.
#' @param plot_filename_diff A string specifying the file name to save the LST difference plot if `save_plot` is TRUE.
#' @param plot_filename_significant_diff A string specifying the file name to save the significant LST difference plot if `save_plot` is TRUE.
#'
#' @returns A list containing summary statistics for the LST difference, along with the data frames for the LST differences and significant differences.
#'
#' @import ggplot2
#' @import terra
#' @import sf
#'
#' @export
#'
#' @examples
#' lst_analysis_results <- LST_DifferenceAnalysis(
#'   lst_2014_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/LST_2014/LandSurfaceTemeprature_2014.tif",
#'   lst_2024_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/LST_2024/LandSurfaceTemeprature_2024.tif",
#'   asmara_shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/Greater_Asmara_Shapefile/Asmara.shp",
#'   threshold = 0.5,
#'   plot_diff = TRUE,
#'   plot_significant_diff = TRUE,
#'   save_plot = TRUE,
#'   plot_filename_diff = "lst_diff_map.png",
#'   plot_filename_significant_diff = "lst_significant_diff_map.png"
#' )
LST_DifferenceAnalysis <- function(lst_2014_path, lst_2024_path, asmara_shapefile_path,
                                   threshold = 0.5, plot_diff = TRUE, plot_significant_diff = TRUE,
                                   save_plot = FALSE, plot_filename_diff = "lst_diff_map.png",
                                   plot_filename_significant_diff = "lst_significant_diff_map.png") {

  # Load the LST data for 2014 and 2024
  LST_2014 <- terra::rast(lst_2014_path)
  LST_2024 <- terra::rast(lst_2024_path)

  # Load the Asmara shapefile
  Asmara <- sf::st_read(asmara_shapefile_path)

  # Calculate the difference between 2014 and 2024 LST
  LST_diff <- LST_2024 - LST_2014

  # Mask the LST difference using the Asmara shapefile
  LST_diff_masked <- terra::mask(LST_diff, Asmara)

  # Convert the masked LST difference raster to a data frame
  LST_diff_df <- as.data.frame(LST_diff_masked, xy = TRUE, na.rm = TRUE)

  # Plot the LST difference
  if (plot_diff) {
    ggplot2::ggplot(LST_diff_df, ggplot2::aes(x = x, y = y, fill = lyr.1)) +
      ggplot2::geom_tile() +
      ggplot2::scale_fill_gradientn(colors = rev(terrain.colors(100)), na.value = "transparent") +
      ggplot2::coord_fixed() +  # Maintain aspect ratio
      ggplot2::labs(title = "Difference in LST (2024 - 2014)", fill = "LST Difference") +
      ggplot2::theme_minimal() +
      ggplot2::theme(legend.position = "bottom") -> plot_diff

    print(plot_diff)

    # Optionally save the LST difference plot as a PNG file
    if (save_plot) {
      ggplot2::ggsave(plot_filename_diff, plot = plot_diff, width = 10, height = 8, units = "in", dpi = 300)
    }
  }

  # Identify areas with minimal difference (similar LST)
  LST_similar <- LST_diff
  LST_similar[LST_similar < threshold & LST_similar > -threshold] <- NA  # Set similarities to NA

  # Mask the LST similar areas
  LST_similar_masked <- terra::mask(LST_similar, Asmara)

  # Convert the masked LST similar raster to a data frame
  LST_similar_df <- as.data.frame(LST_similar_masked, xy = TRUE, na.rm = TRUE)

  # Plot significant LST differences
  if (plot_significant_diff) {
    ggplot2::ggplot(LST_similar_df, ggplot2::aes(x = x, y = y, fill = lyr.1)) +
      ggplot2::geom_tile() +
      ggplot2::scale_fill_gradientn(colors = rev(heat.colors(100)), na.value = "transparent") +
      ggplot2::coord_fixed() +  # Maintain aspect ratio
      ggplot2::labs(title = "Areas with Significant LST Difference", fill = "LST Difference") +
      ggplot2::theme_minimal() +
      ggplot2::theme(legend.position = "bottom") -> plot_significant_diff

    print(plot_significant_diff)

    # Optionally save the significant LST difference plot as a PNG file
    if (save_plot) {
      ggplot2::ggsave(plot_filename_significant_diff, plot = plot_significant_diff, width = 10, height = 8, units = "in", dpi = 300)
    }
  }

  # Calculate summary statistics for the LST difference raster
  mean_diff <- terra::global(LST_diff, fun = mean, na.rm = TRUE)
  median_diff <- terra::global(LST_diff, fun = median, na.rm = TRUE)
  sd_diff <- terra::global(LST_diff, fun = sd, na.rm = TRUE)

  # Extract the numeric value from the result of global()
  mean_diff_value <- unlist(mean_diff)
  median_diff_value <- unlist(median_diff)
  sd_diff_value <- unlist(sd_diff)

  # Print the statistics
  cat("Mean Difference: ", mean_diff_value, "\n")
  cat("Median Difference: ", median_diff_value, "\n")
  cat("Standard Deviation of Difference: ", sd_diff_value, "\n")

  # Return the results (summary statistics and data frames)
  return(list(
    mean_diff = mean_diff_value,
    median_diff = median_diff_value,
    sd_diff = sd_diff_value,
    LST_diff_df = LST_diff_df,
    LST_similar_df = LST_similar_df
  ))
}

# Example usage of the function
lst_analysis_results <- LST_DifferenceAnalysis(
  lst_2014_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/LST_2014/LandSurfaceTemeprature_2014.tif",
  lst_2024_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/LST_2024/LandSurfaceTemeprature_2024.tif",
  asmara_shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/Greater_Asmara_Shapefile/Asmara.shp",
  threshold = 0.5,
  plot_diff = TRUE,  # Set to TRUE to plot the LST difference
  plot_significant_diff = TRUE,  # Set to TRUE to plot significant LST differences
  save_plot = TRUE,  # Set to TRUE to save the plots as PNG files
  plot_filename_diff = "lst_diff_map.png",  # The name of the file to save the LST difference plot
  plot_filename_significant_diff = "lst_significant_diff_map.png"  # The name of the file to save the significant LST difference plot
)
