SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
    -- finding the avg salary for skills and then rounding to get rid of decimals
FROM job_postings_fact

INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = 'True'

GROUP BY
    skills

ORDER BY   
    avg_salary DESC

LIMIT 25

/*
Big Data & ML Tools:

    PySpark, DataRobot, Databricks, Airflow, Scikit-learn, Pandas, Numpy, Jupyter — all rank high.

    These reflect data science and AI/ML workflows.

DevOps & Collaboration Tools:

    Bitbucket, GitLab, Jenkins, Atlassian, Kubernetes, Notion.

    High salaries suggest DevOps engineers and platform engineers are well-compensated.

Programming Languages:

    Swift ($153K), Go ($145K), Scala ($125K), Python-based libraries (Pandas/Numpy/Scikit-learn)

    Shows continued value in modern, scalable language stacks.

Cloud & Infrastructure:

    GCP ($122K), Kubernetes ($132K), Linux ($136K)

    Reflect demand for cloud-native and distributed systems expertise.
*/