/*
this trigger is used to track employee join date, any role/department changes followed by exit/delete of employee
*/
create or replace trigger employee_changes_trigger
before insert or update or delete of job_id on employees_info
for each row
enable
begin
case
when inserting then
 insert into job_history(employee_id,job_id,starting_date,action)
              values(:NEW.employee_id,:NEW.job_id,sysdate,'Joined');
when updating then
 update job_history set ending_date=sysdate where employee_id=:OLD.employee_id and job_id=:old.job_id;
 insert into job_history(EMPLOYEE_ID,job_id,starting_date,action)
             values(:old.employee_id,:new.job_id,sysdate,'job role updated');
when deleting then
 insert into employee_bin(employee_id,first_name,last_name,gender,mail,phone,job_ID,address,pincode,hire_date)
             values(:OLD.EMPLOYEE_ID,:OLD.first_name,:OLD.last_name,:OLD.gender,:OLD.mail,:OLD.phone,:OLD.job_ID,:OLD.address,:OLD.pincode,:OLD.hire_date);
 update job_history set ending_date=sysdate,action='Exit' where employee_id=:OLD.employee_id and job_id=:old.job_id;
end case;
end;
/


-- Testing
insert into employees_info (employee_id,first_name,last_name,gender,mail,phone,address,pincode,status,job_id)
                    values(111,'scott','teledu','Female','scott@gmail.com',2222222222,'na add na istam',500085,1,10);

update employees_info set JOB_ID=30 where employee_id=101;

delete employees_info where employee_id=101;
--
select * from employees_info;
select EMPLOYEE_ID ,JOB_ID ,to_char(STARTING_DATE,'DD-MM-YYYY HH:MM:SS')starting,to_char(ENDING_DATE,'DD-MM-YY HH:MM:SS')ending,action from job_history order by employee_id;                    
SELECT * FROM employee_bin;


--27-03-2023
--trigger to include modified by and modified date in employees_info table when update happens
CREATE OR REPLACE TRIGGER employees_info_update_timestamp
BEFORE UPDATE ON employees_info
FOR EACH ROW
BEGIN
  :NEW.modified_by := USER;
  :NEW.modified_date := SYSTIMESTAMP;
END;
/





