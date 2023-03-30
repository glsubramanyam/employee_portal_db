--main table or transaction table
CREATE TABLE employees_info (
    employee_id NUMBER(10),
    first_name  VARCHAR2(50) NOT NULL,
    last_name   VARCHAR2(50) NOT NULL,
    gender      VARCHAR2(10) NOT NULL,
    mail        VARCHAR2(60),
    phone       NUMBER(10),
    job_id      NUMBER(5) NOT NULL,
    address     VARCHAR2(100) NOT NULL,
    pincode     NUMBER(10) NOT NULL,  
    status      NUMBER(1) DEFAULT 1 NOT NULL,
    CONSTRAINT pk_emp_gl PRIMARY KEY ( employee_id ),
    CONSTRAINT un_emp_gl UNIQUE ( mail ),
    CONSTRAINT ck_emp_gl CHECK ( upper(gender) IN ( 'MALE', 'FEMALE' )),
    CONSTRAINT fk_emp_gl FOREIGN KEY(pincode) REFERENCES states(pincode),
    CONSTRAINT fk_jobs_gl FOREIGN KEY(job_id) REFERENCES jobs(job_id)
);
/ 
desc employees_info;
select * from employees_info;

-----
select EMPLOYEE_ID ,FIRST_NAME ,LAST_NAME,Hire_date ,created_by,to_char(created_date,'dd-mm-yy hh:mm:ss') time,modified_by,to_char(modified_date,'dd-mm-yy hh:mm:ss') modified 
from employees_info where employee_id=129 order by employee_id;

update employees_info set hire_date='26-8-2017' where employee_id=122;
-----

--status col.
alter table employees_info 
modify status invisible; --visible

--08/03
--default sequence to genereate primary key
ALTER TABLE employees_info
MODIFY employee_id default emp_pk.nextval;

--17/03 add this column based on requirement new update in UI
ALTER TABLE employees_info
ADD hire_date date;

update employees_info set hire_date='26-12-2022' where employee_id=107;

--update on 24-03-2023
alter table employees_info
add (created_by varchar2(50) default user, TimeStamp date default systimestamp, 
        modified_by varchar2(50), modified_timestamp date);
        
alter table employees_info 
rename column modified_timestamp to modified_date;






--status table, it contains different states,city(s),... and it acts as a parent tabel
CREATE TABLE states (
    pincode NUMBER(10),
    city    VARCHAR2(50),
    state   VARCHAR2(50),
    country VARCHAR2(50),
    CONSTRAINT pk_state_gl PRIMARY KEY (pincode)
);
/
desc states;

--sample data
insert into states(pincode,city,state,country) values(500085,'hyderabad','telangana','india');
insert into states(pincode,city,state,country) values(560045,'bangalore','karnataka','india');
insert into states(pincode,city,state,country) values(600017,'chennai','tamil Nadu','india');
insert into states(pincode,city,state,country) values(520001,'vijayawada','andhra Pradesh','india');
insert into states(pincode,city,state,country) values(522002,'guntur','andhra Pradesh','india');
/
select * from states;
/
--update on 24-03-2023
alter table states
add (created_by varchar2(50) default user, TimeStamp date default systimestamp);

alter table states
rename column timestamp to created_date;
-------------







--jobs Table, it contains different job id, names of job role... and its acts as a parent table 
create table jobs(
job_id number(5),
job_name varchar2(50),
salary number(8,2),
constraint pk_jobs_gl primary key(job_id)
);
/
desc jobs;
select * from jobs;
/

--sample data
insert into jobs values(10,'Database',50000.00);
insert into jobs values(20,'Java',40000.00);
insert into jobs values(30,'FullStack',55000.00);
insert into jobs values(40,'Spring',60000.00);
insert into jobs values(50,'Testing',45000.00);
insert into jobs values(60,'Informatica',40000.00);
insert into jobs values(70,'HTML',25000.00);
insert into jobs values(80,'CSS',30000.00);
insert into jobs values(90,'UI',50000.00);

--update on 24-03-2023
alter table jobs
add (created_by varchar2(50) default user, TimeStamp date default systimestamp);

alter table jobs
rename column timestamp to created_date;






--job history table, it tracks when employee joinm when his/her role is changed or when exit
create table job_history(
employee_id number(10),
job_id number(5),
starting_date date,
ending_date date,
action varchar2(50)
--CONSTRAINT fk_empid_gl FOREIGN KEY(employee_id) REFERENCES employees_info2(employee_id),
--CONSTRAINT fk_jobid_gl FOREIGN KEY(job_id) REFERENCES jobs(job_id)
);
/
select * from job_history order by employee_id,STARTING_DATE;

--update on 24-03-2023
alter table job_history
add (created_by varchar2(50) default user, TimeStamp date default systimestamp);

alter table job_history
rename column created_date to act_performed_date;






--employee_bin table to store deleted employee data
create table employee_bin(
employee_id NUMBER(10),
    first_name  VARCHAR2(50),
    last_name   VARCHAR2(50),
    gender      VARCHAR2(10),
    mail        VARCHAR2(50),
    phone       NUMBER(10),
    job_id      number(5),
    address     VARCHAR2(50),
    pincode     NUMBER(10) 
);
/
select * from employee_bin;

alter table employee_bin 
add (deleted_by varchar2(50) default user,deleted_date date default systimestamp); 

alter table employee_bin
add hire_date date;





--manuals
insert into employees_info (employee_id,first_name,last_name,gender,mail,phone,job_id,address,pincode)
                    values(101,'GL','Subramanyam','male','glsubramanyam@gmail.com',8019028055,10,'kphb 9th phase',500085);

--dump of few employee data
GL	Subramanyam	Male	glsubramanyam@gmail.com	8019028055	10	kphb 9th phase	500085
Kabir	Syed	Male	kabir@gmail.com	9999999999	20	Vijayawada	520001
Nagendra	Sarika	Male	sarika@gmail.com	8888888888	20	Vijayawada	520001
Madhu	Nakki	Male	nakki@gmail.com	7777777777	20	Ramapuram 	600017
veera	swamy	Male	swamy@gmail.com	6666666666	30	Manyata 	560045
Kalyani	G	Female	kalyani@gmail.com	9876543210	40	Manyata	560045


commit;

--test code
select e.EMPLOYEE_ID EMPLOYEE_ID,e.FIRST_NAME FIRST_NAME,e.LAST_NAME LAST_NAME,e.GENDER GENDER,e.MAIL MAIL,
e.PHONE PHONE,e.JOB_ROLE JOB_ROLE,e.ADDRESS ADDRESS,e.PINCODE PINCODE,s.CITY CITY,s.STATE STATE,s.COUNTRY COUNTRY 
from employees_info e, states s where e.pincode=s.pincode and employee_id=101;


