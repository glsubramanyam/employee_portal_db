/*
update existing record in database using employee id
The following are the different parameteres and the update will happens base on employee id
*/
create or replace procedure update_employee(
    n_empid      IN employees_info.employee_id%TYPE,
    v_fname      IN employees_info.first_name%TYPE,
    v_lname      IN employees_info.last_name%TYPE,
    v_gender     IN employees_info.gender%TYPE,
    v_mail       IN employees_info.mail%TYPE,
    n_phone      IN employees_info.phone%TYPE,
    n_jid        IN employees_info.job_id%TYPE,
    v_addr       IN employees_info.address%TYPE,
    n_picode     IN employees_info.pincode%TYPE,
    d_hire_date  IN employees_info.hire_date%type,
    o_status     out number,
    o_message    out varchar2
)   
is
v_exist number(2); --store count data
begin
select count(*) into v_exist from employees_info where employee_id=n_empid and status=1; --it checks whether the employee exists or not
--condition if exists then update the record
if v_exist = 1 then 
    update employees_info set first_name=v_fname,last_name=v_lname,gender=v_gender,mail=v_mail, 
    phone=n_phone,job_id=n_jid,address=v_addr,pincode=n_picode,hire_date=d_hire_date where employee_id=n_empid;  --main query
    o_status := 1; 
    o_message:='Update Successfully!';
else 
    o_status := 0;
    o_message:='Unable to update the employee details';
end if;
commit;

EXCEPTION
    WHEN dup_val_on_index THEN
        o_status:=0;    -- represents failure state
        o_message:='Already exist!'; --message
    WHEN VALUE_ERROR THEN 
        o_status:=0;    -- represents failure state
        o_message:='Unexpected error Occured!';    --message
    WHEN OTHERS THEN
        o_status:=0;    -- represents failure state
        o_message:='error occured'; --message
end;
/

--
declare
    employee_id employees_info.employee_id%type:=&enter_employee_id;
    first_name employees_info.first_name%type:='&enter_first_name';
    last_name employees_info.last_name%type:='&enter_last_name';
    gender employees_info.gender%type:='&gender';
    mail employees_info.mail%type:='&mail_id';
    phone employees_info.phone%type:=&phone;
    job_id employees_info.job_id%type:='&job_type';
    address employees_info.address%type:='&address';
    pincode employees_info.pincode%type:=&pincode;
    hire_date employees_info.hire_date%type:='&hire_date';
    o_status number(10);
    o_message varchar2(50);
begin
update_employee(employee_id,first_name,last_name,gender,mail,phone,job_id,address,pincode,hire_date,o_status,o_message);
dbms_output.put_line(o_status||' '||o_message);
end;
/

select * from employees_info;