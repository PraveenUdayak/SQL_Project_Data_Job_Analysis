# Introduction
This project was based on gathering data on Data-Analyst roles and gaining insight into the top-paying jobs, the most demanded skills and their correlation.

SQL Queries are located here: [Project Folder](/project_sql/)

# Background 
This project was done in order to gain experience and further my abilities on SQL. To do this I decided to take on this project developed by Luke Barousse. This project was born from a desire to find the correlation between the top-paid and most in-demand job skills so that we can learn what skills would be the best to focus on for Data Analysts.

### What are we looking for through these SQL queries?
1. What are the top-paying data analyst jobs?
2. What are the skills required for these jobs?
3. Which required skills are in most demand?
4. Which required skills correlate with higher pay?
5. What are the most optimal skills to learn?

# Tools I Used
To analyze the data there were mutliple tools used:

- **SQL:** The main analysis tool I used and learned throughout this project, allowed me to query databases.
- **PostgreSQL:** The database management system I used to handle the job posting data.
- **Visual Studio Code:** Database management purposes and to execute my SQL queries.
-**Git and GitHub:** Allowed me to use version control and share my SQL scripts and analysis, reliably enabling project tracking.

# Analysis
### Query 1: What are the top-paying data analyst jobs?
For this query I found the highest paying data analyst roles by filtering the data for remote positions that have the salaries included using the following code:

```sql
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
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
This query's results showed that the there was a wide disparity between salaries even within the top 10 jobs based on pay, the range was 184k-650k. The positions associated with these positions were also also across a broad range, from 'Data Analyst' to 'Director of Analytics'.

### Query 2: What are the skills required for these jobs?
Here we find the skills that are required for the jobs we filtered through in the previous query.

```sql
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
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```
The results show that SQL was mentioned the most followed by Tableau, R and Excel/Pandas. This shows us that on average for the higher paying data analyst jobs we can expect SQL to be within the job description and probably Tableau as well.

### Query 3: Which required skills are in most demand?
We found the common skills in Data Analyst jobs but now we want to find the ones that are in most demand, this allowed us to know which skills are the most translatable ones, helping us focus on certain skills over others.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = 'True'
GROUP BY
    skills
ORDER BY   
    demand_count DESC
LIMIT 5
```
The results are shown here: 

| Skill     | Demand Count |
|-----------|--------------|
| SQL       | 7,291        |
| Excel     | 4,611        |
| Python    | 4,330        |
| Tableau   | 3,745        |
| Power BI  | 2,609        |

From observing this chart we can see that SQL is incredibly high in demand relative to the other skills we found. SQL seems to be the most preferred mode of data management while Excel and Python are the most in demand for coding and analysis.

### Query 4: Which required skills correlate with higher pay?
We found the most in-demand skills but now we want to see which skills correlate with higher pay regardless of their demand.
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
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
```
- Big Data & ML Tools: PySpark, DataRobot, Databricks, Airflow, Scikit-learn, Pandas, Numpy, Jupyter all rank high. These reflect data science and AI/ML workflows.

- DevOps & Collaboration Tools: Bitbucket, GitLab, Jenkins, Atlassian, Kubernetes, Notion. High salaries suggest DevOps engineers and platform engineers are well-compensated.

- Programming Languages: Swift ($153K), Go ($145K), Scala ($125K), Python-based libraries (Pandas/Numpy/Scikit-learn). Shows continued value in modern, scalable language stacks.

- Cloud & Infrastructure: GCP ($122K), Kubernetes ($132K), Linux ($136K).
Reflects demand for cloud-native and distributed systems expertise.

### Query 5: What are the most optimal skills to learn?
Now that we have seen what skills are in most demand and what skills are most valuable, we will now use all the data we have gathered to decide which skills are most optimal to learn. (The refined version of the code will be shown)

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id)>10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25
```
This chart shows the results from the query:
| Skill      | Demand Count | Average Salary (USD) |
|------------|--------------|-----------------------|
| SQL        | 398          | $97,237               |
| Excel      | 256          | $87,288               |
| Python     | 236          | $101,397              |
| Tableau    | 230          | $99,288               |
| Power BI   | 110          | $97,431               |
| R          | 148          | $100,499              |
| SAS        | 63           | $98,902               |
| PowerPoint | 58           | $88,701               |

- SQL (398) and Excel (256) have the highest demand counts, this suggests they are foundational in data-related roles.

- Python (236) and Tableau (230) also show strong demand, which was foreseen due to their importance in data analysis and visualization.

- Excel is widely required but has a lower average salary ($87,288), indicating it’s expected in entry-to-mid level roles.

- Python and R offer a good balance of high demand and high salary—skills worth investing time into if you're aiming for upward mobility.

# What I learned
This project served as a practical capstone to reinforce my newly acquired SQL skills. By analyzing real job market data, I learned how to extract meaningful insights to answer a focused question: What are the most in-demand and high-paying skills for aspiring data analysts?

Key Takeaways:
- **SQL Proficiency:** Gained confidence in writing complex queries, including GROUP BY, JOIN, and ORDER BY operations to clean, aggregate, and analyze data.

- **Data-Driven Insight:** Learned how to quantify demand and salary trends to support strategic career decisions.

- **Skill Value Mapping:** Identified which tools (e.g., Python, Tableau, SQL) offer the best balance between job demand and average salary. This is very helpful both for my own growth and for advising others entering the field.

- **Project Workflow:** Practiced the full project pipeline. From asking the right question to querying the data, cleaning results, and interpreting the output.

- **Markdown & Reporting:** Improved how I communicate findings by formatting results clearly in Markdown for GitHub, making the data accessible and easy to understand.

# Conclusions
### **Insights**
- **SQL and Excel are Must Haves:**
These two showed up as the most in-demand by far, SQL (398 listings) and Excel (256), making them essential for any data analyst role.

- **Python Pays Off:**
Python had one of the highest average salaries ($101K+) and strong demand. It’s clearly a valuable skill for analysts who want to further their career.

- **Visualization Tools Matter:**
Tableau and Power BI both had solid demand and high salaries, highlighting the importance of being able to tell and show stories with data, not just analyze it and leave a bunch of words.

- **Demand ≠ Pay:**
Excel and SQL are widely required but don’t necessarily lead to the highest-paying roles. More technical tools like Python, R, and Tableau had fewer listings but higher salaries, suggesting they open doors to more specialized or senior roles whereas the former skills are more in tune with entry level positions. 

- **Balance is Key:**
A smart skill stack might combine:
→ SQL + Excel (high demand)
→ Python + Tableau (high salary)
This gives both marketability and future earning potential.

### **Closing Thoughts**
This project was honestly a fun way to start my SQL learning. I didn’t just want to write random queries—I wanted to actually answer a question I care about: “What skills do I need to land a solid data analyst role?” Digging into real data and turning it into something useful felt super rewarding and helped me confirm what skills I want to focus on and learn. I also realized that even a simple analysis can give you powerful insights if you ask the right questions. I am excited to keep building from here, more data, more tools, more projects so that I can further my skills both in SQL and other data analysis tools. 😊 

