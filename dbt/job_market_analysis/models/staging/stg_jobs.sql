{{ 
    config(
        materialized='view'
    ) 
}}

WITH jobs_source AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY id) AS rn
    FROM {{ source('staging', 'data_jobs_France_main') }}
    WHERE id IS NOT NULL
),
skills_extracted AS (
    SELECT
        *,
        CASE
            WHEN skills IS NOT NULL AND skills != '' THEN skills
            ELSE ARRAY_TO_STRING(
                ARRAY(
                SELECT skill
                FROM UNNEST([
                    'python', 'sql', 'aws', 'pandas', 'spark', 'docker', 'kubernetes',
                    'data engineering', 'machine learning', 'deep learning',
                    'java', 'scala', 'go', 'react', 'airflow', 'flask', 'django'
                ]) AS skill
                WHERE REGEXP_CONTAINS(LOWER(description), r'\b' || skill || r'\b')
                ), ', '
            ) 
        END AS filled_skills
    FROM jobs_source
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['id', 'company', 'location']) }} AS job_posting_id,
    
    -- Basic identifiers
    id,
    site,
    job_url,
    job_url_direct,

    -- Job information
    LOWER(TRIM(title)) AS title,
    LOWER(TRIM(company)) AS company,
    LOWER(TRIM(location)) AS location,
    date_posted,
    LOWER(TRIM(job_type)) AS job_type,
    LOWER(TRIM(salary_source)) AS salary_source,
    LOWER(TRIM(`interval`)) AS salary_interval,
    
    -- Salary
    min_amount,
    max_amount,
    LOWER(TRIM(currency)) AS currency,
    
    -- Remote info
    is_remote,

    -- Job role info
    LOWER(TRIM(job_level)) AS job_level,
    LOWER(TRIM(job_function)) AS job_function,
    LOWER(TRIM(listing_type)) AS listing_type,

    -- Contact / description
    emails,
    description,

    -- Company information
    LOWER(TRIM(company_industry)) AS company_industry,
    company_url,
    company_logo,
    company_url_direct,
    company_addresses,
    LOWER(TRIM(company_num_employees)) AS company_num_employees,
    LOWER(TRIM(company_revenue)) AS company_revenue,
    LOWER(TRIM(company_description)) AS company_description,

    -- Skills and profile
    LOWER(TRIM(filled_skills)) AS skills,
    LOWER(TRIM(experience_range)) AS experience_range,

    -- Ratings
    SAFE_CAST(company_rating AS FLOAT64) AS company_rating,
    SAFE_CAST(company_reviews_count AS INT64) AS company_reviews_count,
    SAFE_CAST(vacancy_count AS INT64) AS vacancy_count,

    -- Remote work type
    LOWER(TRIM(work_from_home_type)) AS work_from_home_type

FROM skills_extracted
WHERE rn = 1
