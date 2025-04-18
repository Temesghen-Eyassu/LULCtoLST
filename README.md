

# LULCtoLST

This package is designed to demonstrate the relationship between the dynamics of Land Use and Land Cover (LULC) and their impact on changes in Land Surface Temperature (LST). It was developed using R version 4.4.2.

## Description

The package begins by classifying LULC types using Landsat 8 imagery from two selected years: 2014 and 2024, based on the Random Forest Algorithm. The classification categorizes the LULC into five distinct classes:
- Built-Up Areas
- Water Bodies
- Agricultural Areas
- Natural Vegetation
- Open Areas

Following the classification, the project  analyzes the changes in LULC over 10 year period between 2014 and 2024. Additionally, the LST will be derived using Landsat 8’s thermal band (Band 10) for both 2014 and 2024. The study will also involve analyzing the relationship between the Normalized Difference Vegetation Index (NDVI) and LST for 2014 and 2024. This includes performing regression analysis to explore how vegetation cover, as indicated by NDVI, correlates with variations in LST.
Furthermore, the project will examine the relationship between changes in LULC and differences in LST between the two years, providing insights into how Land Use and Land Cover changes impact Land Surface Temperature trends over time.

## Installation

To install the **LULCtoLST** package, use the following steps:

1. **Install the devtools package** (if not already installed):

    ```r
    install.packages("devtools")
    ```

2. **Install the LULCtoLST package from GitHub**:

    ```r
    library(devtools)
    install_github("Temesghen-Eyassu/LULCtoLST")
    ```

3. **Load the package**:

    ```r
    library(LULCtoLST)
    ```

---

### **LULC and LST Comparison for 2014 and 2024**

#### Cropped Images
The Landsat 8 dataset was downloaded from the official Earth Observation United States Geological Survey (USGS) website, where users are required to create an account to gain access and download the data. I cropped Bands 1, 2, 3, 4, 5, and 7 using the shapefile of Asmara, the capital city of Eritrea. 

###### Example
     # Crop the Landsat stack using the Asmara boundary
       Cropped_Asmara <- terra::crop(Landsat_stack, Asmara_shape)
       terra::plot(Cropped_Asmara, main = "Cropped Landsat Image")
     
Here is the cropped images for the year 2014 and 2024.

- **Cropped Image for 2014:**
  
 ![Cropped_Image_2014](https://github.com/user-attachments/assets/45113c28-6d9a-4e72-81e2-30128a165375)

- **Cropped Image for 2024:**
  
![Cropped_Image_2024](https://github.com/user-attachments/assets/8fbb8710-94c8-4b82-9231-df73d7a3b62b)
#### Masked Images
The cropped images were then masked with the shapefile of the study area. 

##### Example
     # Mask the cropped Landsat image using the Asmara boundary
       masked_Asmara <- terra::mask(Cropped_Asmara, Asmara_shape)
       terra::plot(masked_Asmara, main = "Masked Landsat Image")

- **Masked Image for 2014:**
  
 ![Masked_Image_for_2024](https://github.com/user-attachments/assets/183ae5c9-b7ed-4285-a0e2-fd3c3796b933)

- **Masked Image for 2024:**
  
   ![Masked_Image_for_2014](https://github.com/user-attachments/assets/52a8f774-f635-4020-b9d6-9baf5e57d5b8)


#### Classified Images
The plot visualizes the results of classifying a land use/land cover raster using training data provided as a shapefile, with the Random Forest algorithm applied. The training data, which was created using QGIS 3.40 for both years, was used to guide the classification process. The raster image is first masked to focus the analysis on the relevant area, and the Random Forest algorithm is then employed to predict land use/land cover classes across the entire raster.
##### Sample code for classified codes 
    # Convert the 'id' to factor if it's not already
      training_data$id <- as.factor(training_data$id)

    # Extract the coordinates of the centroids of the polygons
      training_data$coords <- sf::st_centroid(training_data$geometry)
      training_data$coords <- sf::st_coordinates(training_data$coords)

    # Extract raster values at the coordinates of the centroids
      raster_values <- terra::extract(masked_raster, training_data$coords)

    # Combine the raster values with the class labels
      training_data_combined <- cbind(raster_values, id = training_data$id)

    # Remove rows with NA values in raster values
      training_data_combined <- stats::na.omit(training_data_combined)

    # Train the Random Forest model
      rf_model <- randomForest::randomForest(id ~ ., data = training_data_combined, ntree = 100)

    # Predict the classes for the entire raster (this will give discrete classes)
      predicted_raster <- terra::predict(masked_raster, rf_model, type = "response")

 **Classified Raster for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/68161fb1-5afa-4c9e-a927-1db96a3b4bf4)

- **Classified Raster for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/b5d5bb63-3bf0-41c0-bb85-36fcc39cc196)
- **Confusion Matrix:**

The overall accuracy and kappa coefficient for 2014 was calculated as 0.88 and 0.842, respectively, while for 2024, the overall accuracy was 0.851 and the Kappa coefficient was 0.805. These results indicate that the model performs well, with the classification being reliable and showing good agreement between the predicted and true classes. The confusion matrix highlights that some misclassifications did occur, but despite this, the model still achieved strong overall performance, demonstrating its robustness in land use/land cover classification across both years.

##### Sample code for confusion matrix

    # Extract centroids of the validation polygons for sampling
      validation_2024$coords <- sf::st_centroid(validation_2024$geometry)
      validation_2024$coords <- sf::st_coordinates(validation_2024$coords)

    # Extract raster values at the validation centroids
      validation_raster_values <- terra::extract(classified_raster, validation_2024$coords)
    
    # Remove NA values (where extraction failed) from the raster values
      validation_raster_values <- validation_raster_values[!is.na(validation_raster_values[, 1]), ]

    # Combine extracted raster values with the class labels from the validation data
      validation_data <- data.frame(validation_raster_values, id = validation_2024$id)

    # Convert the raster values to numeric format for analysis
      validation_raster_values_numeric <- as.numeric(as.character(validation_raster_values))

    # Add predicted and actual values to the dataset
      validation_data$predicted <- validation_raster_values_numeric
      validation_data$actual <- validation_data$id

- **Confusion Matrix for the year 2014:**
  
![Image](https://github.com/user-attachments/assets/95697064-a783-457d-8a89-b566bc19c93c)


- **Confusion Matrix for the year 2024:**
 
![Image](https://github.com/user-attachments/assets/eaaf19d1-0d41-406e-ad5a-356fa5654d6d)
#### LULC Classification with Classes
This plot visualizes the spatial distribution of LULC classes for the selected years using a color-coded raster map. Each pixel on the map represents a specific LULC category—such as built-up area, water bodies, agricultural land, natural vegetation, or open areas—with distinct colors for easy interpretation.

##### Sample code for LULC Classification
    # Extract classification values and prepare for plotting
      predicted_raster_classified_df <- as.data.frame(predicted_raster_classified, xy = TRUE)
      colnames(predicted_raster_classified_df) <- c("x", "y", "id_supervised")
    # Map the class IDs to class names using case_when
      predicted_raster_classified_df$class_name <- as.factor(dplyr::case_when(
        predicted_raster_classified_df$id_supervised == 1 ~ "Built_up_Area",
        predicted_raster_classified_df$id_supervised == 2 ~ "Water_Bodies",
        predicted_raster_classified_df$id_supervised == 3 ~ "Agricultural_Area",
        predicted_raster_classified_df$id_supervised == 4 ~ "Natural_Vegetation",
        predicted_raster_classified_df$id_supervised == 5 ~ "Open_Area",
        TRUE ~ NA_character_  # For any unexpected class IDs
        ))

    # Reorder class_name factor levels to match the color mapping order
      predicted_raster_classified_df$class_name <- factor(predicted_raster_classified_df$class_name,
                                                      levels = c("Built_up_Area", "Water_Bodies", "Agricultural_Area",
                                                                 "Natural_Vegetation", "Open_Area"))


- **LULC Classification for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/812277a4-8a2b-4509-9b93-19c3d0bc8e7f) 
 

- **LULC classification for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/23385194-272c-4878-89c2-4e1c202bd2b5)


#### Area and Percentage Cover LULC
The bar chart visually presents the distribution of Land Use/Land Cover (LULC) classes, highlighting their respective areas in square kilometers (km²) and their proportional representation as percentages (%) for the selected year. 

##### Sample code for Area and Percentage Cover LULC
    # Calculate the area in square kilometers for each class
      class_area_km2 <- table(predicted_raster_classified_df$class_name) * pixel_area_km2

    # Prepare data for pie chart and bar chart
      class_area_df <- data.frame(
      class_name = names(class_area_km2),
      area_km2 = as.numeric(class_area_km2)
      )

    # Calculate the total area in square kilometers
      total_area_km2 <- sum(class_area_df$area_km2)

    # Calculate the percentage for each class
      class_area_df$percentage <- (class_area_df$area_km2 / total_area_km2) * 100


- **Area and percentage Cover LULC of 2014:**
  
![Image](https://github.com/user-attachments/assets/f9c19684-7b76-40aa-b5be-bd29413b1192)

- **Area and percentage Cover LULC of 2024:**
  
![Image](https://github.com/user-attachments/assets/a126bf4a-1d4e-4240-b283-152b71f9b08a)

#### NDVI Calculation 
The Normalized Difference Vegetation Index (NDVI) is calculated using Band 5 (NIR) and Band 4 (Red) from Landsat 8 imagery and is used to assess vegetation distribution in the study area. NDVI values range from -1 to 1: values close to 1 indicate healthy, dense vegetation; values around 0 suggest sparse or stressed vegetation, or possibly bare soil; and values near -1 correspond to non-vegetated surfaces, such as water bodies or barren land. This index is essential for distinguishing between vegetated and non-vegetated areas and serves as a key input for further analyses, such as calculating Proportion of Vegetation (Pveg), Emissivity, and Land Surface Temperature (LST).

 ##### Calculate NDVI (Normalized Difference Vegetation Index)
       ndvi <- (band5_masked - band4_masked) / (band5_masked + band4_masked)
  
- **NDVI for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/9aabbe6a-9fb7-4d34-b5fe-b8fe7a90a45e)
- **NDVI for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/04371d1d-221b-4f86-a7d2-e11d67135c06)

#### LST Comparison
Land Surface Temperature (LST) for Landsat 8 is derived from the Thermal Infrared (Band 10) and is calculated through a series of steps, using the brightness temperature (BT), emissivity (ε), and the Normalized Difference Vegetation Index (NDVI). The process begins with the conversion of Band 10 data into top-of-atmosphere (TOA) radiance. The LST is used to measure the Earth's surface temperature, with high values indicating urban areas, bare land, or other hot surfaces, and lower values indicating cooler areas such as vegetation or water bodies.
 ##### Calculate LST using the formula
 
      lst <- terra::app(c(brightness_temp, emissivity), fun = function(x) {
   
    # Extract brightness temperature (BT) and emissivity (ε)
   
      bt <- x[[1]]  # First layer: brightness temperature
 
      emis <- x[[2]]  # Second layer: emissivity
   
      emis[is.na(emis)] <- 0.986  # Ensure emissivity does not contain NA values
   
      st_value <- bt / (1 + (lambda * bt) / rho * log(emis))
    
      lst_value_celsius <- lst_value - 273.15  # Convert from Kelvin to Celsius
    
      return(lst_value_celsius)  })
   
- **LST for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/1695eb64-32b1-413e-b28b-3faa268ca66d)
- **LST for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/43496100-cb21-4a07-935f-6901076c409e)


#### LULCvsLST
- **Regression Analysis:**
  
The plot displays a linear regression analysis illustrating the relationship between NDVI (x-axis) and Land Surface Temperature (LST) (y-axis). Blue dots represent individual data points (pixels), showing corresponding NDVI and LST values. The red line represents the best-fit linear regression line, highlighting the overall trend between the two variables. Additionally, the R-squared value is included in the title, indicating how well NDVI explains the variation in LST.

 ##### Calculating Linear Regression 
     # Load the rasters for the year 2024 as an example
  
       LST_2024 <- terra::rast(LST_path)
  
       NDVI_2024 <- terra::rast(NDVI_path)

     # Ensure the rasters have the same extent and resolution (align them if necessary)
  
       NDVI_2024 <- terra::resample(NDVI_2024, LST_2024, method = "bilinear")

     # Extract raster values and convert to data frame
  
       LST_values <- terra::values(LST_2024)
  
       NDVI_values <- terra::values(NDVI_2024)
  
       data <- data.frame(LST = LST_values, NDVI = NDVI_values)

    # Ensure columns are named correctly (in case column names are not as expected)
    
       colnames(data) <- c("LST", "NDVI")

  # Perform linear regression between LST a
- **Regression Analysis for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/d68dc76e-2183-400b-9e1c-2aef7211b421)
- **Regression Analysis for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/0b46cbd4-79c2-4bea-a7ad-1ba399496c46)


- **Distribution of LST and LULC:**

 The boxplot provides a visual summary of the Land Surface Temperature (LST) distribution across different Land Use/Land Cover (LULC) classes. The X-axis represents the various LULC classes (e.g., 1 is for Built-up, 2-Water Bodies, 3-Agricultural Area, 4- Natural Vegetation and 5-Open Area), while the Y-axis shows the corresponding LST values in degrees Celsius (°C). Each box indicates the interquartile range (IQR), which captures the middle 50% of LST values for each class, and the horizontal line inside each box represents the median LST for that land cover type.
 
 ##### Relationship between LULc and LST
 
     # Extract values from the LST and Classified rasters
     
       LST_values <- terra::values(LST_resampled)  # Extract LST values from the resampled raster 
     
       Class_values <- terra::values(Classified_Raster)  # Extract land cover class values

     # Remove NA values from the extracted data to ensure the analysis is performed on valid data points
     
       valid_data <- na.omit(data.frame(LST = LST_values, Class = Class_values))  # Remove NA values

    # Rename columns to make them clearer for analysis
    
      colnames(valid_data) <- c("LST", "Class")  # Rename columns to "LST" and "Class"

    # Aggregate the LST data by land cover class and calculate the mean LST for each class
   
      class_means <- aggregate(LST ~ Class, data = valid_data, FUN = mean)  # Calculate mean LST by cla
 
- **Distribution of LST and LULC for 2014:**
![Image](https://github.com/user-attachments/assets/49f2c77c-0666-4bb9-9426-69f23a1b6422)
- **Distribution of LST and LULC for 2024:**
  
![Image](https://github.com/user-attachments/assets/82d3fb25-f048-495b-b3b9-c8b1809f3bff)


#### Change Detection between 2014 and 2024

- **Areas with LST differences:**
The areas with significant LST differences can help us understand which parts of the LULC classes have shown little change in LST over the years. The areas with white shades indicate small differences in LST.

##### Calculating LST difference  

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

    print(plot_significant_diff
    
![Image](https://github.com/user-attachments/assets/3cd3f45e-048f-4083-be9c-82e6a1e02791)

- **Difference in LST between 2014 and 2024:**
The LST differences between the two selected years where the color intensity reflects the magnitude of the LST change. The areas with greater differences in LST will be represented by brighter colors, while regions with minimal changes will be more muted or transparent.

##### Calculate the difference between 2014 and 2024 LST

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

![Image](https://github.com/user-attachments/assets/cdfa5849-b50a-41f1-a52a-823287ec1321)

- **LULC Change Detection Map:**
The land cover change map from 2014 to 2024 presents a clear and visually engaging overview of how the LULC has evolved over the past decade. It uses a distinct color-coded scheme to represent different change classes, making it easy to interpret the nature and extent of transformations across the region. Overall, the map serves as an effective visual tool for understanding patterns of environmental change and urban expansion in Asmara, providing valuable insights for planners, researchers, and decision-makers.

##### LULC Change Detection 

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
      "55" = "Open Area to Open Area (no change)" )
![Image](https://github.com/user-attachments/assets/e8a9b50c-abf5-4ae8-aa9a-54e39c234d3d)

- **Area Change by Classes between 2014 and 2024:**
  
The graph quantifies LULC changes between 2014 and 2024 by calculating the area (in km²) for each change class, based on pixel counts and raster resolution. These changes are then visualized using a color-coded bar plot, where each bar represents a specific land cover transition, and the bar height reflects the total area changed. This analysis highlights dominant transitions—such as urban expansion or vegetation loss—and supports informed decision-making in land use planning and environmental management.

##### AREAL CHANGE CALCULATION 
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
      pixel_count = as.numeric(change_area_count) )

    # Calculate the area in square kilometers
      change_area_count_df$area_km2 <- change_area_count_df$pixel_count * pixel_area_km2

    # View the resulting areas in square kilometers for each class
      print(change_area_count_df)
    
![Image](https://github.com/user-attachments/assets/13039c5e-0dd1-4d0e-8bf8-918aff5a1c5f)

- **Relationship between LULC change and LST differences:**
  
The relationship between LULC change and LST difference is represented as shown below. The plot visualizes the relationship between LULC change and LST difference, with each point representing a pixel’s LULC class and its corresponding temperature change. Points are color-coded by LULC type (e.g., built-up area, water bodies), enabling quick identification of patterns linking land cover changes to temperature variations. This visualization helps assess whether specific land use/land cover changes, like urban expansion or vegetation loss, are associated with LST increases or decreases over the 10-year period.
##### Analysis LULC change vs LST Difference
    # Step 1: Load the LULC Change and LST Difference raster datasets
      LULC_Change <- terra::rast(lulc_change_path)  # Load the LULC change raster
      LST_Difference <- terra::rast(lst_difference_path)  # Load the LST difference raster

    # Step 2: Convert the LULC raster to a data frame with coordinates
      coords <- as.data.frame(LULC_Change, xy = TRUE)

    # Step 3: Ensure coords has an 'ID' column
      if (!"ID" %in% colnames(coords)) {
      coords$ID <- 1:nrow(coords)  # Assign an ID column if it doesn't exist
      print("ID column added to coords.")
      
    # Step 4: Extract values for both rasters based on the coordinates
      lulc_values <- terra::extract(LULC_Change, coords[, c("x", "y")])
      lst_values <- terra::extract(LST_Difference, coords[, c("x", "y")])
  
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
    
![Image](https://github.com/user-attachments/assets/d581a91a-40a8-476c-8392-4ff2ae99dc0c)

---

Finally, the LULCtoLST package can be applied to any selected study area, particularly when using Landsat datasets. In this project, I classified the area into five categories that are dominant within the chosen study area. When using the package, you can divide the study area into different classes based on the predominant land use/land cover (LULC) types present in your selected region. Additionally, I tested the package in a different study area, and it performed effectively.



