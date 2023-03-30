CREATE OR REPLACE PROCEDURE insert_employee_json (
  p_json_input IN VARCHAR2
) AS
    --v_empid  employees_info.employee_id%TYPE;
    v_fname  employees_info.first_name%TYPE;
    v_lname  employees_info.last_name%TYPE;
    v_gender employees_info.gender%TYPE;
    v_mail   employees_info.mail%TYPE;
    v_phone  employees_info.phone%TYPE;
    v_jid     employees_info.job_id%TYPE;
    v_addr   employees_info.address%TYPE;
    v_picode employees_info.pincode%TYPE;
    d_hire_date employees_info.hire_date%TYPE;

BEGIN
     -- Parse JSON input
    --v_empid:=JSON_VALUE(p_json_input, '$.EMPLOYEE_ID');
    v_fname:=JSON_VALUE(p_json_input, '$.FIRST_NAME');
    v_lname:=JSON_VALUE(p_json_input, '$.LAST_NAME');
    v_gender:=JSON_VALUE(p_json_input, '$.GENDER');
    v_mail:=JSON_VALUE(p_json_input, '$.MAIL');
    v_phone:=JSON_VALUE(p_json_input, '$.PHONE');
    v_jid:=JSON_VALUE(p_json_input, '$.JOB_ID');
    v_addr:=JSON_VALUE(p_json_input, '$.ADDRESS');
    v_picode:=JSON_VALUE(p_json_input, '$.PINCODE');
    d_hire_date:=JSON_VALUE(p_json_input, '$.HIRE_DATE');

   -- Insert values into table  (employee_id   v_empid,)
 INSERT INTO employees_info (first_name,last_name,gender,mail,phone,job_id,address,pincode,hire_date) 
                    VALUES (v_fname,v_lname,v_gender,v_mail,v_phone,v_jid,v_addr,v_picode,d_hire_date);
 COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        --dbms_output.put_line('emplpoyee id: '|| v_empid|| ' or mail: '|| v_mail|| ' already exist!');
        dbms_output.put_line('emplpoyee id or mail already exist! '||'('||v_mail||')');
    WHEN OTHERS THEN
        dbms_output.put_line('error occured');
END;
/

-- passing json format data
DECLARE
  json_str VARCHAR2(1000) := '[{"FIRST_NAME": "Hello", "LAST_NAME": "HI","GENDER":"Male","MAIL":"HELLO.HI@gmail.com","PHONE":9876543210, "JOB_ID": 20,"ADDRESS":"hyd","PINCODE":500085,"HIRE_DATE":"30-12-1998"}]';
BEGIN
  insert_employee_json(json_str);
END;
/


SELECT * FROM EMPLOYEES_INFO order by employee_id;



-- '[{"EMPLOYEE_ID": 113, "FIRST_NAME": "DJ", "LAST_NAME": "T","GENDER":"Male","MAIL":"DJTIlu@gmail.com","PHONE":9876543210, "JOB_ID": 20,"ADDRESS":"GUNTUR","PINCODE":522002,"HIRE_DATE":"30-12-1998"}]'