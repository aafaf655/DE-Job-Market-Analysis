{{ 
    config(
        materialized='view'
    ) 
}}

WITH job_dates AS (
    SELECT
        DATE_TRUNC(date_posted, WEEK(MONDAY)) AS week_start_date
    FROM {{ ref('fact_jobs') }}
    WHERE date_posted IS NOT NULL
)

SELECT
    week_start_date,
    COUNT(*) AS number_of_jobs
FROM job_dates
GROUP BY week_start_date
ORDER BY week_start_date
