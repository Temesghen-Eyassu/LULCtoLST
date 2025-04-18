% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/classify_land_use.R
\name{classify_land_use}
\alias{classify_land_use}
\title{Land Use Land Cover Classification Using Random Forest}
\usage{
classify_land_use(raster_path, shapefile_path, output_raster_path)
}
\arguments{
\item{raster_path}{A character string specifying the path to the input raster file.}

\item{shapefile_path}{A character string specifying the path to the input shapefile.}

\item{output_raster_path}{A character string specifying the path to save the output classified raster.}
}
\value{
A raster object containing the classified land use/land cover classes.
}
\description{
This function classifies a land use/land cover raster using Random Forest (RF)
based on provided training data. It reads a raster and shapefile of training
data, extracts spectral values from the raster at the centroids of polygons
in the shapefile, and trains a Random Forest model to predict the classes
across the raster. The function then saves the classified raster and plots it.
}
\examples{
classified_raster <- classify_land_use(
  raster_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_2024.tif",
  shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/TrainingData_2025/Training_2024.shp",
  output_raster_path = "E:/EAGLE/R_programming/LULC_LST/Data_2024/Masked_Asmara_Classification_2024_discrete.tif"
)
}
