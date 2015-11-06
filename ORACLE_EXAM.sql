-- 1.选择题
1 B
2 B
3 ABC
4 C
5 C

-- 基础题

--包头
create or replace package CUX_PLSQL_EXAM8814_PKG is

  -- Author  : HUBERT
  -- Created : 2015/9/29 14:06:30
  -- Purpose : 
 --1 根据学号、课程号返回学生的学科成绩
 FUNCTION get_core(p_studentid in hr.hand_student_core.student_no%TYPE,
                  p_courseid  in hr.hand_student_core.course_no%TYPE)RETURN number;
 --2 记录日志信息到表HAND_LOG                
 PROCEDURE store_errormessge(p_CODE in hr.hand_log.code%TYPE,
                            p_MSG  in hr.hand_log.msg%TYPE);
 --3 添加10条学生信息到表HAND_STUDENT
 PROCEDURE add_student10;
 --4 根据学号、课程号 按成绩的20%进行加分
 PROCEDURE add_core(p_studentid in hr.hand_student_core.student_no%TYPE,
                    p_courseid  in hr.hand_student_core.course_no%TYPE,
                    p_core      out hr.hand_student_core.core%TYPE);
end CUX_PLSQL_EXAM8814_PKG;

-- 包体

create or replace package body CUX_PLSQL_EXAM8814_PKG is

-- 1.	编写一个函数， 根据学号、课程号返回学生的学科成绩。如获取不到，则返回值 -1；如能找到多行数据，则返回 -2； 如有其他异常，则返回 -3； 

FUNCTION get_core(p_studentid in hr.hand_student_core.student_no%TYPE,
                  p_courseid  in hr.hand_student_core.course_no%TYPE)
  RETURN number IS
  v_result number := 0;
BEGIN
  SELECT stc.core
    INTO v_result
    FROM hr.hand_student_core stc
   WHERE stc.student_no = p_studentid
     AND stc.course_no = p_courseid;
  RETURN v_result;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN - 1;
  WHEN too_many_rows THEN
    RETURN - 2;
  WHEN OTHERS THEN
    RETURN - 3;
END get_core;

--2	编写一个存储过程（自治事务），记录日志信息到表HAND_LOG中，其中参数CODE（错误代码）、MSG（错误信息）为必输字段、KEY1到KEY5为非必输字段，默认为空 。
PROCEDURE store_errormessge(p_CODE in hr.hand_log.code%TYPE,
                            p_MSG  in hr.hand_log.msg%TYPE) IS
BEGIN
  INSERT INTO hr.hand_log
    (code, msg)
  VALUES
    (p_CODE, p_MSG);
END store_errormessge;

--3.	编写一个存储过程，添加10条学生信息到表HAND_STUDENT中，数据格式及逻辑，学号：s100 ... 109、姓名：王001 … 王010、年龄：22、性别：学号最后一位是奇数为“男”，偶数为“女”。（5分）
PROCEDURE add_student10 IS
BEGIN
     FOR i IN 0 .. 9 LOOP
      -- dbms_output.put_line('奇偶：'||mod(i,2));
       IF mod(i,2)=1 then
         --dbms_output.put_line('奇数');
         INSERT INTO hr.hand_student
           (student_no, student_name, student_age, student_gender)
         VALUES
           (concat('s10',to_char(i)), concat('王00',to_char(i)), '22', '男');
       ELSE
         --dbms_output.put_line('偶数');
         INSERT INTO hr.hand_student
           (student_no, student_name, student_age, student_gender)
         VALUES
           (concat('s10',to_char(i)), concat('王00',to_char(i)), '22', '女');
       END IF;
     END LOOP;
     commit;
EXCEPTION WHEN OTHERS THEN
     dbms_output.put_line('addstudent10 ERROR'); 
END add_student10;


-- 4.	编写一个存储过程，根据学号、课程号 按成绩的20%进行加分，如果增加后的分数大于100，则取消加分。同时在存储过程中返回增加后的成绩。
PROCEDURE add_core(p_studentid in hr.hand_student_core.student_no%TYPE,
                   p_courseid  in hr.hand_student_core.course_no%TYPE,
                   p_core      out hr.hand_student_core.core%TYPE) IS
  v_core    number;
  v_addcore number;
BEGIN
  SELECT stc.core
    INTO v_core
    from hr.hand_student_core stc
   where stc.student_no = p_studentid
     and stc.course_no = p_courseid;
  v_addcore := v_core * 1.2;
  IF v_addcore > 100 then
    p_core := v_core;
  ELSE
    p_core := v_addcore;
  END IF;
END add_core;


end CUX_PLSQL_EXAM8814_PKG;


----脚本代码
---- 1.	编写匿名块，调用上述程序包中函数获取选修了“胡明星”老师的学生的各科成绩，直接用DBMS_OUTPUT输出“姓名、学号、课程、成绩”。如果返回成绩异常，则调用上述自治事务存储过程记录信息（CODE=函数返回值，MSG=学生姓名）。
DECLARE
  resultcore number;
  erroemsg varchar2(50);
  CURSOR get_stuid_couid IS SELECT st.student_no,co.course_no,st.student_name,co.course_name
    from hr.hand_student st,hr.hand_teacher te, hr.hand_course co, hr.hand_student_core stc
   where te.teacher_no = co.teacher_no
     and co.course_no = stc.course_no
     and stc.student_no = st.student_no
     and te.teacher_name = '谌燕';
BEGIN
     FOR stuid_couid IN get_stuid_couid LOOP
       resultcore :=CUX_PLSQL_EXAM8814_PKG.get_core(p_studentid => stuid_couid.student_no,p_courseid =>stuid_couid.course_no);
       erroemsg := stuid_couid.student_name;
       dbms_output.put_line('姓名：'||stuid_couid.student_name||'、学号：'||stuid_couid.student_no||'、课程：'||stuid_couid.course_name||' 成绩：'||resultcore);
     END LOOP;
EXCEPTION 
  WHEN OTHERS THEN
       CUX_PLSQL_EXAM8814_PKG.store_errormessge(p_MSG =>erroemsg,p_CODE =>resultcore);
       dbms_output.put_line('获取出错'||SQLERRM);
END;

---- 2.	编写匿名块，先调用上述第3个存储过程添加学生数据。再在匿名块中创建一个和HAND_STUDENT表结构一样的表，命名为HAND__STUDENT_TEMP。然后将HAND_STUDENT表中数据全部插入到HAND__STUDENT_TEMP表中。 
BEGIN
    CUX_PLSQL_EXAM8814_PKG.add_student10;
END;
DECLARE
BEGIN
  EXECUTE IMMEDIATE ('CREATE TABLE HAND_STUDENT_TEMP AS (SELECT * FROM HAND_STUDENT)'); 
  EXCEPTION WHEN OTHERS THEN dbms_output.put_line('CREATE TABLE ERROR'||SQLERRM);
END;



select st.student_no,st.student_name,co.course_name,stc.core from hr.hand_student_core stc,hr.hand_student st,hr.hand_course co where stc.student_no=st.student_no and stc.course_no= co.course_no and stc.core<70;
---- 3.	编写匿名块，调用上述第4个存储过程对平均成绩在70以下的学生的各科成绩进行加分。然后直接用DBMS_OUTPUT输出“姓名、学号、课程、加分前成绩、加分后成绩”。
DECLARE
    CURSOR get70below IS 
        select st.student_no, st.student_name,co.course_name, stc.core,stc.course_no
          from hr.hand_student_core stc, hr.hand_student st, hr.hand_course co
         where stc.student_no = st.student_no
           and stc.course_no = co.course_no
           and stc.core < 70;
    v_addresult number;
BEGIN
    FOR s70below in get70below LOOP
        CUX_PLSQL_EXAM8814_PKG.add_core(p_studentid =>s70below.student_no,p_courseid =>s70below.course_no,p_core =>v_addresult);
        dbms_output.put_line('姓名：'||s70below.student_name||'、学号：'||s70below.student_no||'、课程：'||s70below.course_name||' 加分前成绩：'||s70below.core||' 加分后成绩：'||v_addresult);
    END LOOP;

END;


----	进阶题
---1.	在表HAND_STUDENT上创建一个触发器，当表数据新增、更新或删除时，都在表HAND_STUDENT_HIS新增一条记录，记录LAST_UPDATE_DATE及STATUS。
CREATE OR REPLACE TRIGGER secure_hand_student
  BEFORE INSERT OR UPDATE OR DELETE ON HAND_STUDENT
  FOR EACH ROW
BEGIN
  IF inserting then
  INSERT INTO hr.hand_student_his(last_update_date,status)values(sysdate,'N');
  IF updating then
  INSERT INTO hr.hand_student_his(last_update_date,status)values(sysdate,'U');
  IF deleting then 
  INSERT INTO hr.hand_student_his(last_update_date,status)values(sysdate,'D');
END;
---2.	编写匿名块，将所有学生的“姓名、学号、课程名、成绩”信息保存到集合中，并使用学号作为索引。然后在程序中判断学号“s200”是否存在集合中，若不存在，则在集合中新增一条数据（姓名=张三丰、学号=s200、课程=PHP，成绩=80）
DECLARE
TYPE stucolletion IS RECORD(
     student_name varchar2(20),
     student_id number,
     course_name varchar2(20),
     studentcore number);

BEGIN
END;

---3.	编写一个存储过程，没有任何参数。在程序中进行数据分析。1）	以学生为维度，分析每个学生所学课程中的最高分和最低分。需要的结果是（姓名、学号、最高分、最高分课程名、最低分、最低分课程名）；2）	以教师为维护，分析每个教师所教课程中的最高分和最低分。需要的结果是（教师名、课程名、课程最高分、最高分学生姓名、课程最低分、最低分学生姓名）；将以上分析的结果数据，分别写入两个文件，文件名分别为 student.txt和teacher.txt。注意写入文件中的数据，需要换行。

CREATE OR REPLACE PROCEDURE analyse IS
BEGIN
  
END;



BEGIN
     FOR i IN 0 .. 9 LOOP
       dbms_output.put_line('奇偶：'||mod(i,2));
       IF mod(i,2)=1 then
         dbms_output.put_line('奇数');
         INSERT INTO hr.hand_student
           (student_no, student_name, student_age, student_gender)
         VALUES
           (concat('s10',to_char(i)), concat('王00',to_char(i)), '22', '男');
       ELSE
         dbms_output.put_line('偶数');
         INSERT INTO hr.hand_student
           (student_no, student_name, student_age, student_gender)
         VALUES
           (concat('s10',to_char(i)), concat('王00',to_char(i)), '22', '女');
       END IF;
     END LOOP;
END;


select * from hr.hand_teacher te,hr.hand_course co where te.teacher_no=co.teacher_no;

select * from hr.hand_teacher te,hr.hand_course co,hr.hand_student_core stc where te.teacher_no=co.teacher_no and co.course_no=stc.course_no and te.teacher_name = '胡明星';
