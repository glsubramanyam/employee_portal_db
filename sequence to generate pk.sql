/*The sequence is created to generate primary keys of each new recored inserted into employee_info table*/
create sequence emp_pk --sequence name
start with 100  --initial value
increment by 1  
minvalue 100
maxvalue 100000
nocycle;    --once it reaches 100000 then the sequence will end

emp_pk.nextval -- to print next sequence number
emp_pk.currval -- to print current sequence number

--to check the next values of (note: the values is consider as used in next iteration it skips this value and genereate new sequence number)
--to check current value of sequence
SELECT emp_pk.currval FROM dual;

--testing
insert into employees_info (employee_id,first_name,last_name,gender,mail,phone,job_id,address,pincode)
                    values(emp_pk.nextval,'Kabir','Syed','male','kabir@gmail.com',9999999999,20,'Vijayawada eat streat',520001);
