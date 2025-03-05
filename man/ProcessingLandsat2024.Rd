\name{ProcessingLandsat2024}
\alias{ProcessingLandsat2024}
\title{Process Landsat 2024 Satellite Data}
\description{
  This function processes Landsat 2024 satellite imagery by reading the specified band files,
  stacking them, and creating both true-color and false-color composite visualizations. It also
  reads a shapefile, ensures the coordinate reference system (CRS) matches the Landsat stack,
  and crops and masks the Landsat image according to the provided boundary. The result is saved
  to the specified output path.
}
\usage{
  ProcessingLandsat2024(landsat_dir, shapefile_path, output_path, bands = c(1, 2, 3, 4, 5, 7))
}
\arguments{
  \item{landsat_dir}{\strong{Character string}. The directory where the Landsat band files are located.}
  \item{shapefile_path}{\strong{Character string}. The path to the shapefile that defines the boundary for cropping and masking.}
  \item{output_path}{\strong{Character string}. The path where the processed and masked Landsat image will be saved.}
  \item{bands}{\strong{Integer vector}. The specific Landsat bands to be used. Default is c(1, 2, 3, 4, 5, 7), corresponding to the standard Landsat bands for natural color and infrared analysis.}
}
\value{
  \strong{SpatRaster}. The masked Landsat image after processing and cropping, which can be used for further analysis.
}
\examples{
  \dontrun{
    # Example usage of the function
    processed_image <- ProcessingLandsat2024(
      landsat_dir = "path/to/landsat/data",
      shapefile_path = "path/to/shapefile.shp",
      output_path = "path/to/output/processed_image.tif"
    )
  }
}
