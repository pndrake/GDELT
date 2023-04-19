# This file manages the cleaning/downloading/management of data from:
# The fetchDates function servers as our pipeline, give it a start date and an enddate, and it will process and save the dates requested
# "http://data.gdeltproject.org/events/index.html"


# Load resources ----
source("./R/fetchDates.R")
# Note: fetchDates.R contains two functions:
#           1. fetchDate -- input "yyyymmdd" out: raw data.frame
#           2. fetchDates -- calls fetchDate for each day requested

source("./R/cleanData.R")
# Note: cleanData assigns column names, assigns data types, and cleans/validates data (work in progress)

# Fetch the data ---- 
# Note: These dates may need to be moved up by one day (some of the documentation mentioned posting files in the morning for the previous day, but marking them with the date they were posted)
start_yyyymmdd <- "20220315"
end_yyyymmdd   <- "20220331"

# Download, unzip, clean, save data for each data in the requested window
# Note: output saved as one .csv file in the "output" folder for each date. They are timestamped appropriately
system.time({
  fetchDates(start_yyyymmdd, end_yyyymmdd)
})



