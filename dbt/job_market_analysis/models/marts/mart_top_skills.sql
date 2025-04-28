{{ 
    config(
        materialized='view'
    ) 
}}

WITH exploded_skills AS (
    SELECT
        job_posting_id,
        TRIM(skill) AS skill_name
    FROM {{ ref('fact_jobs') }},
    UNNEST(SPLIT(skills, ', ')) AS skill
    WHERE skills IS NOT NULL
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['skill_name']) }} AS skill_id,
    LOWER(skill_name) AS skill_name,
    COUNT(DISTINCT job_posting_id) AS number_of_jobs
FROM exploded_skills
WHERE skill_name IS NOT NULL AND skill_name != ''
GROUP BY skill_name
ORDER BY number_of_jobs DESC
