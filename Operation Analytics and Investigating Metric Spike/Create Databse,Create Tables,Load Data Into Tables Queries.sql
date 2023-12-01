/*** Create Databse***/
/**** Create tables***/
/**** Load Data into table***/

create database project3;
show databases;

use project3;

/*Table job_data*/


create table job_data(
ds varchar(50),
job_id int,
actor_id int,
event varchar(50),
language varchar(50),
time_spent int,
org varchar(10));

select * from job_data;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/job_data.csv"
INTO TABLE job_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

alter table job_data add column temp_ds date;

update job_data set temp_ds = str_to_date(ds, '%m/%d/%Y')

alter table job_data drop column ds;

alter table job_data change column temp_ds ds date;



/* Table 1 - Users*/

create table users ( 
user_id int primary key,
created_at varchar(100),
company_id int,
language varchar(50),
activated_at varchar(100),
state varchar(50));


select * from users;

show variables like 'secure_file_priv';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Table-1 users.csv"
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select*from users;

Alter table users add column temp_created_at datetime;

/*SET SQL_SAFE_UPDATES = 0;*/

Update users set temp_created_at = str_to_date(created_at, '%d-%m-%Y %H:%i');

Alter table users drop column created_at;

Alter table users change column temp_created_at created_at datetime;

/* Table 2 - events*/



create table events ( 
user_id int,
occurred_at varchar(100),
event_type varchar(50),
event_name varchar(100),
location varchar(50),
device varchar(100),
user_type int);


LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Table-2 events.csv"
INTO TABLE events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select * from events;

Alter table events 
add column temp_occurred_at datetime;

Update events 
set temp_occurred_at = str_to_date(occurred_at, '%d-%m-%Y %H:%i');

Alter table events 
drop column occurred_at;

alter table events change column temp_occurred_at occurred_at datetime;

describe events; 



/* Table 3 - email_events*/



create table email_events ( 
user_id int,
occurred_at varchar(100),
action varchar(100),
user_type int);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Table-3 email_events.csv"
INTO TABLE email_events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Alter table email_events add column temp_occurred_at datetime;

Update email_events set temp_occurred_at = str_to_date(occurred_at, '%d-%m-%Y %H:%i');

alter table email_events drop occurred_at;

alter table email_events change column temp_occurred_at occurred_at datetime;