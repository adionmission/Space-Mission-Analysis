# Code written by Aditya Kakde, owner of account @Onnamission

library(tidyverse)
library(janitor)
library(lubridate)
library(readxl)
library(weathermetrics)


# Setting working directory

# print(getwd())
# setwd("D:/Projects/Space-Mission-Analytics")
# print(getwd())

df = read_excel('Dataset/SpaceMissions.xlsx')

# View(df)


# Data Cleaning Pipeline 1

data_clean = df %>%
  janitor::clean_names()

# View(data_clean)

sapply(data_clean, class)


# removing unnecessary columns

data_clean = subset(data_clean, select = -c(payload_name, launch_time))

# View(data_clean)


# Replacing NA with No Failure in failure_reason as for success NA is given.

data_clean$failure_reason[is.na(data_clean$failure_reason)] = "No Failure"

# View(data_clean)


# converting data type

data_clean$launch_date = as.Date(data_clean$launch_date)

data_clean$temperature_a_f = as.numeric(data_clean$temperature_a_f)

data_clean$wind_speed_mph = as.numeric(data_clean$wind_speed_mph)

data_clean$humidity_percent = as.numeric(data_clean$humidity_percent)

data_clean$fairing_diameter_m = as.numeric(data_clean$fairing_diameter_m)

data_clean$payload_mass_kg = as.numeric(data_clean$payload_mass_kg)

# View(data_clean)


# Data Cleaning Pipeline 2

dataclean = data_clean %>%
  na_if(0.0) %>%
  na_if(0) %>%
  drop_na()

# View(dataclean)


# Removing redundancy

dataclean$payload_type[dataclean$payload_type == "Communication Satellite / Moon Lander / Research Satellite"] = "Communication/Research Satellite"

dataclean$payload_type[dataclean$payload_type == "Communication Satellite / Research Satellite"] = "Communication/Research Satellite"

dataclean$payload_type[dataclean$payload_type == "Communication Satellite"] = "Communication/Research Satellite"

dataclean$payload_type[dataclean$payload_type == "Direct-to-Home Television Services"] = "DTH Television Services"

dataclean$payload_type[dataclean$payload_type == "Direct-to-Home (DTH) broadcast, broadband, and backhaul services"] = "DTH Television Services"

dataclean$payload_type[dataclean$payload_type == "Earth observation satellite"] = "Earth Observation Satellite"

dataclean$payload_type[dataclean$payload_type == "Earth observation satellites"] = "Earth Observation Satellite"

dataclean$payload_type[dataclean$payload_type == "Research Satellite"] = "Communication/Research Satellite"

dataclean$payload_type[dataclean$payload_type == "Research Satellites"] = "Communication/Research Satellite"

dataclean$payload_type[dataclean$payload_type == "GPS III satellites"] = "Global Positioning System"

# View(dataclean)


# changing mission status to 1 and 0

dataclean$mission_status[dataclean$mission_status == "Success"] = 1

dataclean$mission_status[dataclean$mission_status == "Failure"] = 0

# View(dataclean)


# Converting temperature from F to C

dataclean$temperature_a_f = fahrenheit.to.celsius(dataclean$temperature_a_f)

dataclean$temperature_a_f = round(dataclean$temperature_a_f)

# View(dataclean)


# Remaining Columns

colnames(dataclean) = c("company",
                        "launch_date",
                        "launch_site",
                        "temperature",
                        "wind_speed",
                        "humidity",
                        "vehicle_type",
                        "liftoff_thrust",
                        "payload_to_orbit",
                        "rocket_height",
                        "fairing_diameter",
                        "payload_type",
                        "payload_mass",
                        "payload_orbit",
                        "mission_status",
                        "failure_reason")

# View(dataclean)


# creating new columns by company name and there success

# spacex and its success
dataclean$spacex = c(dataclean$company)

dataclean$spacex[dataclean$spacex == "SpaceX"] = 1

dataclean$spacex[dataclean$spacex == "Boeing"] = 0

dataclean$spacex[dataclean$spacex == "Martin Marietta"] = 0

dataclean$spacex[dataclean$spacex == "US Air Force"] = 0

dataclean$spacex[dataclean$spacex == "Brazilian Space Agency"] = 0

dataclean$spacex_s = c(1:105)

dataclean$spacex_s[dataclean$spacex == 1 & dataclean$mission_status == 1] = 1

dataclean$spacex_s[dataclean$spacex == 0 & dataclean$mission_status == 1] = 0

dataclean$spacex_s[dataclean$spacex == 1 & dataclean$mission_status == 0] = 0

dataclean$spacex_s[dataclean$spacex == 0 & dataclean$mission_status == 0] = 0

# View(dataclean)

# boeing and its success
dataclean$boeing = c(dataclean$company)

dataclean$boeing[dataclean$boeing == "SpaceX"] = 0

dataclean$boeing[dataclean$boeing == "Boeing"] = 1

dataclean$boeing[dataclean$boeing == "Martin Marietta"] = 0

dataclean$boeing[dataclean$boeing == "US Air Force"] = 0

dataclean$boeing[dataclean$boeing == "Brazilian Space Agency"] = 0

dataclean$boeing_s = c(1:105)

dataclean$boeing_s[dataclean$boeing == 1 & dataclean$mission_status == 1] = 1

dataclean$boeing_s[dataclean$boeing == 0 & dataclean$mission_status == 1] = 0

dataclean$boeing_s[dataclean$boeing == 1 & dataclean$mission_status == 0] = 0

dataclean$boeing_s[dataclean$boeing == 0 & dataclean$mission_status == 0] = 0

# View(dataclean)

# Martin Marietta and its success
dataclean$martin_marietta = c(dataclean$company)

dataclean$martin_marietta[dataclean$martin_marietta == "SpaceX"] = 0

dataclean$martin_marietta[dataclean$martin_marietta == "Boeing"] = 0

dataclean$martin_marietta[dataclean$martin_marietta == "Martin Marietta"] = 1

dataclean$martin_marietta[dataclean$martin_marietta == "US Air Force"] = 0

dataclean$martin_marietta[dataclean$martin_marietta == "Brazilian Space Agency"] = 0

dataclean$martin_marietta_s = c(1:105)

dataclean$martin_marietta_s[dataclean$martin_marietta == 1 & dataclean$mission_status == 1] = 1

dataclean$martin_marietta_s[dataclean$martin_marietta == 0 & dataclean$mission_status == 1] = 0

dataclean$martin_marietta_s[dataclean$martin_marietta == 1 & dataclean$mission_status == 0] = 0

dataclean$martin_marietta_s[dataclean$martin_marietta == 0 & dataclean$mission_status == 0] = 0

# View(dataclean)

# US Air Force and its success
dataclean$us_air_force = c(dataclean$company)

dataclean$us_air_force[dataclean$us_air_force == "SpaceX"] = 0

dataclean$us_air_force[dataclean$us_air_force == "Boeing"] = 0

dataclean$us_air_force[dataclean$us_air_force == "Martin Marietta"] = 0

dataclean$us_air_force[dataclean$us_air_force == "US Air Force"] = 1

dataclean$us_air_force[dataclean$us_air_force == "Brazilian Space Agency"] = 0

dataclean$us_air_force_s = c(1:105)

dataclean$us_air_force_s[dataclean$us_air_force == 1 & dataclean$mission_status == 1] = 1

dataclean$us_air_force_s[dataclean$us_air_force == 0 & dataclean$mission_status == 1] = 0

dataclean$us_air_force_s[dataclean$us_air_force == 1 & dataclean$mission_status == 0] = 0

dataclean$us_air_force_s[dataclean$us_air_force == 0 & dataclean$mission_status == 0] = 0

# View(dataclean)

# Brazilian Space Agency and its success
dataclean$brazilian_space_agency = c(dataclean$company)

dataclean$brazilian_space_agency[dataclean$brazilian_space_agency == "SpaceX"] = 0

dataclean$brazilian_space_agency[dataclean$brazilian_space_agency == "Boeing"] = 0

dataclean$brazilian_space_agency[dataclean$brazilian_space_agency == "Martin Marietta"] = 0

dataclean$brazilian_space_agency[dataclean$brazilian_space_agency == "US Air Force"] = 0

dataclean$brazilian_space_agency[dataclean$brazilian_space_agency == "Brazilian Space Agency"] = 1

dataclean$brazilian_space_agency_s = c(1:105)

dataclean$brazilian_space_agency_s[dataclean$brazilian_space_agency == 1 & dataclean$mission_status == 1] = 1

dataclean$brazilian_space_agency_s[dataclean$brazilian_space_agency == 0 & dataclean$mission_status == 1] = 0

dataclean$brazilian_space_agency_s[dataclean$brazilian_space_agency == 1 & dataclean$mission_status == 0] = 0

dataclean$brazilian_space_agency_s[dataclean$brazilian_space_agency == 0 & dataclean$mission_status == 0] = 0

# View(dataclean)


# Changing data type

sapply(dataclean, class)

dataclean$mission_status = as.numeric(dataclean$mission_status)

dataclean$spacex = as.numeric(dataclean$spacex)

dataclean$boeing = as.numeric(dataclean$boeing)

dataclean$martin_marietta = as.numeric(dataclean$martin_marietta)

dataclean$us_air_force = as.numeric(dataclean$us_air_force)

dataclean$brazilian_space_agency = as.numeric(dataclean$brazilian_space_agency)

# View(dataclean)


# writing changes to excel file

# write.csv(dataclean, "space_missions.csv", row.names = FALSE)
