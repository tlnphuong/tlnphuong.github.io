-- Script in Google BigQuery: https://console.cloud.google.com/bigquery?sq=758435194399:8c5245a2c8fd46e6888f9cdcc5293790 
-- This script is to create a view of bike trips data (time, user type, start location/destination, weather, # trips and duration)
-- Time span: last 2 years of data (2017-2018)

CREATE OR REPLACE VIEW `my-first-project-403705.cyclistic.view-report-data` AS
SELECT 
  -- user type
  trip.usertype,
  -- start location
  DATE_ADD(DATE(trip.starttime), INTERVAL 5 YEAR) AS start_time,
  zip_start.zip_code AS start_zip,
  loc_start.neighborhood AS neighborhood,
  loc_start.borough AS start_borough,

  -- end location
  DATE_ADD(DATE(trip.stoptime), INTERVAL 5 YEAR) AS end_time,
  zip_end.zip_code AS end_zip,
  loc_end.neighborhood AS end_neighborhood,
  loc_end.borough AS end_borough,

  -- weather
  w.prcp AS precipitation, -- total precipitation of a day
  w.wdsp AS wind_speed, -- average wind speed of a day
  w.temp AS temperature, -- average temperature of a day

  -- trip details: group trips into 10 minute intervals to reduce the number of rows
  COUNT(bikeid) AS trip_count,
  ROUND(CAST(tripduration/60 AS INT64), -1) AS duration_mins

FROM `bigquery-public-data.new_york_citibike.citibike_trips` trip
INNER JOIN `bigquery-public-data.geo_us_boundaries.zip_codes` zip_start
  ON ST_WITHIN(
    ST_GEOGPOINT(trip.start_station_longitude, trip.start_station_latitude),
    zip_start.zip_code_geom)
INNER JOIN `bigquery-public-data.geo_us_boundaries.zip_codes` zip_end
  ON ST_WITHIN(
    ST_GEOGPOINT(trip.end_station_longitude, trip.end_station_latitude),
    zip_end.zip_code_geom)
INNER JOIN `my-first-project-403705.cyclistic.zip_code` loc_start -- zip code data from internal source
  ON loc_start.zip = CAST(zip_start.zip_code AS INT)
INNER JOIN `my-first-project-403705.cyclistic.zip_code` loc_end -- zip code data from internal source
  ON loc_end.zip = CAST(zip_end.zip_code AS INT)
INNER JOIN `bigquery-public-data.noaa_gsod.gsod201*` w
  ON PARSE_DATE('%Y%m%d', CONCAT(w.year, w.mo, w.da)) = DATE(trip.starttime)

WHERE
  -- take weather data from one weather station
  w.wban = '94728' -- NEW YORK CENTRAL PARK
  -- Use data in 2018
  AND EXTRACT(YEAR FROM DATE(trip.starttime)) BETWEEN 2017 AND 2018
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,14;
