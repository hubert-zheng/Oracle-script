--1.
select * from HR.EMPLOYEES e where to_char(e.HIRE_DATE, 'YYYY') > 1997;
--2.
select e.last_name, e.job_id, e.salary, e.commission_pct
  from HR.EMPLOYEES e
 where e.commission_pct is not null
 order by e.salary desc;
--3
select 'The salary of' || e.last_name || 'after a 10% raise is' ||
       round(e.salary * 1.1)
  from HR.Employees e
 where e.commission_pct is null;
--4
select e.employee_id, 'Year', 'Month'
  from hr.Employees e
  left join hr.job_history jh
    on e.employee_id = jh.employee_id
 where jh.employee_id is not null;
--4
select e.employee_id,
       EXTRACT(year FROM
               to_date(to_char(sysdate, 'yyyy-mm-dd'), 'yyyy-mm-dd')) -
       EXTRACT(year FROM e.hire_date) years,
       EXTRACT(Month FROM 
               to_date(to_char(sysdate, 'mm-dd'), 'mm-dd')) -
       EXTRACT(Month FROM e.hire_date) Months
  from hr.employees e;
  
--5
select e.last_name
  from hr.employees e
 where last_name like 'K%'
    or last_name like 'J%'
    or last_name like 'L%'
    or last_name like 'M%';
    
select e.last_name
  from hr.employees e
 where substr(e.last_name, 1, 1) in ('K', 'J', 'L', 'M')

--6
select e.last_name,
       e.salary,
       e.commission_pct as COM,
       case
         when e.commission_pct is null then
          'NO'
         else
          'YES'
       end
  from hr.employees e;

---7
select dep.department_name,loc.location_id,e.last_name,e.job_id,e.salary
  from hr.employees e
  left join hr.departments dep
    on e.department_id = dep.department_id
  left join hr.locations loc
    on dep.location_id = loc.location_id
    where loc.location_id =1800;
    
---8
select count(*) from hr.employees e where last_name like '%n';

select count(1) from hr.employees e where substr(e.last_name,-1,1)='n';

---9
select e.department_id,
       dep.department_name,
       loc.location_id,
       count(e.employee_id)
  from hr.employees e
  left join hr.departments dep
    on e.department_id = dep.department_id
  left join hr.locations loc
    on dep.location_id = loc.location_id
 group by (e.department_id), (dep.department_name), (loc.location_id);
    
---10
select e.job_id
  from hr.employees e
  left join hr.departments dep
    on e.department_id = dep.department_id
 where dep.department_id <= 20
   and dep.department_id >= 10;

---11  ȡAdministration��Executive����������Ĺ�����Ա��Ȼ������
select e.job_id, count(e.job_id) as frequency
  from hr.employees e
 group by e.department_id, e.job_id;
 
---12 ��¼��ʱ���·ݵ��ϰ���
select e.last_name,e.hire_date from hr.employees e where to_char(e.hire_date,'dd')<16;

---13  ȡlast_name,salary����salary��ǧλ��������ȡ����
select e.last_name,e.salary,round(mod(e.salary*0.001,10000))as thousands from hr.employees e;

---14   ȡ���ϼ��������Ա��last_name,manager_name,salary 
select e.last_name,
       (select m.last_name
          from hr.employees m
         where m.employee_id = e.manager_id) as manager,
       (select m.salary
          from hr.employees m
         where e.manager_id = m.employee_id) as meneger_salary
  from hr.employees e
 where e.manager_id is not null and (select m.salary from hr.employees m where m.employee_id=e.manager_id)>15000;
 
 
---15 ͬ������Ϣ�ͳ�Աƽ��н�ʡ�����н��    
select (select distinct s.department_id
          from hr.employees s
         where e.department_id = s.department_id(+))as department_id,
       (select dep.department_name
          from hr.departments dep
         where dep.department_id(+) = e.department_id)as department_name,
       (select count(*)
          from hr.employees s
         where s.department_id = e.department_id) as employees,
         (select to_char(avg(s.salary),'99999.00') from hr.employees s where s.department_id(+)=e.department_id) as avg_sal,
       e.last_name,
       e.salary,
       e.job_id
from hr.employees e;


BREAK ON department_id - 
        ON department_name ON employees ON avg_sal SKIP 1

SELECT  d.department_id, d.department_name,
        count(e1.employee_id) employees,
        NVL(TO_CHAR(AVG(e1.salary), '99999.99'),
        'No average' ) avg_sal,
        e2.last_name, e2.salary, e2.job_id
FROM    departments d, employees e1, employees e2
WHERE   d.department_id = e1.department_id(+)
AND     d.department_id = e2.department_id(+)
GROUP BY d.department_id, d.department_name,
         e2.last_name,   e2.salary, e2.job_id
ORDER BY d.department_id, employees
/
CLEAR BREAKS






---16 ƽ��������ߵĲ��������Ϻ��ȵ��˵Ĺ��ʣ�from �п���select��ѯ������������as����������ɱ��ٲμӲ�ѯ��
select e.department_id, min(e.salary)
  from hr.employees e,
       (select max(avg(s.salary)) as maxsalary
          from hr.departments dep
          left join hr.employees s
            on dep.department_id = s.department_id
         group by s.salary) maxdepartment
 where maxdepartment.maxsalary =
       (select max(avg(s.salary))
          from hr.employees s
         where s.department_id = e.department_id
         group by s.salary)
 group by e.department_id;
--������ƽ����������
select max(avg(s.salary))
  from hr.departments dep
  left join hr.employees s
    on dep.department_id = s.department_id
 group by (s.salary);
--17  û��sales �Ĳ��ű�ţ����ƣ���ַ��manager_id



--18  a ÿ������id�����ƣ�ְԱ
select dep.department_id, dep.department_name, count(*)
  from hr.departments dep
  left join hr.employees e
    on dep.department_id = e.department_id
 group by dep.department_id, dep.department_name
having count(*) > 3;
-- 18 b  ְԱͳ�ƺ�����
select dep.department_id, dep.department_name, count(*)
  from hr.departments dep
  left join hr.employees e
    on dep.department_id = e.department_id having
 count(*) = (select max(count(*))
                     from hr.departments depa, hr.employees s
                    where depa.department_id = s.department_id
                    group by depa.department_id)
 group by dep.department_id, dep.department_name;

----19 �г�Ա��Id,name,��������id������ƽ������
select e.employee_id,
       e.last_name,
       (select distinct s.department_id
          from hr.employees s
         where s.department_id = e.department_id) as department_id,
       (select to_char(avg(s.salary), '99999.00')
          from hr.employees s
         where s.department_id = e.department_id) as avg_sal, 
       e.salary
  from hr.employees e;

----20 �����ڼ�����Ӷ��Ա����࣬�г���������Ա������Ӷ�������ڼ��͹�Ӷ��Ա��   sql service datepart()���ж����ڼ�
--����ת����
select to_char(e.hire_date,'day') from hr.employees e;
--һ������ְ����һ�������
select to_char(e.hire_date, 'day'),max(e.last_name),count(*)
  from hr.employees e
having count(*) = (select max(count(*))
                     from hr.employees s
                    group by to_char(s.hire_date, 'day'))
 group by to_char(e.hire_date, 'day');
-- ���
select e.last_name,
       to_char(e.hire_date, 'day'),
       (select count(*)
          from hr.employees s
         where to_char(s.hire_date, 'day') = to_char(e.hire_date, 'day'))
  from hr.employees e
 where (select count(*)
          from hr.employees s
         where to_char(s.hire_date, 'day') = to_char(e.hire_date, 'day')) =
       (select max(count(*))
          from hr.employees s
         group by to_char(s.hire_date, 'day'))
 group by e.last_name, to_char(e.hire_date, 'day')
 order by to_char(e.hire_date, 'day');
 
 ----21 ���·��������򴴽����������
 alter session set nls_date_language = 'AMERICAN';  --ת��ΪӢ�ģ���ʾӢ���·�
 select e.last_name, to_char(e.hire_date, 'mon dd'), e.hire_date
   from hr.employees e
  order by to_char(e.hire_date, 'mm dd') asc;
 alter session set nls_date_language = 'SIMPLIFIED CHINESE';   ---ת�����������
 
 
 ----22 �ҵ�1990�ϰ��굽1991����Ȼ�ڽ��еĹ���
 select job_id
   from employees
  where hire_date between '01-JAN-1990' and '30-JUN-1990'
 INTERSECT
 SELECT job_id
   from employees
  where hire_date between '01-JAN-1991' and '30-JUN-1991';
 
 ----23 10��50��110����Ա�����5%���ʣ�60�Ų���Ա�����10%��20��80���15%����90�Ų����
 select '05% raise' as raise,
        last_name,
        employee_id,
        salary,
        salary * 0.05 as add_salary,
        salary * 1.05 as new_salary,
        department_id
   from hr.employees
  where department_id in (10, 50, 110)
 union all
 select '10% raise' as raise,
        last_name,
        employee_id,
        salary,
        salary * 0.1 as add_salary,
        salary * 1.1 as new_salary,
        department_id
   from hr.employees
  where department_id = 60
 union all
 select '15% raise' as raise,
        last_name,
        employee_id,
        salary,
        salary * 0.15 as add_salary,
        salary * 1.15 as new_salary,
        department_id
   from hr.employees
  where department_id in (20, 80)
 union all
 select 'no raise' as raise,
        last_name,
        employee_id,
        salary,
        salary * 0 as add_salary,
        salary * 1 as new_salary,
        department_id
   from hr.employees
  where department_id = 90
  group by employee_id, salary, department_id, last_name;
 
 ----24 ����ϵͳʱ����ʾ

 /*alter session set nls_date_language = 'AMERICAN'; NLS_DATE_FORMAT�����д  */
 alter session set NLS_DATE_FORMAT ='DD-MON-YYYY HH24:MI:SS'
 /*select sysdate from dual;*/
 ----25 ʱ��
 --a
 /*���Էֱ�ʹ�� SESSIONTIMEZONE / DBTIMEZONE �ڽ������鿴 session �����ݿ�ʱ����*/
 select dbtimezone from dual ;
 select sessiontimezone from dual;
 /*�� TZ_OFFSET ��ѯĳʱ���� UTC ֮��Ĳ�ֵ*/
 SELECT TZ_OFFSET('Australia/Sydney') FROM DUAL;
 SELECT TZ_OFFSET('Chile/Island') FROM DUAL;
 --b �޸�sessionʱ��
 alter session set TIME_ZONE='Australia/Sydney';
 select sessiontimezone from dual;
 --c ��ʾϵͳ����sysdate,ȡ���ǻỰ�ĵ�ǰ���ں�ʱ��current_date,���ص�����(����PM/AM��ʱ��)��ʱ������ʱ��ת��current_timestamp��ͬcurrent_timestamp����ûʱ����
 select sysdate,CURRENT_DATE,CURRENT_TIMESTAMP,LOCALTIMESTAMP from dual;
 --��Ϊ����ʱ������sysdate��ͬ��һ����ͬ
 select CURRENT_DATE from dual;
 select CURRENT_TIMESTAMP from dual;
 --d �޸�ʱ��Ϊ����������м䲻�ո�
 alter session set TIME_ZONE='Chile/EasterIsland';
 select sessiontimezone from dual;
 --e ��ǰsessionʱ����sysdate,current_date,current_timestamp,localtimestamp
 select sysdate,CURRENT_DATE,CURRENT_TIMESTAMP,LOCALTIMESTAMP from dual;
 --f �����ڸ�ʽ�Ļ� DD-MON-YYYY
 alter session set NLS_DATE_FORMAT ='DD-MON-YYYY'
 select sysdate from dual;
 
 ----26 
  alter session set nls_date_language = 'AMERICAN';  --ת��ΪӢ�ģ���ʾӢ���·�
select e.last_name,
       EXTRACT(Month FROM e.hire_date),
       to_char(e.hire_date, 'dd-mon-yyyy') as hire_date
  from hr.employees e
 where 'jan' = to_char(e.hire_date, 'mon')
 order by to_char(e.hire_date, 'yyyy mon dd') asc;
  alter session set nls_date_language = 'SIMPLIFIED CHINESE';   ---ת�����������
 
 ----27 ���Ŵ���80�İ��������ڵأ��������ƣ�����ְ�����ͳ��нˮ
 select loc.city, dep.department_name, e.job_id, sum(e.salary)
   from hr.employees e, hr.locations loc, hr.departments dep
  where e.department_id > 80
  group by rollup(loc.city, dep.department_name, e.job_id);
 
 ----28 ������id������id/����id���ϼ�������Աid���飬ͳ��ÿ������߹��ʵ���͹���
 select e.department_id,e.job_id,null as manager_id,max(e.salary),min(e.salary) from hr.employees e group by (e.department_id,e.job_id)
 union all
 select null,e.job_id,e.manager_id,max(e.salary),min(e.salary)  from hr.employees e group by (e.manager_id,e.job_id)
 ;
 
 ----29 ��ѯԱ�����salaryǰ������last_name��salary
 select e.last_name,e.salary from hr.employees e where rownum<=3 order by e.salary desc;
 
 ----30 
 
 
 
 

----sql
--group by // group by rollup(A,B,C..) // group by cube  //grouping ���� //grouping set  




--��Ȩ
GRANT CREATE USER,DROP USER,ALTER USER ,CREATE ANY VIEW ,
����DROP ANY VIEW,EXP_FULL_DATABASE,IMP_FULL_DATABASE,
����DBA,CONNECT,RESOURCE,CREATE SESSION  TO hr; --�û���

--------- plsql
---������ (��employee�������½���test_employee)
create table hr.test_employee as select * from hr.employees;

--������
create TABLE HR.job_grades_zhengxiaobin(
       "GRADE_LEVEL" VARCHAR2(3),
       "LOWEST_SAL" NUMBER,
       "HIGHEST_SAL" NUMBER
);


SELECT * FROM HR.JOB_GRADES_ZHENGXIAOBIN;
--��������
insert into hr.job_grades_zhengxiaobin(grade_level,lowest_sal,highest_sal) values ('A',1000,2999);
insert into hr.job_grades_zhengxiaobin(grade_level,lowest_sal,highest_sal) values ('B',3000,6999);
insert into hr.job_grades_zhengxiaobin(grade_level,lowest_sal,highest_sal) values ('C',7000,9999);
insert into hr.job_grades_zhengxiaobin(grade_level,lowest_sal,highest_sal) values ('D',10000,15000);
insert into hr.job_grades_zhengxiaobin(grade_level,lowest_sal,highest_sal) values ('E',15000,30000);
insert into hr.job_grades_zhengxiaobin(grade_level,lowest_sal,highest_sal) values ('F',30000,50000);
----�޸ı�ṹ
--�����
alter table hr.job_grades_zhengxiaobin add ("test" varchar2(5));
--�޸���
alter table hr.job_grades_zhengxiaobin modify("test" Number DEFAULT 1);
--������
alter table hr.job_grades_zhengxiaobin rename column "test" to "test1";
--ɾ����
alter table hr.job_grades_zhengxiaobin drop ("test");


----�������
begin
---...  


--commit;��commit������ֻ�ڻ����в�����δ����д�����ݿ���

--rollback����begin��ʼ֮��Ĳ���ȫ��ȡ��


end


----������ֹ�����������ͬ����Դ

----���ݸ��� 
insert into hr.job_grades_zhengxiaobin select * from hr.job_grades_zhengxiaobin;


----PLSQL����
DECLARE
       v_confirm varchar2(50) := sysdate; 
       v_variable varchar2(50);
BEGIN
       select ep.last_name
       into v_variable
       from hr.employees ep
       where rownum=1;
       
       dbms_output.put_line(v_variable);
       dbms_output.put_line(v_confirm);
       /*��ӡboolֵ*/
       /*dbms_output.put_line((case when v_confirm then 'true' else 'false' end));*/
EXCEPTION
       WHEN others THEN
         dbms_output.put_line('Error');
END;


----���һ��
DECLARE
       v_variable hr.employees%ROWTYPE;   --�����ͱ���
BEGIN
       select ep.*
       into v_variable
       from hr.employees ep;
     
       dbms_output.put_line(v_variable.last_name||' next: '||v_variable.last_name);
EXCEPTION
       WHEN others THEN
         dbms_output.put_line('Error'||SQLERRM);
END;


----�쳣
DECLARE
       v_variable varchar2(50);
BEGIN
  BEGIN
       select ep.last_name
       into v_variable
       from hr.employees ep;
       dbms_output.put_line(v_variable);
    EXCEPTION
       WHEN others THEN   
       dbms_output.put_line('into ERROR:'||SQLERRM);
  END;
  dbms_output.put_line('TEST after Exception Error');   --����java,��Ȼ���������Ϊ�쳣�Ѿ���������
EXCEPTION
       WHEN others THEN
         dbms_output.put_line('Error');
END;


----�ɰ󶨱����� ��sql window���޷����У���Ҫ��command���ڲſ�����
VARIABLE 	g_salary NUMBER
BEGIN
   SELECT	salary
   INTO	:g_salary 
   FROM	employees
   WHERE	employee_id = 178;  
END;
/
PRINT g_salary

----����sql windowִ�е�Ԥ���������ִ��ʱ��������value
DECLARE
  v_sal NUMBER(9,2) := &p_annual_sal;
BEGIN
  v_sal := v_sal/12;
  DBMS_OUTPUT.PUT_LINE ('The monthly salary is ' ||
                         TO_CHAR(v_sal));
END;

----ѭ��
DECLARE
  v_forloop NUMBER := 0;
BEGIN
  while v_forloop<3 loop
    v_forloop := v_forloop+1;
    dbms_output.put_line(v_forloop);
  end loop;
END;

DECLARE
  v_forloop NUMBER := 0;
BEGIN
  loop
    v_forloop := v_forloop+1;
    dbms_output.put_line(v_forloop);
  exit when v_forloop=10;
  end loop;
END;

--for
--�����ѯ��� ��ѭ��
DECLARE N NUMBER;
BEGIN
  For rec_employee IN(select * from hr.employees e where e.job_id = 'IT_PROG') LOOP
      DBMS_OUTPUT.put_line('NAME='||rec_employee.last_name);
  END LOOP;
END;


--���ѭ��


----�α�
--�����ѯ��� ��ѭ��
DECLARE N NUMBER;
BEGIN
  For rec_employee IN(select * from hr.employees e where e.job_id = 'IT_PROG') LOOP
      DBMS_OUTPUT.put_line('NAME='||rec_employee.last_name);
  END LOOP;
END;
--�α� �����ѯ��� 
DECLARE N NUMBER;
CURSOR cur_employee(p_job_id IN VARCHAR2) IS select e.last_name,e.salary from hr.employees e where e.job_id = p_job_id;
BEGIN
  For rec_employee IN (cur_employee=>'IT_PROG') LOOP
      DBMS_OUTPUT.put_line('NAME='||rec_employee.last_name);
  END LOOP;
END;

----����ṹ�� ������ʵ���ࣩ
DECLARE
l_emp_rec employees%ROWTYPE;
TYPE emp_record_type IS RECORD(last_name varchar2(25),job_id varchar2(10),salary number);

TYPE ename_table_type IS TABLE OF emp_record_type INDEX BY BINARY_INTEGER; --������
l_emp_tbl ename_table_type;
BEGIN
     select last_name,job_id,salary BULK_ROWCOUNT
     INTO l_emp_tbl
     from hr.employees e
     where e.employee_id<103;   
     --ʹ�ö���ı����
     FOR i IN 1 .. l_emp_tbl.count LOOP
       dbms_output.put_line(l_emp_tbl(i).last_name);	
     END LOOP;
     EXCEPTION
       WHEN OTHERS THEN
         dbms_output.put_line('ERROR MSG: '||SQLERRM);
END;

--����
DECLARE
  l_emp_rec employees%ROWTYPE;

  TYPE emp_record_type IS RECORD(
    last_name VARCHAR2(25),
    job_id      VARCHAR2(10),
    salary    NUMBER);
  l_rec emp_record_type;
  TYPE ename_table_type IS TABLE OF emp_record_type INDEX BY BINARY_INTEGER;
  l_emp_tbl ename_table_type;
BEGIN
  SELECT last_name, job_id, salary BULK COLLECT
    INTO l_emp_tbl
    FROM employees t
   WHERE t.employee_id < 103;

  FOR i IN 1 .. l_emp_tbl.count LOOP
    dbms_output.put_line(l_emp_tbl(i).last_name);
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Error Msg: ' || SQLERRM);
END;



----��λ������Ϣ


----�洢����
CREATE OR REPLACE PROCEDURE get_name(p_emp_id IN NUMBER DEFAULT 'unknown',
										 p_name   OUT VARCHAR2) IS
		l_name employees.last_name%TYPE;
	BEGIN
		SELECT t.last_name
			INTO l_name
			FROM employees t
		 WHERE t.employee_id = p_emp_id;
	
		p_name := l_name;
	
	END get_name;
--ʹ��
DECLARE
    l_name employees.last_name%TYPE;
BEGIN
  get_name;
  l_name:=get_name(p_emp_id=>100);
  select * from employees s
  where s.last_name = l_name;
END;
/


----����
--����
FUNCTION get_name(p_emp_id IN NUMBER) RETURN VARCHAR2 IS
		l_name employees.last_name%TYPE;
	BEGIN
		SELECT t.last_name
			INTO l_name
			FROM employees t
		 WHERE t.employee_id = p_emp_id;
	
		RETURN l_name;
	
	END;
--ʹ��

select * from hr.pack_6
----������ 



------�����
--�����  �ļ��洢
--system�û�����
select * from all_directories;
--�����ļ��洢·��
create or replace directory cux_demo_dir_001 as 'D:\software\Oracle\File Store'
--·����Ȩ(public �����û�)
grant read,write on directory cux_demo_dir_001 to public;

--hr���ļ�����
DECLARE
--file location ���Ը�dba_directory���Directory Name,���ִ�Сд
--Ҳ���Ը��������ϵľ���·��������Ǿ���·��������Ҫ�Ѹ�·����ӵ�ϵͳ��̬���� ufl_file_dir 
  file_location varchar2(256) := 'CUX_DEMO_DIR_001';    --'/vork/XXGL_BUDGET_OUTPUT/MUFGSYST...'
  file_name  varchar2(256) :='helloworld.txt';
  file_text  varchar2(256) :='THIS IS A TEST';
  file_id  utl_file.file_type;
BEGIN
  file_id :=utl_file.fopen(file_location,file_name,'W');
  utl_file.put_line(file_id,file_text);
  utl_file.fclose(file_id);
EXCEPTION
  WHEN utl_file.invalid_path THEN
    dbms_output.put_line('Invalid path'||SQLERRM);
  WHEN OTHERS THEN
    dbms_output.put_line('Others '||SQLCODE||' '||SQLERRM);
END;




----ϵͳ��
--ϵͳ������
select * from all_dependencies ad where ad.REFERENCED_NAME = 'jobs';
--�����
select * from all_objects o where o.OBJECT_NAME = 'jobs';
--��������
select * from all_triggers a where a.TABLE_NAME = 'jobs';
--������
select * from dba_indexes;
--���б�
select * from all_synonyms;
--���������ݿ����ӱ�
SELECT * FROM all_db_links;








select * from dba_users;
-- ��Hr��ACCOUNT_STATUS����open ��ִ������sql �����˺�
alter user hr identified by oracle account unlock;







---plsql ��ϰ Part A
--3 
DECLARE
		v_custid	 NUMBER(4) := 1600;
		v_custname	 VARCHAR2(300) := 'Women Sports Club';
		v_new_custid	 NUMBER(3) := 500;
	BEGIN
	  	DECLARE
		  	v_custid	  NUMBER(4) := 0;
		  	v_custname  VARCHAR2(300) := 'Shape up Sports Club';
		  	v_new_custid  NUMBER(3) := 300;
		  	v_new_custname  VARCHAR2(300) := 'Jansports Club';
	  	BEGIN
		  	v_custid := v_new_custid;
		  	v_custname := v_custname || ' ' ||  v_new_custname;
        /*test
        dbms_output.put_line(v_new_custname);*/
	  	END;
	v_custid := (v_custid *12) / 10;
          /*test*/  
        dbms_output.put_line(v_new_custid);  
	END;


--4 �ж��Ƿ�����  �ж��ܱ�4���������ܱ�400���������ܱ� 4�������ܱ�100����
DECLARE
    v_inputyear number := &input_year;
    v_output varchar2(30);
BEGIN
     case
           when (mod(v_inputyear,4)=0 and mod(v_inputyear,100)<>0 or mod(v_inputyear,4)=0 and mod(v_inputyear,400)=0 ) then v_output := v_inputyear||' is Leap year';
           else v_output := v_inputyear||' is not Leap year';
     end case;
     dbms_output.put_line(v_output);
END;

----5 
--a ��Ҫһ����ʱ�����洢���
create TABLE HR.plsqltest(
       "NUM_STORE" NUMBER(7,2),
       "CHAR_STORE" VARCHAR2(35),
       "DATE_STORE" DATE
);
--b
insert into hr.plsqltest(NUM_STORE,CHAR_STORE,DATE_STORE) values (1,'test',sysdate);
select * from hr.plsqltest;
/*delete --�ύʱɾ��������
   preserver --- �ύʱ���������  */
drop table hr.plsqltest;

---������
DECLARE
    MESSAGE varchar2(30) :='This is my first PL/SQL program';
    DATE_WRITTEN date := Current_date;
    inputtable varchar2(60);
BEGIN
  
    select * 
    into inputtable
    from hr.plsqltest
    where rownum=1;
    dbms_output.put_line(inputtable);
END;

---6 
--a ��COMMAND��������б���һ��departmentID  (��������Ѿ�������߸�ֵ����ô�Ϳ�������֮ǰ�ӡ�&����������)
accept  v_inputdepartmentID number prompt 'Enter the departmentID';
--�Զ��帴������
--TYPE employee_salary(salary hr.employee%TYPE)
VARIABLE outputchar varchar2(100);
DECLARE
salary number;
BEGIN
   /*select count(1)
   into :salary
   FROM	hr.employees e
   where e.department_id = &v_inputdepartmentID;*/
   select count(1)||' employee(s) work for department number '||&v_inputdepartmentID
   into :outputchar
   FROM	hr.employees e
   where e.department_id = &v_inputdepartmentID;
END;
/
PRINT outputchar;


--�����ѯ��� ��ѭ��
DECLARE N NUMBER;
BEGIN
  For rec_employee IN(select * from hr.employees e where e.job_id = 'IT_PROG') LOOP
      DBMS_OUTPUT.put_line('NAME='||rec_employee.last_name);
  END LOOP;
  for i in 0 .. 9
END;
--�α� �����ѯ��� 
DECLARE N NUMBER;
CURSOR cur_employee(p_job_id IN VARCHAR2) IS select e.last_name,e.salary from hr.employees e where e.job_id = p_job_id;
BEGIN
  For rec_employee IN cur_employee(p_job_id=>'IT_PROG') LOOP
      DBMS_OUTPUT.put_line('NAME='||rec_employee.last_name||rec_employee.salary);
  END LOOP;
END;



----����ṹ�� ������ʵ���ࣩ
DECLARE
TYPE emp_record_type IS RECORD(last_name varchar2(25),job_id varchar2(10),salary number);
TYPE ename_table_type IS TABLE OF emp_record_type INDEX BY BINARY_INTEGER; --������
l_emp_tbl ename_table_type;
BEGIN
     select last_name,job_id,salary BULK COLLECT
      INTO l_emp_tbl
     from hr.employees e
     where e.employee_id<103;   
     --ʹ�ö���ı����
     FOR i IN 1 .. l_emp_tbl.count LOOP
       dbms_output.put_line(l_emp_tbl(i).last_name);	
     END LOOP;
     EXCEPTION
       WHEN OTHERS THEN
         dbms_output.put_line('ERROR MSG: '||SQLERRM);
END;

--����
DECLARE
  n NUMBER;
  l VARCHAR2(10);

  l_emp_rec employees%ROWTYPE;

  TYPE emp_record_type IS RECORD(
    last_name VARCHAR2(25),
    job_id    VARCHAR2(10),
    salary    NUMBER);
  l_rec emp_record_type;
  TYPE ename_table_type IS TABLE OF emp_record_type INDEX BY BINARY_INTEGER;
  l_emp_tbl ename_table_type;
BEGIN
  SELECT last_name, job_id, salary BULK COLLECT
    INTO l_emp_tbl
    FROM employees t
   WHERE t.employee_id < 103;

  FOR i IN 1 .. l_emp_tbl.count LOOP
    dbms_output.put_line(l_emp_tbl(i).last_name);
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Error Msg: ' || SQLERRM);
END;




--b ��ѯa��departmentID��Ĺ�����Ա
/*--������ͷ
CREATE OR REPLACE PACKAGE PACK_6
AS 
--������α�
    TYPE TESTCUR IS REF CURSOR;
--����ǹ��� 
    PROCEDURE sp_test1(DWMC in VARCHAR2, LX in VARCHAR2,
P_CUR OUT TESTCUR); 
END PACK_6;
--��������
CREATE OR REPLACE PACKAGE BODY PACK_6
AS
PROCEDURE sp_test1(DWMC in VARCHAR2, LX in VARCHAR2,
P_CUR OUT TESTCUR) is
strsql varchar2(1000);
begin
  strsql:='select e.salary from hr.employees e where dwmc='':dwmc'' and lx='':lx''';
  open p_cur for strsql using dwdc,lx;--��һ��ģ�����һ��Ϊ�󶨱���
end sp_test1;
end PACK_6
*/

----7 ��ѯlast_nameΪ�����Ա�����ʣ���С��3000�����޸�+500��������3000�������
--a
accept v_salary varchar2(20) prompt 'Enter the employee name';
--b
--VARIABLE l_salary varchar2(20);
set serveroutput on;
DECLARE
    l_salary number;
BEGIN
    select e.salary
    into l_salary
    from hr.employees e
    where e.last_name='&v_salary';
    dbms_output.put_line(l_salary);
    
    if l_salary<3000 then
    dbms_output.put_line('test');
    update hr.employees set salary = l_salary+500 where last_name='&v_salary';
    dbms_output.put_line('&v_salary'||'s salary updated');
    else 
    dbms_output.put_line('&v_salary'||' earns '||l_salary);
    end if;
END;
/
set serveroutput off;

---- 8  ����һ�����ʲ�����������н���䲻ͬ�Ľ����������
accept v_salary number prompt 'Enter the salary';
DECLARE
    annual_salary number;
BEGIN
    annual_salary := &v_salary*12;
    dbms_output.put_line(annual_salary);
    if annual_salary>=20000 then
     dbms_output.put_line('The bonus is $2,000');
    elsif annual_salary<=9999 then
     dbms_output.put_line('The bonus is $500');
    else 
     dbms_output.put_line('The bonus is $1,000');
    end if;
END;
/



---- 9 
accept v_employeeid number prompt 'Enter the salary';
accept v_departmentid number prompt 'Enter the salary';
--a
SET SERVEROUTPUT ON
SET VERIFY OFF
DEFINE P_EMPNO = 100
DEFINE P_NEW_DEPTNO = 10
DEFINE P_PER_INCREASE = 2
--b
DECLARE
	V_EMPNO employees.EMPLOYEE_ID%TYPE := &P_EMPNO;
	V_NEW_DEPTNO employees.DEPARTMENT_ID%TYPE := &P_NEW_DEPTNO;
	V_PER_INCREASE NUMBER(7,2) := &P_PER_INCREASE;
BEGIN
		UPDATE employees
		SET department_id = V_NEW_DEPTNO,
                    salary	 = salary + (salary * V_PER_INCREASE/100)
		WHERE employee_id = V_EMPNO;	
		IF SQL%ROWCOUNT = 0 THEN
		  DBMS_OUTPUT.PUT_LINE ('No Data Found');
                ELSE	
		  DBMS_OUTPUT.PUT_LINE ('Update Complete');
		END IF;	
END;
/	
SET SERVEROUTPUT OFF

select * from employees;



---- 10 






