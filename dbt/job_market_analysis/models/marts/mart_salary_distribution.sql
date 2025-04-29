{{ 
    config(
        materialized='view'
    ) 
}}

WITH salary_data AS (
    SELECT
        LOWER(TRIM(job_type)) AS job_type,
        LOWER(TRIM(location)) AS location,
        min_amount,
        max_amount
    FROM {{ ref('fact_jobs') }}
    WHERE min_amount IS NOT NULL
      AND max_amount IS NOT NULL
)

SELECT
    job_type,
    location,
    COUNT(*) AS number_of_jobs,
    ROUND(AVG(min_amount), 2) AS avg_min_salary,
    ROUND(AVG(max_amount), 2) AS avg_max_salary,
    ROUND(MIN(min_amount), 2) AS min_salary,
    ROUND(MAX(max_amount), 2) AS max_salary
FROM salary_data
GROUP BY job_type, location
ORDER BY avg_max_salary DESC
