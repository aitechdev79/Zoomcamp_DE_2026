# Vietnam Climate-Energy Analytics Pipeline (ERA5 + AWS)

## Overview

This project builds an end-to-end data engineering pipeline to analyze climate conditions and renewable energy potential in Vietnam using the ERA5 reanalysis dataset.

The pipeline ingests raw climate data from AWS Open Data, processes it into analytics-ready Parquet datasets, stores it in Amazon S3, exposes it via Amazon Athena, and visualizes insights through an interactive Streamlit dashboard.

---

## Problem Statement

Vietnam is highly vulnerable to climate change and is rapidly expanding renewable energy (solar and wind). However, access to structured, analytics-ready climate data is limited.

This project addresses:

- How temperature evolves over time  
- Wind speed patterns relevant for wind energy  
- Solar radiation patterns relevant for solar energy  
- Detection of heat-risk days  

---

## Dataset

- **Source**: ECMWF ERA5 Reanalysis (via AWS Open Data)
- **Access**: Public S3 bucket (no authentication required)
- **Format**: NetCDF (.nc)
- **Variables used**:
  - 2m temperature (t2m)
  - 10m u wind (u10)
  - 10m v wind (v10)
  - Surface solar radiation (ssrd)

- **Time coverage (MVP)**:
  - January 2023 (extendable to multi-year)

- **Geographic scope**:
  - Vietnam bounding box:
    - Latitude: 8°–24°
    - Longitude: 102°–110°

---

## Architecture
ERA5 (AWS Open Data S3)
        ↓
Python ETL (Colab / xarray)
        ↓
S3 Data Lake (Parquet, partitioned)
        ↓
Athena (SQL Query Engine)
        ↓
Streamlit Dashboard (Visualization)


---

## Technologies

- Python (Pandas, Xarray)
- AWS S3 (data lake storage)
- AWS Athena (serverless query engine)
- PyAthena (Python connector)
- Streamlit (dashboard)
- Plotly (visualization)

---

## Pipeline Description

### 1. Data Ingestion

- ERA5 data accessed from AWS Open Data
- NetCDF files loaded using `xarray`

### 2. Data Processing

- Spatial filtering (Vietnam bounding box)
- Temporal aggregation (daily averages)
- Feature engineering:
  - Temperature (°C)
  - Wind speed = √(u² + v²)
  - Solar radiation (MJ/m²)

### 3. Data Storage

- Output stored as **Parquet files**
- Partitioned structure:
s3://bucket/
└── marts/
└── era5_vietnam_daily/
└── year=2023/
└── month=01/


### 4. Data Modeling

Final schema:

| Column | Description |
|------|------------|
| date | observation date |
| avg_temp_c | average temperature |
| avg_wind_speed_10m | wind speed |
| solar_mj_m2 | solar radiation |
| temp_anomaly_c | deviation from baseline |
| heat_risk_flag | extreme temperature indicator |

### 5. Data Warehouse (Athena)

- External table created on S3 Parquet files
- Partitioned by `year`, `month`
- Queried using SQL

### 6. Visualization

- Streamlit dashboard connects to Athena
- Displays:
  - Temperature trends
  - Wind speed
  - Solar radiation
  - Heat-risk days

---

## Athena Queries

Example:

```sql
SELECT
  year,
  month,
  AVG(avg_temp_c) AS avg_temp,
  AVG(avg_wind_speed_10m) AS avg_wind,
  AVG(solar_mj_m2) AS avg_solar
FROM climate_analytics.era5_vietnam_daily
GROUP BY year, month
ORDER BY year, month;

Dashboard

The Streamlit (local run) dashboard provides:

Key climate indicators
Time-series plots
Monthly summaries
Interactive filtering


Reproducibility
1. Install dependencies
pip install -r requirements.txt
2. Configure AWS credentials
aws configure

or via environment variables:

export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
3. Run ETL (notebook)
notebooks/era5_etl_colab.ipynb
4. Upload to S3
python src/upload_to_s3.py
5. Create Athena table

Run SQL in sql/ folder.

6. Run dashboard
streamlit run dashboard.py
Limitations
MVP only uses one month of data
Precipitation not included
No orchestration (manual execution)
Future Work
Extend to multi-year data (2014–2024)
Add precipitation and humidity
Introduce orchestration (Airflow/Mage)
Add geospatial visualization (map)
Build forecasting models
Key Learnings
Working with NetCDF climate datasets
Designing S3 partitioned data lakes
Using Athena for serverless analytics
Connecting Python applications to AWS
Building end-to-end data pipelines
