import boto3
from pathlib import Path

AWS_REGION = "ap-southeast-1"
BUCKET = "hoa-era5-climate-lake"

def upload_to_s3(local_file: str, bucket: str, key: str) -> None:
    s3 = boto3.client("s3", region_name=AWS_REGION)
    s3.upload_file(str(local_file), bucket, key)
    print(f"Uploaded: s3://{bucket}/{key}")

if __name__ == "__main__":
    year = 2023
    month = 1

    daily_file = Path(f"mart/era5_vietnam_climate_energy_daily_{year}_{month:02d}.parquet")

    daily_key = (
        f"marts/era5_vietnam_daily/"
        f"year={year}/month={month:02d}/"
        f"{daily_file.name}"
    )

    upload_to_s3(daily_file, BUCKET, daily_key)
