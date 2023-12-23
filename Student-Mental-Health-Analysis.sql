Use music_data;
-- 1) Preparation and data Cleaning 
-- change the column names

alter table student_mh  rename column `Choose your gender` to Gender;
alter table student_mh 
rename column `What is your course?` to Course,
rename column `Your current year of Study` to Study_year,
rename column `What is your CGPA?` to CGPA,
rename column `Marital status` to Married,
rename column `Do you have Depression?` to Depressed,
rename column `Do you have Anxiety?` to Anxiety,
rename column `Do you have Panic attack?` to Panic_attacks,
rename column `Did you seek any specialist for a treatment?` to Need_treatment;

-- Covert CGPA to Avarage marks for better analysis 

alter table student_mh add column grade float;
update student_mh
set grade = round((substring_index(CGPA, '-',1) + substring_index(CGPA, '-', -1)) / 2,2);

-- change the datatype of Study_year column text to int 

alter table student_mh add column study_year_Y int;
update student_mh
set study_year_Y = (substring_index(Study_year,' ' ,-1));

-- Drop column which are not using in analysis
alter table student_mh drop column Timestamp;
alter table student_mh drop column Study_year;

-- 2) Data Abbreviations 

alter table student_mh add column Field varchar(25);

UPDATE student_mh
SET Field = 'IT'
WHERE course IN ('BIT', 'BCS', 'IT', 'CTS');

UPDATE student_mh
SET Field = 'Law'
WHERE course IN ('Laws', 'Law', 'Fiqh fatwa ', 'Fiqh');

UPDATE student_mh
SET Field = 'RCEP'
WHERE course IN ('KIRKHS', 'Irkhs', 'Islamic education','Pendidikan islam', 'Human Resources', 'Psychology', 'Usuluddin ', 'Malcom', 'Human Sciences ', 'Communication ', 'Pendidikan Islam ');

UPDATE student_mh
SET Field = 'Faculty of Medicine'
WHERE course IN ('Biomedical science', 'MHSC', 'Kop', 'Biotechnology', 'Diploma Nursing', 'Radiography', 'Nursing ');

UPDATE student_mh
SET Field = 'Economics and Management'
WHERE course IN ('Mathemathics', 'KENMS', 'Accounting ', 'Banking Studies', 'Business Administration', 'Econs');

UPDATE student_mh
SET Field = 'Environment'
WHERE course IN ('ENM', 'Marine science');

UPDATE student_mh
SET Field = 'Linguistics'
WHERE course IN ('TAASL', 'BENL', 'DIPLOMA TESL');

UPDATE student_mh
SET Field = 'Art'
WHERE course IN ('ALA');

UPDATE student_mh
SET Field = 'Engineering'
WHERE course IN ('KOE', 'Engine', 'engin', 'Engineering');

-- now drop the Course column
alter table student_mh 
drop column Course;

-- 3) Analysis of the data 
-- Count Field 
select Field, Count(*) as Count
from student_mh
group by Field
order by count desc;

select * from student_mh;

-- Depression by gender 
SELECT gender, count(Depressed) 
from student_mh
where  Depressed = 'Yes'
group by gender;	

-- Depression by Field 
select Field, count(Depressed) as count
from student_mh
where Depressed = 'Yes'
group by Field
order by Count desc;

-- Depression status by year of study
select study_year_Y, count(Depressed) as count
from student_mh
where Depressed = 'Yes'
group by study_year_Y
order by count desc;

-- Depression status Field by panic_attacks
select Field,count(Panic_attacks) as count
from student_mh
where Panic_attacks = 'Yes'
group by Field
order by count desc; 

-- Depression and marital status 
select Married, count(Depressed) as Depressed_count
from student_mh
group by Married,Depressed;

-- Total mental health status by gender 
select gender, 
count(case when depressed = 'Yes' then 1 end) as dep,
count(case when anxiety = 'Yes' then 1 end) as anx,
count(case when panic_attacks = 'Yes' then 1 end) as pa
from student_mh
group by gender;

-- depression status by age 
select Age, count(Depressed) as count
from student_mh
where Depressed = 'yes'
group by Age
order by Age asc;

-- grade by depressed and undepressed 
select Round(avg(grade),2) as avg_grade,Depressed
from student_mh
group by Depressed;






















  



