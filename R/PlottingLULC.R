#' Title: Plotting and Analyzing LULC Data for 2014
#'
#' @description This function reads a classified raster, processes it, and generates plots and area calculations for LULC (Land Use/Land Cover) data.
#'
#' @param classified_raster_path A character string specifying the path to the classified raster data (e.g., a GeoTIFF file).
#' @param pixel_area_km2 A numeric value representing the area of a single pixel in square kilometers. The default is 0.0009 km² (corresponding to a 30m x 30m pixel).
#'
#' @returns A data frame containing the area (in square kilometers) and percentage for each Land Use/Land Cover class.
#' @export
#'
#' @examples
#' \dontrun{
#' classified_raster_path <- "E:/EAGLE/R_programming/LULC_LST/Data_2014/Masked_Asmara_Classification_2014.tif"
#' PlottingLULC(classified_raster_path)
#' }
PlottingLULC <- function(classified_raster_path, pixel_area_km2 = 0.0009) {

  # Step 1: Load the raster data
  predicted_raster_classified <- terra::rast(classified_raster_path)

  # Step 2: Extract classification values and prepare for plotting
  predicted_raster_classified_df <- as.data.frame(predicted_raster_classified, xy = TRUE)
  colnames(predicted_raster_classified_df) <- c("x", "y", "id_supervised")

  # Step 3: Map the class IDs to class names using case_when
  predicted_raster_classified_df$class_name <- as.factor(dplyr::case_when(
    predicted_raster_classified_df$id_supervised == 1 ~ "Built_Up_Area",
    predicted_raster_classified_df$id_supervised == 2 ~ "Water_Bodies",
    predicted_raster_classified_df$id_supervised == 3 ~ "Agricultural_Area",
    predicted_raster_classified_df$id_supervised == 4 ~ "Natural_Vegetation",
    predicted_raster_classified_df$id_supervised == 5 ~ "Open_Area",
    TRUE ~ NA_character_  # For any unexpected class IDs
  ))

  # Step 4: Reorder class_name factor levels to match the color mapping order
  predicted_raster_classified_df$class_name <- factor(predicted_raster_classified_df$class_name,
                                                      levels = c("Built_Up_Area", "Water_Bodies", "Agricultural_Area",
                                                                 "Natural_Vegetation", "Open_Area"))

  # Step 5: Plot the raster data using ggplot2
  print(
    ggplot2::ggplot(predicted_raster_classified_df, ggplot2::aes(x = x, y = y, fill = class_name)) +
      ggplot2::geom_raster() +
      ggplot2::scale_fill_manual(
        values = c(
          "Built_Up_Area" = "red",
          "Water_Bodies" = "blue",
          "Agricultural_Area" = "yellow",
          "Natural_Vegetation" = "green",
          "Open_Area" = "gray"
        ),
        name = "Land Use / Land Cover",
        labels = c(
          "Built-Up Area",
          "Water Bodies",
          "Agricultural Area",
          "Natural Vegetation",
          "Open Area"
        )
      ) +
      ggplot2::coord_equal() +
      ggplot2::theme_minimal() +
      ggplot2::theme(legend.position = "bottom") +
      ggplot2::labs(
        title = "LULC 2014",
        x = "Longitude",
        y = "Latitude"
      )
  )

  # Step 6: Calculate the area in square kilometers for each class
  class_area_km2 <- table(predicted_raster_classified_df$class_name) * pixel_area_km2

  # Step 7: Prepare data for pie chart and bar chart
  class_area_df <- data.frame(
    class_name = names(class_area_km2),
    area_km2 = as.numeric(class_area_km2)
  )

  # Step 8: Calculate the total area in square kilometers
  total_area_km2 <- sum(class_area_df$area_km2)

  # Step 9: Calculate the percentage for each class
  class_area_df$percentage <- (class_area_df$area_km2 / total_area_km2) * 100

  # Step 10: Create a pie chart using ggplot2
  print(
    ggplot2::ggplot(class_area_df, ggplot2::aes(x = "", y = area_km2, fill = class_name)) +
      ggplot2::geom_bar(stat = "identity", width = 1) +
      ggplot2::coord_polar(theta = "y") +
      ggplot2::scale_fill_manual(
        values = c(
          "Built_Up_Area" = "red",
          "Water_Bodies" = "blue",
          "Agricultural_Area" = "yellow",
          "Natural_Vegetation" = "green",
          "Open_Area" = "gray"
        )
      ) +
      ggplot2::geom_text(ggplot2::aes(label = paste0(round(percentage, 1), "%\n", round(area_km2, 1), " km²")),
                         position = ggplot2::position_stack(vjust = 0.5), color = "white", size = 4) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = "LULC Class Distribution in 2014 (Area in km² and Percentages)",
        x = NULL,
        y = NULL
      ) +
      ggplot2::theme(axis.text.x = ggplot2::element_blank())
  )

  # Step 11: Create a bar chart using ggplot2
  print(
    ggplot2::ggplot(class_area_df, ggplot2::aes(x = class_name, y = area_km2, fill = class_name)) +
      ggplot2::geom_bar(stat = "identity", show.legend = FALSE) +
      ggplot2::geom_text(ggplot2::aes(label = paste0(round(percentage, 1), "%\n", round(area_km2, 1), " km²")),
                         vjust = -0.5, color = "black", size = 4) +
      ggplot2::scale_fill_manual(
        values = c(
          "Built_Up_Area" = "red",
          "Water_Bodies" = "blue",
          "Agricultural_Area" = "yellow",
          "Natural_Vegetation" = "green",
          "Open_Area" = "gray"
        )
      ) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = "LULC Class Distribution in 2014 (Area in km² and Percentages)",
        x = "Land Use / Land Cover Class",
        y = "Area (km²)"
      ) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
  )

  # Return class area data frame for further analysis if needed
  return(class_area_df)
}

# Example usage with the path to your raster file:
# Replace "your_raster_file.tif" with the actual path to your raster data file
classified_raster_path <- "E:/EAGLE/R_programming/LULC_LST/Data_2014/Masked_Asmara_Classification_2014.tif"
PlottingLULC(classified_raster_path)
