{{ 
    config(
        materialized='table'
    ) 
}}

WITH base_jobs AS (
    SELECT
        job_posting_id,
        id AS original_job_id,
        site,
        job_url,
        job_url_direct,
        title,
        company,
        location,
        date_posted,
        job_type,
        salary_source,
        salary_interval,
        min_amount,
        max_amount,
        currency,
        is_remote,
        job_level,
        job_function,
        listing_type,
        emails,
        description,
        skills,
        experience_range,
        company_rating,
        company_reviews_count,
        vacancy_count,
        work_from_home_type
    FROM {{ ref('stg_jobs') }}
    WHERE id IS NOT NULL
)

SELECT
    -- IDs
    job_posting_id,
    original_job_id,
    
    -- Job metadata
    site,
    job_url,
    job_url_direct,
    title,
    company,
    location,
    date_posted,
    job_type,
    salary_source,
    salary_interval,
    
    -- Salary information
    min_amount,
    max_amount,
    currency,
    
    -- Booleans
    is_remote,
    
    -- Job characteristics
    job_level,
    job_function,
    listing_type,
    
    -- Contact
    emails,
    
    -- Description
    description,
    
    -- Skills
    skills,
    ARRAY_LENGTH(SPLIT(skills, ', ')) AS number_of_skills, -- 📈 extra KPI: number of skills per job
    
    -- Company profile
    company_rating,
    company_reviews_count,
    
    -- Experience
    experience_range,
    
    -- Vacancies
    vacancy_count,
    
    -- Remote work
    work_from_home_type

FROM base_jobs
