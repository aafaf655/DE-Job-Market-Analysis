variable "credentials" {
  description = "My Credentials"
  default     = "./keys/my-creds.json"
}


variable "project" {
  description = "Project"
  default     = "de-job-market-analysis-457616"
}

variable "region" {
  description = "Region"
  default     = "europe-west1"
}

variable "location" {
  description = "Project Location"
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "job_market_analytics"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "de-jobs-data-fr-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}