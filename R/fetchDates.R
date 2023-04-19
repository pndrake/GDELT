
source("./R/cleanData.R")

fetchDate <- function(this_date,
                      storage = c("output folder",
                                  "google sheet")) {
  
  # For now, set storage to "output folder"
  storage = "output folder"
  
  this_url <-  paste("http://data.gdeltproject.org/events/",
                     this_date,
                     ".export.CSV.zip",
                     sep = "")
  
  # Save the zip file
  tmp <- tempfile()
  download.file(this_url, tmp)
  # Unzip and Save the data
  fileName <- paste(this_date, ".export.CSV", sep = "")
  data_file <- unzip(tmp, fileName)
  # Read the data into memory
  df_data_raw <- read.csv(data_file, sep = "\t", header = FALSE)
  
  df_data <- cleanData(df_data_raw)
  
  if(storage == "output folder"){
  # Save the cleaned data:
  write.csv(df_data,
            file =  paste("./output/GDELT_",
                          this_date, ".csv",
                          sep = ""),
            row.names = FALSE)
  }
  
  if(storage == "google sheet"){
    
  # Write the data to a googlesheet
  googleSheet_ss = "1rRKoRsaCfiopczqEJDDJwSGK_smirZr6HbFly_dalco"
  googlesheets4::write_sheet(df_data, 
                             ss = googleSheet_ss,
                             sheet = this_date )
  }
  
  #  Remove temporary downloads from root
  file.remove(paste0("./", fileName))
  
}


# Invoke fetchDate for every date in the requested date range
fetchDates <- function(startDate,
                       endDate) {
  # We want to download the .zip file for each date's data.
  # File format: http://data.gdeltproject.org/events/{YYYYMMDD}.export.CSV.zip
  
  # Create a vector of dates
  
  # First, convert the character dates to Dates
  start_date <- as.Date(start_yyyymmdd, "%Y%m%d")
  end_date <- as.Date(end_yyyymmdd, "%Y%m%d")
  
  if (start_date > end_date) {
    print("flipping dates")
    temp_date <- end_date
    end_date <- start_date
    start_date <- temp_date
  }
  # Then make a vector of all days between the request dates
  # And convert that vector back to characters to paste together the urls
  vec_datesRequested <- as.Date(start_date:end_date, origin = "1970-01-01")
  vec_datesRequested_char <- format(vec_datesRequested, "%Y%m%d")
  
  # Read in each of the requested datasets
  list_df_thisDate <- lapply(vec_datesRequested_char, function(thisDate){
    fetchDate(thisDate)
  })
  
  # Return the list of data.frames
  return(list_df_thisDate)
}
