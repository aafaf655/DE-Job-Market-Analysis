{{ 
    config(
        materialized='view'
    ) 
}}

WITH remote_jobs AS (
    SELECT
        location,
        is_remote
    FROM {{ ref('fact_jobs') }}
    WHERE location IS NOT NULL
)

SELECT
    LOWER(TRIM(location)) AS location,
    COUNT(*) AS total_jobs,
    SUM(CASE WHEN is_remote = TRUE THEN 1 ELSE 0 END) AS remote_jobs,
    ROUND(SAFE_DIVIDE(SUM(CASE WHEN is_remote = TRUE THEN 1 ELSE 0 END), COUNT(*)), 4) AS remote_ratio
FROM remote_jobs
GROUP BY location
ORDER BY remote_ratio DESC
