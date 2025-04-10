% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LSTfirst_2014.R
\name{LSTfirst_2014}
\alias{LSTfirst_2014}
\title{LSTfirst_2014: A function to process Landsat 8 imagery (2014) and calculate Land Surface Temperature (LST)}
\usage{
LSTfirst_2014(work_dir, shapefile_path, output_dir)
}
\arguments{
\item{work_dir}{A character string specifying the working directory where Landsat data is stored.}

\item{shapefile_path}{A character string specifying the path to the shapefile used to mask and crop the raster data.}

\item{output_dir}{A character string specifying the directory where the output rasters will be saved.}
}
\value{
A series of raster layers (NDVI, Pveg, Emissivity, Brightness Temperature, and LST) that are saved as TIFF files in the output directory.
}
\description{
This function performs several steps to calculate Land Surface Temperature (LST) from Landsat 8 imagery (2014)
by processing three bands: Red (Band 4), NIR (Band 5), and Thermal Infrared (Band 10).
The workflow includes:
\enumerate{
\item Calculating NDVI (Normalized Difference Vegetation Index)
\item Calculating Proportion of Vegetation (Pveg)
\item Calculating Emissivity (ε)
\item Calculating Brightness Temperature (BT)
\item Calculating Land Surface Temperature (LST)
}
}
\details{
The function also plots intermediate results and saves the final LST raster to a specified directory.
}
\note{
The function assumes that the Landsat 8 data is organized in a specific directory structure
as demonstrated in the code, with individual band files named according to the Landsat metadata.
The function uses the \code{terra} and \code{sf} packages for raster manipulation and shapefile reading.
}
\examples{
LSTfirst_2014(
  work_dir = "E:/EAGLE/R_programming/LULC_LST/Data_2014",
  shapefile_path = "E:/EAGLE/R_programming/LULC_LST/Data_2014/Greater_Asmara_Shapefile/Asmara.shp",
  output_dir = "E:/EAGLE/R_programming/LULC_LST/Data_2014/LST_2014"
)

}
