use project3;

select * from job_data;

select ds,count(job_id) as jobs_per_day, sum(time_spent)/3600 as hours_spent from job_data group by ds order by ds;

select avg(time_spent) from job_data;

select ds, time_spent, (select avg(time_spent) from job_data as sub
     where sub.ds between DATE_SUB(main.ds, Interval 6 day) and main.ds) AS rolling_avg
FROM
    job_data AS main;
    
WITH CTE AS (SELECT ds, COUNT(job_id) AS jobs, SUM(time_spent) AS times FROM job_data GROUP BY ds) 
SELECT ds, SUM(jobs) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) / SUM(times) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS throughput_7d_rolling_avg FROM CTE;



select job_id, language, sum(time_spent)/count(job_id) *100 as percentage_share from job_data, (select sum(time_spent),count(job_id) from job_data) as total group by job_id;


SELECT language, (COUNT(*) * 100.0 / (SELECT COUNT(*) AS count FROM job_data)) AS percentage_share
FROM job_data GROUP BY language;


/*select language, round(100*count(*)/total, 2) as percentage_share from job_data cross join (select count(*) as total from job_data) group by language;*/ 

select language, count(language)/(select sum(time_spent) from job_data)* 100 as percentage from job_data group by language;

SELECT language, COUNT(*) AS total_occurrences,COUNT(*) / (SELECT COUNT(*) FROM job_data) * 100 AS percentage_share
FROM job_data GROUP BY language;

select language, count(language) as count from job_data group by language;


SELECT language,COUNT(*) AS total_occurrences,COUNT(*) / (SELECT COUNT(*) FROM job_data WHERE ds >= DATE_SUB(date(), INTERVAL 30 DAY)) * 100 AS percentage_share
FROM job_data WHERE ds >= DATE_SUB(date(), INTERVAL 30 DAY) GROUP BY language ORDER BY percentage_share DESC;

select distinct ds from job_data;

select ds,language, count(language)/count(ds)*100 as pecentage_share_each_language from job_data group by ds, language;

select language, count(*) cnt, count(*)/sum(count(*)) over()ratio from job_data 
where event in ('transfer', 'decision', 'skip') and ds >= '2020-11-01' 
    and ds <  '2020-12-01'
group by language;