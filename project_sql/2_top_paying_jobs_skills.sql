/*
We previously found the top paying jobs, now we use that query as a basis to find the 
skills associated with these jobs to see the most in-demand skills
*/
/*Starting with making the previous query a CTE*/

WITH top_paying_jobs AS 
(
    SELECT
        job_id,
        job_title,
        job_schedule_type,
        salary_year_avg,
        name AS company_name
    FROM 
        job_postings_fact

    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

    WHERE 
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL

    ORDER BY
        salary_year_avg DESC

    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills

FROM top_paying_jobs

/*Joining all 3 tables using the skill id variable*/
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC

/*
The results show that SQL was mentioned the msot followed by Tableau, R and Excel/Pandas
This shows us that on average for the higher paying data analyst jobs we can expect SQL to be within the job description and probably Tableau as well

*/