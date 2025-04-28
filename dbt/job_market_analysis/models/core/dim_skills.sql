{{ 
    config(
        materialized='view'
    ) 
}}

WITH exploded_skills AS (
    SELECT
        job_posting_id,
        TRIM(skill) AS skill
    FROM {{ ref('stg_jobs') }},
    UNNEST(SPLIT(skills, ', ')) AS skill
    WHERE skills IS NOT NULL
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['skill']) }} AS skill_id,
    LOWER(skill) AS skill_name,
    COUNT(DISTINCT job_posting_id) AS number_of_jobs
FROM exploded_skills
WHERE skill IS NOT NULL AND skill != ''
GROUP BY skill
ORDER BY number_of_jobs DESC
