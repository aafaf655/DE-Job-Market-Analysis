import os
from datetime import datetime
from jobspy import scrape_jobs
from google.cloud import storage
import pandas as pd

# Config
BUCKET_NAME = "indeed-jobs-data-fr-457616"
GCS_PATH_PREFIX = "raw/data_engineer/"
LOCAL_PATH = "data/data_engineer_jobs.csv"

def scrape_jobs_to_csv():
    df = scrape_jobs(
        site_name=["indeed", "linkedin", "glassdoor"],
        search_term='"data engineer"',
        location="France",
        results_wanted=100,
        country_indeed="France",
        linkedin_fetch_description=True
    )
    print(f"Scraped {len(df)} jobs.")
    df.to_csv(LOCAL_PATH, index=False)
    return LOCAL_PATH

def upload_to_gcs(local_file_path, bucket_name, gcs_prefix):
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)

    today = datetime.now().strftime("%Y-%m-%d")
    gcs_file_path = f"{gcs_prefix}jobs_{today}.csv"

    blob = bucket.blob(gcs_file_path)
    blob.upload_from_filename(local_file_path)
    print(f"✅ Uploaded to gs://{bucket_name}/{gcs_file_path}")

if __name__ == "__main__":
    print("all good")
    #file_path = scrape_jobs_to_csv()
    #upload_to_gcs(file_path, BUCKET_NAME, GCS_PATH_PREFIX)


### to test : add this to docker compose file :
"""
  job_scraper:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: job-scraper
    environment:
      GOOGLE_APPLICATION_CREDENTIALS: /app/keys/my-creds.json
    volumes:
      - ./terraform/keys:/app/keys
      - ./data:/app/data
    command: python scripts/scrape_and_upload.py

"""