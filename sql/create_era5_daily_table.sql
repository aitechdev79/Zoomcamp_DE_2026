CREATE EXTERNAL TABLE IF NOT EXISTS climate_analytics.era5_vietnam_daily (
  date TIMESTAMP,
  region STRING,
  lat_min DOUBLE,
  lat_max DOUBLE,
  lon_min DOUBLE,
  lon_max DOUBLE,
  avg_temp_c DOUBLE,
  avg_u_wind_10m DOUBLE,
  avg_v_wind_10m DOUBLE,
  avg_wind_speed_10m DOUBLE,
  solar_mj_m2 DOUBLE,
  temp_anomaly_c DOUBLE,
  solar_anomaly_mj_m2 DOUBLE,
  wind_anomaly_ms DOUBLE,
  heat_risk_flag BOOLEAN
)
PARTITIONED BY (
  year INT,
  month INT
)
STORED AS PARQUET
LOCATION 's3://hoa-era5-climate-lake/marts/era5_vietnam_daily/';
