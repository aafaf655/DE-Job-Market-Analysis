{{ 
    config(
        materialized='view'
    ) 
}}

WITH companies AS (
    SELECT DISTINCT
        LOWER(TRIM(company)) AS company_name,
        LOWER(TRIM(company_industry)) AS industry,
        LOWER(TRIM(company_num_employees)) AS num_employees,
        LOWER(TRIM(company_revenue)) AS revenue_range,
        LOWER(TRIM(company_description)) AS company_description,
        company_url,
        company_logo,
        company_url_direct,
        SAFE_CAST(company_rating AS FLOAT64) AS company_rating,
        SAFE_CAST(company_reviews_count AS INT64) AS company_reviews_count
    FROM {{ ref('stg_jobs') }}
    WHERE NOT (
        company IS NULL
        AND company_url IS NULL
        AND company_industry IS NULL
        AND company_num_employees IS NULL
        AND company_revenue IS NULL
        AND company_description IS NULL
      )
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['company_name', 'company_url']) }} AS company_id,
    company_name,
    industry,
    num_employees,
    revenue_range,
    company_description,
    company_url,
    company_logo,
    company_url_direct,
    company_rating,
    company_reviews_count
FROM companies
