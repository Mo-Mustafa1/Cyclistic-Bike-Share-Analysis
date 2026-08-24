# Cyclistic Bike-Share: Case Study Analysis

---

## Phase 1: Ask

### Project Overview
Cyclistic is a successful bike-share program based in Chicago, featuring a fleet of over 5,800 geotracked bicycles and 600 docking stations. The company offers flexible pricing plans, categorizing users into two main groups:
* **Casual Riders:** Customers who purchase single-ride or full-day passes.
* **Annual Members:** Customers who purchase yearly subscriptions.

Financial analysts at Cyclistic have concluded that annual members are significantly more profitable than casual riders. The Director of Marketing believes that rather than running broad campaigns to attract entirely new customers, the most effective path to future growth is to convert existing casual riders into annual members.

### The Business Task
To analyze historical bike trip data to identify behavioral differences between casual riders and annual members, providing actionable insights that will guide marketing strategies aimed at converting casual riders into profitable annual memberships.

### Key Stakeholders
* **Lily Moreno (Director of Marketing):** Responsible for the development of campaigns and initiatives to promote the bike-share program.
* **Cyclistic Executive Team:** The detail-oriented management team responsible for approving the final recommended marketing program.
* **Cyclistic Marketing Analytics Team:** The data team responsible for collecting, analyzing, and reporting data to guide the overall marketing strategy.

  ---

 ## Phase 2: Prepare
### Data Source & Integrity
The data used for this analysis covers the previous 12 months of Cyclistic trip data (August 2025 – July 2026). The data was downloaded and structured from monthly CSV files provided by Motivate International Inc. under this [license](https://www.divvybikes.com/data-license-agreement).

### ROCCC Analysis Evaluation
* **Reliable:** High reliability; captures millions of real-world tracking metrics from actual system usage.
* **Original:** First-party historical data provided directly by the city bike-share program.
* **Comprehensive:** Contains 12 full months of data, capturing seasonal variations, ride durations, geographic coordinates, and user types.
* **Current:** Reflects recent operational cycles up to mid-2026.
* **Cited:** Sourced transparently from official public datasets.

### Privacy & Security
Data privacy considerations prohibit the use of riders' personally identifiable information (PII). Credit card numbers and home addresses of users have been scrubbed to comply with data privacy regulations.

---

## Phase 3: Process
### Environment & Consolidation
* **Tool Used:** Google BigQuery Sandbox
* **Data Ingestion:** Sourced 12 monthly CSV files via secure Google Drive URIs.
* **Consolidation:** Explicitly defined schemas to prevent type mismatches and merged 12 separate tables into a single master table containing **6,037,968** records using `UNION ALL`.

### Data Cleaning and Transformation
Executed a comprehensive SQL cleaning script that stripped out over 2 million invalid, incomplete, or test records:
* **Removed Null Values:** Filtered out records missing essential geographic data (`start_station_name` and `end_station_name`).
* **Eliminated Anomalies:** Removed maintenance and administrative test rows containing "Test" or "Base" in station names.
* **Corrected Temporal Errors:** Excluded physically impossible trips where `ended_at` occurred before `started_at`.
* **Deduplication:** Applied window functions (`QUALIFY ROW_NUMBER()`) to enforce uniqueness across `ride_id`.

### Metric Generation
* **`ride_length_minutes`:** Calculated trip duration using `TIMESTAMP_DIFF(ended_at, started_at, MINUTE)`.
* **`day_of_week`:** Extracted the starting day of the week via `EXTRACT(DAYOFWEEK)` (1 = Sunday).

A final Quality Assurance query confirmed a clean, mathematically verified dataset of **4,012,680** rows ready for analysis.
