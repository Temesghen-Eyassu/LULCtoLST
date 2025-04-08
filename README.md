

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
These masked images were classified using the Random Forest Algorithm, based on the training data. QGIS 3.40 was used to create the training data for both years.

 **Classified Raster for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/68161fb1-5afa-4c9e-a927-1db96a3b4bf4)

- **Classified Raster for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/b5d5bb63-3bf0-41c0-bb85-36fcc39cc196)

#### LULC Classification with Classes
The classified rasters were plotted and visualized using different colors to represent the various classes in the study area.
- **LULC Classification for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/812277a4-8a2b-4509-9b93-19c3d0bc8e7f)
- **LULC classification for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/23385194-272c-4878-89c2-4e1c202bd2b5)

#### Area and Percentage Cover LULC
The percentage and area coverage of each LULC class were calculated. 
- **Area and percentage Cover LULC of 2014:**
  
![Image](https://github.com/user-attachments/assets/f9c19684-7b76-40aa-b5be-bd29413b1192)

- **Area and percentage Cover LULC of 2024:**
  
![Image](https://github.com/user-attachments/assets/a126bf4a-1d4e-4240-b283-152b71f9b08a)

#### NDVI Comparison
The Normalized Difference Vegetation Index (NDVI) was also generated using Bands 5 and 4.
- **NDVI for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/9aabbe6a-9fb7-4d34-b5fe-b8fe7a90a45e)
- **NDVI for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/04371d1d-221b-4f86-a7d2-e11d67135c06)

#### LST Comparison
Additionally, the Land Surface Temperature (LST) was calculated using the thermal Band 10.
- **LST for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/1695eb64-32b1-413e-b28b-3faa268ca66d)
- **LST for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/43496100-cb21-4a07-935f-6901076c409e)


#### LULCvsLST
The relationships between LST and NDVI were analyzed through regression analysis
- **Regression Analysis for 2014:**
  
 ![Image](https://github.com/user-attachments/assets/d68dc76e-2183-400b-9e1c-2aef7211b421)
- **Regression Analysis for 2024:**
  
 ![Image](https://github.com/user-attachments/assets/0b46cbd4-79c2-4bea-a7ad-1ba399496c46)

Furthermore, the distribution of LST and LULC was visualized and displayed.
- **Distribution of LST and LULC for 2014:**
  
![Image](https://github.com/user-attachments/assets/49f2c77c-0666-4bb9-9426-69f23a1b6422)
- **Distribution of LST an dLULC for 2024:**
  
![Image](https://github.com/user-attachments/assets/82d3fb25-f048-495b-b3b9-c8b1809f3bff)


#### Change Detection between 2014 and 2024
The area with significant LST differences.
![Image](https://github.com/user-attachments/assets/3cd3f45e-048f-4083-be9c-82e6a1e02791)

The LST differences between the two selected years.
![Image](https://github.com/user-attachments/assets/cdfa5849-b50a-41f1-a52a-823287ec1321)

A LULC change map is displayed in the following map.
![Image](https://github.com/user-attachments/assets/e8a9b50c-abf5-4ae8-aa9a-54e39c234d3d)

A graph illustrating the changes from one class to another is also included.
![Image](https://github.com/user-attachments/assets/13039c5e-0dd1-4d0e-8bf8-918aff5a1c5f)

The relationship between LULC change and LST difference is represented as shown below.
![Image](https://github.com/user-attachments/assets/d581a91a-40a8-476c-8392-4ff2ae99dc0c)

---

Finally, the LULCtoLST package can be used in any selected study area, especially with Landsat datasets. I have tested it in another study area, and it worked well.




