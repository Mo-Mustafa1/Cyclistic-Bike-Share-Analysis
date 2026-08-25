/*
===============================================================================
Cyclistic Bike-Share: Full End-to-End SQL Analysis
Platform: Google BigQuery
===============================================================================
*/

-- ============================================================================
-- PHASE 1: DATA CONSOLIDATION
-- Objective: Combine 12 months of individual dataset tables into a single view.
-- ============================================================================

CREATE OR REPLACE VIEW `artful-zone-480411-u2.cyclistic_tripdata.consolidated_12_months` AS (
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202301`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202302`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202303`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202304`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202305`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202306`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202307`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202308`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202309`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202310`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202311`
  UNION ALL
  SELECT * FROM `artful-zone-480411-u2.cyclistic_tripdata.tripdata_202312`
);


-- ============================================================================
-- PHASE 2: DATA CLEANING & PREPARATION
-- Objective: Create a new, clean table by removing NULLs, filtering out 
-- invalid test rides, and calculating ride length and day of the week.
-- ============================================================================

CREATE OR REPLACE TABLE `artful-zone-480411-u2.cyclistic_tripdata.cleaned_full_year_data` AS (
  SELECT 
    ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    end_station_name,
    member_casual,
    -- Calculate ride length in minutes
    TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length_minutes,
    -- Extract the day of the week (1 = Sunday, 7 = Saturday)
    EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week,
    -- Extract the month
    EXTRACT(MONTH FROM started_at) AS month
  FROM 
    `artful-zone-480411-u2.cyclistic_tripdata.consolidated_12_months`
  WHERE 
    start_station_name IS NOT NULL 
    AND end_station_name IS NOT NULL
    AND end_lat IS NOT NULL
    AND end_lng IS NOT NULL
    -- Filter out negative times, zero-minute rides, and maintenance rides > 24 hours
    AND TIMESTAMP_DIFF(ended_at, started_at, MINUTE) > 1 
    AND TIMESTAMP_DIFF(ended_at, started_at, MINUTE) < 1440
);


-- ============================================================================
-- PHASE 3: DATA ANALYSIS & AGGREGATION
-- Objective: Uncover usage trends between annual members and casual riders.
-- ============================================================================

-- 1. Overall Rider Behavior (Volume and Average Ride Length)
SELECT 
    member_casual, 
    COUNT(ride_id) AS total_rides, 
    ROUND(AVG(ride_length_minutes), 2) AS average_ride_length_mins,
    MAX(ride_length_minutes) AS max_ride_length_mins
FROM 
    `artful-zone-480411-u2.cyclistic_tripdata.cleaned_full_year_data`
GROUP BY 
    member_casual;


-- 2. Weekly Usage Trends (Commuter vs. Leisure behaviors)
SELECT 
    member_casual, 
    day_of_week, 
    COUNT(ride_id) AS total_rides, 
    ROUND(AVG(ride_length_minutes), 2) AS avg_ride_length_mins
FROM 
    `artful-zone-480411-u2.cyclistic_tripdata.cleaned_full_year_data`
GROUP BY 
    member_casual, 
    day_of_week
ORDER BY 
    member_casual, 
    day_of_week;


-- 3. Seasonal Trends (Monthly ride volume)
SELECT 
    member_casual, 
    month, 
    COUNT(ride_id) AS total_rides
FROM 
    `artful-zone-480411-u2.cyclistic_tripdata.cleaned_full_year_data`
GROUP BY 
    member_casual, 
    month
ORDER BY 
    member_casual, 
    month;
