

# LULCtoLST

This package is designed to show the relationship between the dynamics of Land Use and Land Cover (LULC) and their impact on Land Surface Temperature (LST) changes or differences. It is created using R version 4.4.2.

## Description

The package begins by classifying LULC types using Landsat 8 imagery from two selected years: 2014 and 2024, based on the Random Forest Algorithm. The classification categorizes the LULC into five distinct classes:
- Built-Up Areas
- Water Bodies
- Agricultural Areas
- Natural Vegetation
- Open Areas

The project then analyzes the changes in LULC over time between these two years. Additionally, the LST will be derived using Landsat 8’s thermal band (Band 10) for both 2014 and 2024. An analysis of the relationship between the Normalized Difference Vegetation Index (NDVI) and LST for these years will be performed. This will include calculating the correlation and conducting regression analysis to explore how vegetation cover (indicated by NDVI) relates to variations in LST. Furthermore, the project will examine the relationship between changes in LULC and differences in LST between the two years, providing insights into how land use and Land Use and Land Cover changes impact Land Surface Temperature trends.

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
The Landsat 8 dataset was downloaded from the official Earth Observation USGS website, where users are required to create an account to gain access and download the data. I cropped Bands 1, 2, 3, 4, 5, and 7 using the shapefile of Asmara, the capital city of Eritrea. Here is the cropped images for the year 2014 and 2024.
- **Cropped Image for 2014:**
  
 ![Cropped_Image_2014](https://github.com/user-attachments/assets/45113c28-6d9a-4e72-81e2-30128a165375)

- **Cropped Image for 2024:**
  
![Cropped_Image_2024](https://github.com/user-attachments/assets/8fbb8710-94c8-4b82-9231-df73d7a3b62b)
#### Masked Images
The cropped images were then masked with the shapefile of the study area. 

- **Masked Image for 2014:**
  
 ![Masked_Image_for_2024](https://github.com/user-attachments/assets/183ae5c9-b7ed-4285-a0e2-fd3c3796b933)

- **Masked Image for 2024:**
  
   ![Masked_Image_for_2014](https://github.com/user-attachments/assets/52a8f774-f635-4020-b9d6-9baf5e57d5b8)


#### Classified Images
The plot visualizes the results of classifying a land use/land cover raster using training data provided as a shapefile, with the Random Forest algorithm applied. The training data, which was created using QGIS 3.40 for both years, was used to guide the classification process. The raster image is first masked to focus the analysis on the relevant area, and the Random Forest algorithm is then employed to predict land use/land cover classes across the entire raster.
 **Classified Raster for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/68161fb1-5afa-4c9e-a927-1db96a3b4bf4)


- **Confusion Matrix:**

The overall accuracy for 2014 was calculated as 0.88 and 0.842, respectively, while for 2024, the overall accuracy was 0.851 and the Kappa coefficient was 0.805. These results indicate that the model performs well, with the classification being reliable and showing good agreement between the predicted and true classes. The confusion matrix highlights that some misclassifications did occur, but despite this, the model still achieved strong overall performance, demonstrating its robustness in land use/land cover classification across both years.

- **Confusion Matrix for the year 2014:**
  
![Image](https://github.com/user-attachments/assets/95697064-a783-457d-8a89-b566bc19c93c)
- **Classified Raster for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/b5d5bb63-3bf0-41c0-bb85-36fcc39cc196)

- **Confusion Matrix for the year 2024:**
 
![Image](https://github.com/user-attachments/assets/eaaf19d1-0d41-406e-ad5a-356fa5654d6d)
#### LULC Classification with Classes
This plot visualizes the spatial distribution of LULC classes for the selected years using a color-coded raster map. Each pixel on the map represents a specific LULC category—such as built-up area, water bodies, agricultural land, natural vegetation, or open areas—with distinct colors for easy interpretation.
- **LULC Classification for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/812277a4-8a2b-4509-9b93-19c3d0bc8e7f) 
 

- **LULC classification for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/23385194-272c-4878-89c2-4e1c202bd2b5)


#### Area and Percentage Cover LULC
The bar chart visually presents the distribution of Land Use/Land Cover (LULC) classes, highlighting their respective areas in square kilometers (km²) and their proportional representation as percentages (%) for the selected year. 
- **Area and percentage Cover LULC of 2014:**
  
![Image](https://github.com/user-attachments/assets/f9c19684-7b76-40aa-b5be-bd29413b1192)

- **Area and percentage Cover LULC of 2024:**
  
![Image](https://github.com/user-attachments/assets/a126bf4a-1d4e-4240-b283-152b71f9b08a)

#### NDVI Comparison
The Normalized Difference Vegetation Index (NDVI) is calculated using Band 5 (NIR) and Band 4 (Red) from Landsat 8 imagery and is used to assess vegetation distribution in the study area. NDVI values range from -1 to 1: values close to 1 indicate healthy, dense vegetation; values around 0 suggest sparse or stressed vegetation, or possibly bare soil; and values near -1 correspond to non-vegetated surfaces, such as water bodies or barren land. This index is essential for distinguishing between vegetated and non-vegetated areas and serves as a key input for further analyses, such as calculating Proportion of Vegetation (Pveg), Emissivity, and Land Surface Temperature (LST).

- **NDVI for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/9aabbe6a-9fb7-4d34-b5fe-b8fe7a90a45e)
- **NDVI for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/04371d1d-221b-4f86-a7d2-e11d67135c06)

#### LST Comparison
Land Surface Temperature (LST) for Landsat 8 is derived from the Thermal Infrared (Band 10) and is calculated through a series of steps, using the brightness temperature (BT), emissivity (ε), and the Normalized Difference Vegetation Index (NDVI). The process begins with the conversion of Band 10 data into top-of-atmosphere (TOA) radiance. The LST is used to measure the Earth's surface temperature, with high values indicating urban areas, bare land, or other hot surfaces, and lower values indicating cooler areas such as vegetation or water bodies.

- **LST for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/1695eb64-32b1-413e-b28b-3faa268ca66d)
- **LST for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/43496100-cb21-4a07-935f-6901076c409e)


#### LULCvsLST
- **Regression Analysis:**
  
The plot displays a linear regression analysis illustrating the relationship between NDVI (x-axis) and Land Surface Temperature (LST) (y-axis). Blue dots represent individual data points (pixels), showing corresponding NDVI and LST values. The red line represents the best-fit linear regression line, highlighting the overall trend between the two variables. Additionally, the R-squared value is included in the title, indicating how well NDVI explains the variation in LST.

- **Regression Analysis for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/d68dc76e-2183-400b-9e1c-2aef7211b421)
- **Regression Analysis for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/0b46cbd4-79c2-4bea-a7ad-1ba399496c46)


- **Distribution of LST and LULC:**

 The boxplot provides a visual summary of the Land Surface Temperature (LST) distribution across different Land Use/Land Cover (LULC) classes. The X-axis represents the various LULC classes (e.g., built-up, vegetation, water, etc.), while the Y-axis shows the corresponding LST values in degrees Celsius (°C). Each box indicates the interquartile range (IQR), which captures the middle 50% of LST values for each class, and the horizontal line inside each box represents the median LST for that land cover type.
- **Distribution of LST and LULC for 2014:**
![Image](https://github.com/user-attachments/assets/49f2c77c-0666-4bb9-9426-69f23a1b6422)
- **Distribution of LST and LULC for 2024:**
  
![Image](https://github.com/user-attachments/assets/82d3fb25-f048-495b-b3b9-c8b1809f3bff)


#### Change Detection between 2014 and 2024

- **Areas with LST differences:**
The areas with significant LST differences can help us understand which parts of the LULC classes have shown little change in LST over the years. The areas with white shades indicate small differences in LST.

![Image](https://github.com/user-attachments/assets/3cd3f45e-048f-4083-be9c-82e6a1e02791)

- **Difference in LST between 2014 and 2024:**
The LST differences between the two selected years where the color intensity reflects the magnitude of the LST change. The areas with greater differences in LST will be represented by brighter colors, while regions with minimal changes will be more muted or transparent.

![Image](https://github.com/user-attachments/assets/cdfa5849-b50a-41f1-a52a-823287ec1321)

- **LULC Change Detection Map:**
The land cover change map from 2014 to 2024 presents a clear and visually engaging overview of how the LULC has evolved over the past decade. It uses a distinct color-coded scheme to represent different change classes, making it easy to interpret the nature and extent of transformations across the region. Overall, the map serves as an effective visual tool for understanding patterns of environmental change and urban expansion in Asmara, providing valuable insights for planners, researchers, and decision-makers.
![Image](https://github.com/user-attachments/assets/e8a9b50c-abf5-4ae8-aa9a-54e39c234d3d)

- **Area Change by Classes between 2014 and 2024:**
  
The graph quantifies LULC changes between 2014 and 2024 by calculating the area (in km²) for each change class, based on pixel counts and raster resolution. These changes are then visualized using a color-coded bar plot, where each bar represents a specific land cover transition, and the bar height reflects the total area changed. This analysis highlights dominant transitions—such as urban expansion or vegetation loss—and supports informed decision-making in land use planning and environmental management.
![Image](https://github.com/user-attachments/assets/13039c5e-0dd1-4d0e-8bf8-918aff5a1c5f)

- **Relationship between LULC change and LST differences:**
  
The relationship between LULC change and LST difference is represented as shown below. The plot visualizes the relationship between LULC change and LST difference, with each point representing a pixel’s LULC class and its corresponding temperature change. Points are color-coded by LULC type (e.g., built-up area, water bodies), enabling quick identification of patterns linking land cover changes to temperature variations. This visualization helps assess whether specific land use/land cover changes, like urban expansion or vegetation loss, are associated with LST increases or decreases over the 10-year period.
![Image](https://github.com/user-attachments/assets/d581a91a-40a8-476c-8392-4ff2ae99dc0c)

---

Finally, the LULCtoLST package can be used in any selected study area, especially with Landsat datasets. I have tested it in another study area, and it worked well.




