% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PlottingLULC.R
\name{PlottingLULC}
\alias{PlottingLULC}
\title{Title: Plotting and Analyzing LULC Data for 2014}
\usage{
PlottingLULC(classified_raster_path, pixel_area_km2 = 9e-04)
}
\arguments{
\item{classified_raster_path}{A character string specifying the path to the classified raster data (e.g., a GeoTIFF file).}

\item{pixel_area_km2}{A numeric value representing the area of a single pixel in square kilometers. The default is 0.0009 km² (corresponding to a 30m x 30m pixel).}
}
\value{
A data frame containing the area (in square kilometers) and percentage for each Land Use/Land Cover class.
}
\description{
This function reads a classified raster, processes it, and generates plots and area calculations for LULC (Land Use/Land Cover) data.
}
\examples{
\dontrun{
classified_raster_path <- "E:/EAGLE/R_programming/LULC_LST/Data_2014/Masked_Asmara_Classification_2014.tif"
PlottingLULC(classified_raster_path)
}
}
