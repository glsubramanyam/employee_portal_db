/*Delete Employee stored procedure
 it has 3 parameters 1. employee id to be deleted 2.status out parameter 3.message out parameter */
CREATE OR REPLACE PROCEDURE delete_employee(
    n_empno IN EMPLOYEES_INFO.employee_id%TYPE,
    o_status OUT NUMBER,
    o_message   OUT VARCHAR2  
) IS
    check_statement VARCHAR2(200);  -- to store query
    check_value     NUMBER(20); -- it takes count
BEGIN
    check_statement := 'select count(*) from EMPLOYEES_INFO where employee_id='|| n_empno|| ' and status=1'; --query
    EXECUTE IMMEDIATE check_statement INTO check_value; --execute the above query and send the result to "check_value" variable
    IF check_value != 0 THEN    --condition
    delete from employees_info where employee_id=n_empno; --mail query to delete employee by using employee id
--        UPDATE EMPLOYEES_INFO
--        SET
--            status = 0
--        WHERE
--            employee_id = n_empno;
        o_status:=1;
        o_message := n_empno|| ' deleted Successfully! Total Deleted Records: '|| check_value; --send this to out variable
    --dbms_output.put_line(n_empno||' is deleted succesfully!');
    ELSE
        o_status:=0;
        o_message := n_empno || ' Not Found!';  --send this to out variable
    --dbms_output.put_line(n_empno||o_out);
    --dbms_output.put_line(n_empno||' Not Found...');    
    END IF;

    COMMIT;
END;
/

--CALL PROCEDURE FROM ANONYMOUS BLOCK TO TEST
declare
status number(2);
msg varchar2(100);
employee_no number:=&number;
begin
delete_employee(employee_no,status,msg);
dbms_output.put_line(status);
dbms_output.put_line(msg);
end;

/

--update employees_info set status = 1 where employee_id=101;
select * from employee_bin;
select * from employees_info;