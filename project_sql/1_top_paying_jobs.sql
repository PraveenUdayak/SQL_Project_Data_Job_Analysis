/*
Problem: Find the top paying data analyst jobs that are available
remotely.
*/

/* 
Loading up all necessary information for jobs 
*/
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM 
    job_postings_fact
/* 
Joining together 2 sets of data with company id being the repeated variable
*/
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
/* 
Specifying output by only looking for remote (aka 'Anywhere') Data Analyst jobs
Some jobs had 'NULL' as the salary and therefore were removed
*/
WHERE 
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
/* 
Ordering the list by salary, high->low
*/
ORDER BY
    salary_year_avg DESC
/* 
Limiting to the top 10 results, aka top 10 salaries
*/
LIMIT 10