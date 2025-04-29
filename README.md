# Data-Engineering-Job-Market-Analysis

In the era of big data, efficiently processing and visualizing large datasets in real-time is crucial for data-driven decision-making. In this context, Data Scientists, Data Analysts, and Data Engineers each play a pivotal role. Before Data Scientists and Data Analysts can process data to gain insights or build predictive models, Data Engineers are responsible for creating and maintaining data pipelines. This involves collecting data from various sources, transforming it into a usable format, and ensuring data quality before storing it in data storage systems. By establishing and managing these data pipelines, Data Engineers lay the groundwork for effective analysis and visualization, enabling other roles to derive valuable insights from the data.

As someone interested in a career in Data Engineering, I must understand what skills are needed and explore the Data Engineering opportunities in France.

## Objective 

Develop an end-to-end, real-time data pipeline for collecting, transforming, storing, and visualizing job market data to analyze Data Engineering opportunities in France. This project aims to provide valuable insights into:

- The demand for Data Engineering roles across various industries.
- The most sought-after skills and technologies in the field.
- Key hiring companies and their workforce size.
- Salary trends, including minimum and maximum annual salaries.
- Locations with the highest demand for Data Engineers.
- Job posting trends over time to track hiring patterns.

## Tech Stack

- **Orchestration**: [Kestra](https://kestra.io/) (workflow automation)
- **Transformations**: [dbt (Data Build Tool)](https://www.getdbt.com/) (data modeling and transformations)
- **Cloud Platform**: [Google Cloud Platform (GCP)](https://cloud.google.com/)
- **Infrastructure as Code**: [Terraform](https://www.terraform.io/)
- **Visualization**: [Power BI](https://app.powerbi.com/singleSignOn?ru=https%3A%2F%2Fapp.powerbi.com%2F%3FnoSignUpCheck%3D1i)

## Project Structure

```
.
├── README.md           # Project documentation
├── dbt                 # dbt transformation logic
│   ├── job_market_analysis  # dbt project directory
│   │   ├── models      # Core, marts, and staging models
│   │   ├── macros      # Custom dbt macros
│   │   ├── tests       # dbt tests
│   │   ├── seeds       # Seed data
│   │   ├── snapshots   # Snapshot tables
│   │   ├── dbt_project.yml # dbt project config
├── docker              # Docker configuration
│   └── docker-compose.yml # Services setup
├── kestra              # Kestra workflows for orchestration
│   ├── flows           # Workflow definitions
│   ├── data           # example of data ingested
└── terraform           # Infrastructure as code
    ├── main.tf         # Terraform configuration
    ├── variables.tf    # Terraform variables
```

## Data Pipeline Workflow
1. **🏗️ Infrastructure Setup**
All cloud resources (GCS bucket, BigQuery dataset, service accounts) are provisioned and managed using Terraform.

2. **🔄 Data Ingestion**
- Job postings are scraped using ([JobSpy](https://github.com/speedyapply/JobSpy))
- A Kestra workflow handles scraping and saves results as CSV.
- CSVs are uploaded to a Google Cloud Storage (GCS) bucket.
- An external BigQuery table points directly to the raw CSV in GCS.

3. **🧹 Transformations with dbt**
- Data is typed and cleaned in temporary BigQuery tables via Kestra.
- dbt then builds:
    - stg_jobs (staging layer)
    - Core tables: fact_jobs, dim_company, dim_skills
    - Marts: mart_top_skills, mart_salary_distribution, mart_remote_jobs, mart_company_performance
    - Models are materialized as views or tables for efficient querying.

4.**⏱️ Orchestration with Kestra**
Kestra automates:
- Daily scraping
- File uploads to GCS
- BigQuery external and staging table creation
- Triggering dbt transformations via CLI

###  📈 Visualization in Power BI
- Final analytical tables are queried directly from BigQuery.
- Power BI dashboards provide insights on:
Top skills by demand
Remote work trends
Salary distributions
Company performance and job trends over time

## Power BI Dashboard
jobs scraped in one day :
![Data Engineering Job Market Analysis Dashboard](image-1.png)

## How to Run the Project (Reproducibility)
### ✅ Prerequisites
- Google Cloud Project with: **BigQuery, Cloud Storage (GCS)** enabled and Service account key with BigQuery & GCS access.
- Terraform installed (`brew install terraform` or [download](https://www.terraform.io/downloads)).
- Docker installed
- Power BI (optional, for dashboarding)

### 🔧 Setup Instructions
1. **Clone the repository**:

   ```bash
   git clone https://github.com/YOUR_USERNAME/job-market-analytics-pipeline.git
   cd job-market-analytics-pipeline
   ```

2. **Configure GCP variables**:
GCP_PROJECT_ID
GCP_DATASET
GCP_BUCKET_NAME
GCP_CREDS (path to service account key)
GCP_LOCATION (e.g. EU)

3. **Deploy infrastructure with Terraform**:
    ```bash
    cd terraform
    terraform init
    terraform apply
    ```

4. **Start Docker Services**:

   ```bash
   cd docker
   docker-compose up --build
   ```

5. **Update dbt schema.yml for staging**:
Edit dbt/job_market_analysis/models/staging/schema.yml:

   ```yaml
   sources:
     - name: staging
       database: <YOUR_GCP_PROJECT_ID>  # Replace with your actual GCP project ID
       schema: <YOUR_GCP_DATASET>        # Replace with your actual BigQuery dataset

       tables:
         - name: <YOUR_DATA_TABLE_NAME>  # Replace with your actual table name
   ```

6. **Run dbt transformations**:

   ```bash
   cd dbt/beverage_sales
   dbt compile
   dbt run
   ```

9. Visualize data in Power BI:
- Connect Power BI to BigQuery
- Query marts like:
    - mart_top_skills
    - mart_salary_distribution
    - mart_remote_jobs
    - mart_company_performance

Build interactive dashboards from these models.

