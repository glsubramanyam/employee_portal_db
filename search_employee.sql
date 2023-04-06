/*
Search of an employee
for this it has two parameters one is input parameer its either employee id or employee name or employee mail id
and out parameter is of cursor type and it contains output result

*/
CREATE OR REPLACE PROCEDURE sp_search_employee(colvalue IN VARCHAR2,c_cur OUT SYS_REFCURSOR,o_message out varchar2) 
IS  
    --NO_DATA_FOUND exception;
    v_employee_id number(10);
    sql_query VARCHAR2(1000);
    c_mail number(2);
BEGIN
    -- trys to convert into number if converted then search by employee id else mail or name
    BEGIN
        v_employee_id := TO_NUMBER(colvalue);
    EXCEPTION
        WHEN VALUE_ERROR THEN
            v_employee_id := NULL;
    END;    
 --check whether input contains @ symbol or not if there then search by mail id
 select regexp_count(colvalue,'@') into c_mail from dual;   
 IF v_employee_id IS NOT NULL THEN  --condition
     sql_query := 'select e.EMPLOYEE_ID EMPLOYEE_ID,e.FIRST_NAME FIRST_NAME,e.LAST_NAME LAST_NAME,e.GENDER GENDER,e.MAIL MAIL,
                  e.PHONE PHONE,e.JOB_ID JOB_ID,j.JOB_NAME JOB_NAME,j.SALARY SALARY,e.HIRE_DATE HIRE_DATE,e.ADDRESS ADDRESS,e.PINCODE PINCODE, S.CITY CITY,s.STATE STATE,s.COUNTRY COUNTRY
                  from employees_info e, states s, jobs j where e.pincode=s.pincode and e.job_id=j.job_id and status=1 and employee_id='||v_employee_id||' order by employee_id';
    OPEN c_cur FOR sql_query;   --open cursor for above query
 elsif c_mail>=1 then
     sql_query := 'select e.EMPLOYEE_ID EMPLOYEE_ID,e.FIRST_NAME FIRST_NAME,e.LAST_NAME LAST_NAME,e.GENDER GENDER,e.MAIL MAIL,
                 e.PHONE PHONE,e.JOB_ID JOB_ID,j.JOB_NAME JOB_NAME,j.SALARY SALARY,e.HIRE_DATE HIRE_DATE,e.ADDRESS ADDRESS,e.PINCODE PINCODE,s.CITY CITY,s.STATE STATE,s.COUNTRY COUNTRY 
                 from employees_info e, states s,jobs j where e.pincode=s.pincode and e.job_id=j.job_id and status=1 and regexp_like(lower(mail),lower('''||colvalue||''')) order by employee_id';
    OPEN c_cur FOR sql_query; 
 else
    sql_query := 'select e.EMPLOYEE_ID EMPLOYEE_ID,e.FIRST_NAME FIRST_NAME,e.LAST_NAME LAST_NAME,e.GENDER GENDER,e.MAIL MAIL,
                 e.PHONE PHONE,e.JOB_ID JOB_ID,j.JOB_NAME JOB_NAME,j.SALARY SALARY,e.HIRE_DATE HIRE_DATE,e.ADDRESS ADDRESS,e.PINCODE PINCODE,s.CITY CITY,s.STATE STATE,s.COUNTRY COUNTRY 
                 from employees_info e, states s,jobs j where e.pincode=s.pincode and e.job_id=j.job_id and status=1 and regexp_like(lower(first_name||'' ''||last_name),lower('''||colvalue||''')) order by employee_id';
    OPEN c_cur FOR sql_query;
 end if;
IF c_cur%notfound THEN
    o_message:='No data found!';
END IF;

END;
/

--execution part(testing)
CREATE OR REPLACE PROCEDURE sp_execute_employee(
    col_value VARCHAR2
) IS
    sql_res SYS_REFCURSOR;
    type my_rec_typ is record(
    employee_id employees_info.employee_id%type,
    first_name employees_info.first_name%type,
    last_name employees_info.last_name%type,
    gender employees_info.gender%type,
    mail employees_info.mail%type,
    phone employees_info.phone%type,
    job_id employees_info.job_id%type,
    job_name jobs.job_name%type,
    salary jobs.salary%type,
    hire_date employees_info.hire_date%type,
    address employees_info.address%type,
    pincode employees_info.pincode%type,
    city states.city%type,
    state states.state%type,
    country states.country%type
);
    r_var1 my_rec_typ;
    o_message varchar2(100);
BEGIN
    sp_search_employee(col_value, sql_res,o_message);
    LOOP
        FETCH sql_res INTO r_var1;
        EXIT WHEN sql_res%notfound;
        dbms_output.put_line(r_var1.employee_id|| ','|| r_var1.first_name|| ','|| r_var1.last_name|| ','|| r_var1.gender || ','|| r_var1.mail
        ||','||r_var1.phone||','||r_var1.job_ID||','||r_var1.job_name||','||r_var1.salary||','||r_var1.hire_date||','||r_var1.address||','||r_var1.pincode||','||r_var1.city||','||r_var1.state||','||r_var1.country);
        END LOOP;
        dbms_output.put_line(o_message);
END;
/
--calling part
exec sp_execute_employee('&enter_search_key');
select * from employees_info;


/*
--Named PLSQL Block with output 
create or replace procedure sp_search_test_demo(colvalue varchar2)
as
c_cur SYS_REFCURSOR;
sql_query varchar2(1000);
v_employee_id number(10);
c_mail number(2);
--v_vari number(10):=&enter_employee_id;

type my_rec_typ is record(
    employee_id employees_info.employee_id%type,
    first_name employees_info.first_name%type,
    last_name employees_info.last_name%type,
    gender employees_info.gender%type,
    mail employees_info.mail%type,
    phone employees_info.phone%type,
    job_id employees_info.job_id%type,
    address employees_info.address%type,
    pincode employees_info.pincode%type,
    city states.city%type,
    state states.state%type,
    country states.country%type
); 
    r_var1 my_rec_typ;
BEGIN
    BEGIN
        v_employee_id := TO_NUMBER(colvalue);
    EXCEPTION
        WHEN VALUE_ERROR THEN
            v_employee_id := NULL;
    END;  
 select regexp_count(colvalue,'@') into c_mail from dual;
 IF v_employee_id IS NOT NULL THEN
     sql_query := 'select e.EMPLOYEE_ID EMPLOYEE_ID,e.FIRST_NAME FIRST_NAME,e.LAST_NAME LAST_NAME,e.GENDER GENDER,e.MAIL MAIL,
                  e.PHONE PHONE,e.JOB_id JOB_id,e.ADDRESS ADDRESS,e.PINCODE PINCODE, S.CITY CITY,s.STATE STATE,s.COUNTRY COUNTRY
                  from employees_info e, states s where e.pincode=s.pincode and employee_id='||v_employee_id;
    OPEN c_cur FOR sql_query;
 elsif c_mail>=1 then
     sql_query := 'select e.EMPLOYEE_ID EMPLOYEE_ID,e.FIRST_NAME FIRST_NAME,e.LAST_NAME LAST_NAME,e.GENDER GENDER,e.MAIL MAIL,
                 e.PHONE PHONE,e.JOB_ID JOB_ID,e.ADDRESS ADDRESS,e.PINCODE PINCODE,s.CITY CITY,s.STATE STATE,s.COUNTRY COUNTRY 
                 from employees_info e, states s where e.pincode=s.pincode and regexp_like(lower(mail),lower('''||colvalue||'''))';
    OPEN c_cur FOR sql_query; 
 else
    sql_query := 'select e.EMPLOYEE_ID EMPLOYEE_ID,e.FIRST_NAME FIRST_NAME,e.LAST_NAME LAST_NAME,e.GENDER GENDER,e.MAIL MAIL,
                 e.PHONE PHONE,e.JOB_ID JOB_ID,e.ADDRESS ADDRESS,e.PINCODE PINCODE,s.CITY CITY,s.STATE STATE,s.COUNTRY COUNTRY 
                 from employees_info e, states s where e.pincode=s.pincode and regexp_like(lower(first_name||'' ''||last_name),lower('''||colvalue||'''))';
    OPEN c_cur FOR sql_query;
 end if;
 
    loop
        FETCH c_cur INTO r_var1;
        EXIT WHEN c_cur%notfound;
        dbms_output.put_line(r_var1.employee_id|| ','|| r_var1.first_name|| ','|| r_var1.last_name|| ','|| r_var1.gender || ','|| r_var1.mail
        ||','||r_var1.phone||','||r_var1.job_ID||','||r_var1.address||','||r_var1.pincode||','||r_var1.city||','||r_var1.state||','||r_var1.country);
    END LOOP;
    
close c_cur;
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('data not found or not available');
END;
/
exec sp_search_test_demo('@gmail');

git
*/