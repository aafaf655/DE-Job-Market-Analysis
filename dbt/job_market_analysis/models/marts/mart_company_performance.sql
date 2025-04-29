{{ 
    config(
        materialized='view'
    ) 
}}

WITH company_data AS (
    SELECT
        LOWER(TRIM(company)) AS company_name,
        SAFE_CAST(company_rating AS FLOAT64) AS company_rating,
        SAFE_CAST(company_reviews_count AS INT64) AS company_reviews_count
    FROM {{ ref('fact_jobs') }}
    WHERE company IS NOT NULL
)

SELECT
    company_name,
    COUNT(*) AS number_of_jobs,
    ROUND(AVG(company_rating), 2) AS avg_company_rating,
    SUM(company_reviews_count) AS total_reviews
FROM company_data
GROUP BY company_name
ORDER BY number_of_jobs DESC
