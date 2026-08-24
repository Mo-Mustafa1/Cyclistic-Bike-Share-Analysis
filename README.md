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

### Data Sources
To analyze the behavioral differences between casual riders and annual members, I utilized the previous 12 months of historical Cyclistic trip data. The datasets are appropriate for this case study and enable the answering of the core business questions.

### Data Credibility & Licensing
* **Source:** The data is public data provided by Motivate International Inc.
* **Access:** It is available under a strict data license agreement.
* **Context:** The datasets use a different name because Cyclistic is a fictional company, but the data is reliable and comprehensive for the scope of this project.

### Privacy and Security Limitations
* Strict data-privacy issues prohibit the use of riders' personally identifiable information.
* Due to these restrictions, it is not possible to connect pass purchases to credit card numbers.
* Consequently, I cannot determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes.

---

## Phase 3: Process

### Data Consolidation
To prepare the data for analysis, I utilized Google BigQuery to aggregate 12 months of historical Cyclistic trip data. The initial raw data was structured across 12 separate CSV files. I explicitly defined the schema and used a `UNION ALL` SQL command to merge these files into a single master table containing exactly 6,037,968 records, ensuring column consistency and data type alignment.

### Data Cleaning and Transformation
To ensure data integrity and verify the dataset was clean and ready to analyze, I executed a comprehensive SQL cleaning script. This robust filtering process eliminated over 2 million invalid records. The following specific transformations were applied:

* **Removed Null Values:** Filtered out records missing essential geographic data, specifically targeting NULLs in the `start_station_name` and `end_station_name` columns.
* **Eliminated Anomalies:** Removed administrative and maintenance records by filtering out station names containing the words "Test" or "Base". 
* **Corrected Temporal Errors:** Excluded physically impossible trips where the `ended_at` timestamp occurred before the `started_at` timestamp.
* **Deduplication:** Applied advanced window functions (`QUALIFY ROW_NUMBER()`) to ensure absolute uniqueness across the `ride_id` primary key.

### Metric Generation
To facilitate the final analysis, I created two new required data points:
1. **`ride_length_minutes`:** Calculated the exact duration of each trip using the `TIMESTAMP_DIFF()` function.
2. **`day_of_week`:** Extracted the day the ride began using the `EXTRACT(DAYOFWEEK)` function, formatted as an integer where 1 represents Sunday.

A final Quality Assurance (QA) query confirmed the resulting dataset contains 4,012,680 mathematically verified, flawless rows ready for the analysis phase.
