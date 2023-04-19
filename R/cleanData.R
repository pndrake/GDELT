


cleanData <- function(df_thisDate){  
  
  # Assign column names to the data -----
  names_cols_eventIDAndDate <- c("GlobalEventID",
                     "Day",
                     "MonthYear",
                     "Year",
                     "FractionDate")
  names_cols_actor <- c("Actor1Code",
                        "Actor1Name",
                        "Actor1CountryCode",
                        "Actor1KnownGroupCode",
                        "Actor1EthnicCode",
                        "Actor1Religion1Code",
                        "Actor1Religion2Code",
                        "Actor1Type1Code",
                        "Actor1Type2Code",
                        "Actort1Type3Code",
                        "Actor2Code",
                        "Actor2Name",
                        "Actor2CountryCode",
                        "Actor2KnownGroupCode",
                        "Actor2EthnicCode",
                        "Actor2Religion1Code",
                        "Actor2Religion2Code",
                        "Actor2Type1Code",
                        "Actor2Type2Code",
                        "Actor21Type3Code")
  names_cols_eventAction <- c("IsRootEvent",
                              "EventCode",
                              "EventBaseCode",
                              "EventRootCode",
                              "QuadClass",
                              "GoldsteinScale",
                              "NumMentions",
                              "NumSources",
                              "NumArticles",
                              "AvgTone")
  names_cols_eventGeo <- c("Actor1Geo_Type",
                           "Actor1Geo_Fullname",
                           "Actor1Geo_CountryCode",
                           "Actor1Geo_ADM1Code",
                           "Actor1Geo_Lat",
                           "Actor1Geo_Long",
                           "Actor1Geo_FeatureID",
                           "Actor2Geo_Type",
                           "Actor2Geo_Fullname",
                           "Actor2Geo_CountryCode",
                           "Actor2Geo_ADM1Code",
                           "Actor2Geo_Lat",
                           "Actor2Geo_Long",
                           "Actor2Geo_FeatureID",
                           "ActionGeo_Type",
                           "Action2Geo_Fullname",
                           "Action2Geo_CountryCode",
                           "Action2Geo_ADM1Code",
                           "Action2Geo_Lat",
                           "Action2Geo_Long",
                           "Action2Geo_FeatureID")
  names_cols_dataManagement <- c("DATEADDED",
                                 "SOURCEURL")
  
  names(df_thisDate) <- c(names_cols_eventIDAndDate,
    names_cols_actor,
    names_cols_eventAction,
    names_cols_eventGeo,
    names_cols_dataManagement)
  
  # Convert columns to their correct data type -----
  # Note: to be completed
  
  
  # Check the data for quality issues and missing values----
  # Note: to be completed
  
  
  # Limit the data to subset of columns of interest -----
  # Note: to be completed

  # Output the cleaned dataset
  return(df_thisDate)
  
  
}
  
    