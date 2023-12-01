use project3;


select * from users;
select * from events;
select * from email_events;

/** Write an SQL query to calculate the weekly engagement per device.**/

select week(occurred_at) as weeks, device, count(distinct user_id) as count from events where event_type = 'engagement' group by 1,2;

/* Write an SQL query to calculate the weekly user engagement.*/

SELECT 
    COUNT(DISTINCT user_id) AS users, WEEK(occurred_at) AS weeks
FROM
    events
GROUP BY 2;



/**Write an SQL query to calculate the user growth for the product.**/

select Week, Year, Active_users, 
sum(Active_users) over (order by Year, Week rows between unbounded preceding and current row) as User_growth 
from(
select Week(activated_at) as Week,
year(activated_at) as Year, 
count(distinct user_id) as Active_users from users 
group by Year,Week
order by Year,Week
) as total_users;

with cte as (
select week(activated_at) as week, year(activated_at) as year, 
count(distinct user_id) as active_users 
from users 
group by week,year)
select week, year, active_users, 
sum(active_users) over (order by year,week rows between unbounded preceding and current row) as user_growth
from cte 
group by week,year 
order by year,week;


select distinct action from email_events;
select action, count(*) from email_events where action  = 'email_open'; /*--20459**/
select action, count(*) from email_events where action  = 'email_clickthrough'; /*---9010*/
select action, count(*) from email_events where action  = 'sent_weekly_digest'; /*--- 57267**/
select action, count(*) from email_events where action  = 'sent_reengagement_email'; /*--3653**/

/***Write an SQL query to calculate the email engagement metrics.**/

select case (when 'email_open_rate','email_clickthrough_rate'
select sum(case when actions = 'email_open' then 1 else 0 end)/sum(case when actions = 'delivered_emails' then 1 else 0 end)*100 as email_open_rate,
sum(case when actions = 'total_measured_clicks' then 1 else 0 end)/sum(case when actions = 'delivered_emails' then 1 else 0 end)*100 as email_clickthrough_rate
from ( select
	case 
    when action In ('sent_weekly_digest', 'sent_reengagement_email') then 'delivered_emails'
    when action in ('email_open') then 'email_open'
    when action in ('email_clickthrough') then 'total_measured_clicks'
	end as actions
    from email_events) as email_metrics;

/** Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.**/

with week_num as (select user_id, week(occurred_at) as week from events group by user_id,week),
(select user_id, min(week(occurred_at)) as first_week from events group by user_id)
select a.user_id, week, first_week, (week-first_week) as week_numbers from week_num;


select Weeks, sum(case when week_num = 0 then 1 else 0 end) as week_0,
sum(case when week_num = 1 then 1 else 0 end) as week_1,
sum(case when week_num = 2 then 1 else 0 end) as week_2,
sum(case when week_num = 3 then 1 else 0 end) as week_3,
sum(case when week_num = 4 then 1 else 0 end) as week_4,
sum(case when week_num = 5 then 1 else 0 end) as week_5,
sum(case when week_num = 6 then 1 else 0 end) as week_6,
sum(case when week_num = 7 then 1 else 0 end) as week_7,
sum(case when week_num = 8 then 1 else 0 end) as week_8,
sum(case when week_num = 9 then 1 else 0 end) as week_9,
sum(case when week_num = 10 then 1 else 0 end) as week_10,
sum(case when week_num = 11 then 1 else 0 end) as week_11,
sum(case when week_num = 12 then 1 else 0 end) as week_12
from (select a.user_id, week, weeks, (week-weeks) as week_num from
(select user_id, week(occurred_at) as week from events group by 1,2) a,
(select user_id, min(week(occurred_at)) as weeks from events group by user_id)b
where a.user_id = b.user_id ) as week_with_num
group by weeks
order by weeks;