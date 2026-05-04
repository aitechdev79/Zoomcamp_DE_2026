import pandas as pd
from pyathena import connect

AWS_REGION = "ap-southeast-1"
S3_STAGING_DIR = "s3://hoa-era5-climate-lake/athena-results/"
DATABASE = "climate_analytics"

conn = connect(
    s3_staging_dir=S3_STAGING_DIR,
    region_name=AWS_REGION,
    schema_name=DATABASE,
    work_group="primary",
)

query = """
SELECT *
FROM climate_analytics.era5_vietnam_daily
LIMIT 10
"""

df = pd.read_sql(query, conn)
print(df.head())
