MSCK REPAIR TABLE climate_analytics.era5_vietnam_daily;

SELECT *
FROM climate_analytics.era5_vietnam_daily
LIMIT 10;

SELECT
  year,
  month,
  AVG(avg_temp_c) AS monthly_avg_temp_c,
  AVG(avg_wind_speed_10m) AS monthly_avg_wind_ms,
  AVG(solar_mj_m2) AS monthly_avg_solar_mj_m2,
  SUM(CASE WHEN heat_risk_flag THEN 1 ELSE 0 END) AS heat_risk_days
FROM climate_analytics.era5_vietnam_daily
GROUP BY year, month
ORDER BY year, month;
