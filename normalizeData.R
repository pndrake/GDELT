library(tidyverse)

# 1. Read in the data for each date, and combine them into one data.frame -----
vec_fileNames_toCombine <- list.files("./output/",full.names = TRUE)
list_df_gdelt <- lapply(vec_fileNames_toCombine, read_csv)

# Combine the list of data.frames into one data.frame
system.time({
df_gdelt <- do.call(bind_rows, list_df_gdelt)
remove(list_df_gdelt); gc()
})
# Save the combined dataset
# write.csv(df_gdelt, paste0("./output/gdelt_", start_yyyymmdd, " to ", end_yyyymmdd, ".csv"))

# Create normalizations----
# First subset the data.frame to only the columns of interest for this exercise
# Note: I am curious how much smaller our objects will be using this method
df_gdelt <- df_gdelt |>
  select(GlobalEventID,
         Actor1Geo_Fullname,
         Actor1Geo_CountryCode,
         Actor2Geo_Fullname,
         Actor2Geo_CountryCode)

# This function is called to add an ID column to our data.frames:
# Note: this function is a work in progress, and should be improved to insure ids are unique as values are added/changed/deleted:
add_ids <- function(df_this){
  df_this |>
    mutate(ID = row_number()) |>
    dplyr::relocate(ID)
}



# 1NF ----- 
# Unique Actor geonames
df_actorGeoNames <- df_gdelt %>%
  select(Actor1Geo_Fullname, Actor2Geo_Fullname) %>%
  pivot_longer(cols = c("Actor1Geo_Fullname", "Actor2Geo_Fullname")) |>
  filter(value != "") |>
  select(-name) |>
  distinct() %>%
  add_ids() %>%
  select(ID_geoNames = ID, Value = value)
# Unique Actor country codes
df_actorCountryCode <- df_gdelt %>%
  select(Actor1Geo_CountryCode, Actor2Geo_CountryCode) %>%
  pivot_longer(cols = c("Actor1Geo_CountryCode", "Actor2Geo_CountryCode")) |>
  filter(value != "") |>
  select(-name) |>
  distinct() %>%
  add_ids() %>%
  select(ID_countryCode = ID, Value = value)

# 2NF ----
# Unique relationships between Actor Geonames and Actor Country Code
df_geoNameByCountryCode <- bind_rows(
  # Actor 1
  df_gdelt %>%
    select(GeoFullname = Actor1Geo_Fullname, GeoCountryCode = Actor1Geo_CountryCode) |>
    distinct(),
  # Actor 2
  df_gdelt %>%
    select(GeoFullname = Actor2Geo_Fullname, GeoCountryCode =Actor2Geo_CountryCode) |>
    distinct()
) |>
  distinct() |>
  filter(!(GeoFullname == "") & !(GeoCountryCode == "")) |>
  # Substitue Geo Fullnames, and CountryCodes with their D1 IDs
  left_join(df_actorGeoNames, by = c("GeoFullname" = "Value")) |>
  left_join(df_actorCountryCode, by = c("GeoCountryCode" = "Value")) |>
  select(-GeoFullname, -GeoCountryCode) |>
  distinct() |>
  add_ids() |>
  rename(ID_geonameByCountryCode = ID)


# 3NF ----
# Unique relationships of events by Actor Geoname/Country
# Note: Actor 1
df_3nf_eventByGeonameByCountryCode_actor1 <- df_gdelt |>
  select(GlobalEventID, Actor1Geo_Fullname, Actor1Geo_CountryCode) |>
  # Substitue Geo Fullnames, and CountryCodes with their D1 IDs
  left_join(df_actorGeoNames, by = c("Actor1Geo_Fullname" = "Value")) |>
  left_join(df_actorCountryCode, by = c("Actor1Geo_CountryCode" = "Value")) |>
  select(-Actor1Geo_Fullname, -Actor1Geo_CountryCode) |>
  left_join(df_geoNameByCountryCode, by = c("ID_geoNames", "ID_countryCode")) |>
  select(GlobalEventID, ID_Actor1_geonameByCountryCode = ID_geonameByCountryCode) |>
  filter(ID_Actor1_geonameByCountryCode != "") |>
  distinct()
df_3nf_eventByGeonameByCountryCode_actor2 <- df_gdelt |>
  select(GlobalEventID, Actor2Geo_Fullname, Actor2Geo_CountryCode) |>
  # Substitue Geo Fullnames, and CountryCodes with their D1 IDs
  left_join(df_actorGeoNames, by = c("Actor2Geo_Fullname" = "Value")) |>
  left_join(df_actorCountryCode, by = c("Actor2Geo_CountryCode" = "Value")) |>
  select(-Actor2Geo_Fullname, -Actor2Geo_CountryCode) |>
  left_join(df_geoNameByCountryCode, by = c("ID_geoNames", "ID_countryCode")) |>
  select(GlobalEventID, ID_Actor2_geonameByCountryCode = ID_geonameByCountryCode) |>
  filter(ID_Actor2_geonameByCountryCode != "") |>
  distinct()


size_postNormalization = (
  object.size(df_3nf_eventByGeonameByCountryCode_actor1) +
    object.size(df_3nf_eventByGeonameByCountryCode_actor2) +
    object.size(df_actorGeoNames) +
    object.size(df_actorCountryCode) +
    object.size(df_geoNameByCountryCode)
) |> as.numeric()
# Note: these sizes are in bytes
size_preNormalization = object.size(df_gdelt) |> as.numeric()

size_postNormalization / size_preNormalization
# About 26% of the original size

# Output the files to upload to github:
df_3nf_eventByGeonameByCountryCode_actor1 |> write_csv("./output/3nf_eventByGeonameByCountryCode_actor1.csv")
df_3nf_eventByGeonameByCountryCode_actor2 |> write_csv("./output/3nf_eventByGeonameByCountryCode_actor2.csv")
df_actorGeoNames |> write_csv("./output/1nf_actorGeoname.csv")
df_actorCountryCode |> write_csv("./output/1nf_actorCountryCode.csv")
df_geoNameByCountryCode |> write_csv("./output/2nf_geoNameByCountryCode.csv")
