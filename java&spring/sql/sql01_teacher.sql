/*
    ������ ��ȸ : SELECT 
    SELECT [�÷��� �Ǵ� ǥ����] FROM [���̺�� �Ǵ� ���]; 
    ��ü ��ȸ : * , ���ϴ� �÷��� ��ȸ : �÷���  , �����ڷ� ���� 
*/
select * from emp;
select empno, ename from emp; 

-- ǥ����(���ͷ����)�� �÷� �̸��̿ܿ� ����ϱ⸦ ���ϴ� ������ �ۼ��Ͽ� ��°���. 
--  select �ڿ� '' ��� ���. 
--  �����ʹ� '' ����, ��Ī(alias)�� "" ���� 
select name, 'good morning' "HELLO" from professor;

select * from dept;
select dname "Department Name", ', it''s deptno : ' "test", deptno "Department Number" from dept;

-- �÷� ��Ī (Column alias) : �÷��� �ڿ� ""�� ��� ��Ī �޼� �ִ�. (select �� �����Ҷ��� ����)
select * from emp;
select empno "employee number", ename "employee name", mgr "manager" from emp; 

select deptno from emp;
-- �ߺ��� �����ϰ� select �ؿ��� 
-- ���� : 1�� �÷��տ� Ű���带 �ۼ��ص� ������ ��� �÷��� �������� �ߺ��˻縦��.
select DISTINCT deptno from emp;
select DISTINCT deptno, ename from emp;

-- ���Ῥ���� : || : �÷� ������ ��� 
select ename, job from emp; 
select ename || ' ' || job from emp; 

select * from student;
-- Student ���̺��� ����л��� �̸��� ID, ü���� �Ʒ��� ���� ���·� ���. 
-- �� ) James Seo's ID : 75true, WEIGHT is 72Kg
select name || '''s ID : ' || id || ', WEIGHT is ' || weight || 'Kg' from student;

/*
    ���ϴ� ���Ǹ� ��󳻱� : WHERE�� 
    SELECT [�÷��� �Ǵ� ǥ����] FROM [���̺�� �Ǵ� ���] WHERE [����]; 
    ������ �Ϲ� ����� ���Ǵ� ���� ���.  
*/
select * from emp;
select * from emp where empno = 7900; 
-- sal�� 1500�̻��� ������ empno, ename, job �������� 
select empno, ename, job, sal from emp where sal >= 1500;
-- ename�� SMITH�� ����� empno, ename, sal �� emp���̺��� �������� 
select empno, ename, sal from emp where ename = 'SMITH';
-- ename�� FORD�� ����� empno, ename, hiredate �� emp���̺��� �������� 
select empno, ename, hiredate from emp where ename = 'FORD';
-- hiredate�� 80/12/17 �� ������ empno, ename, job, hiredate �������� 
select empno, ename, job, hiredate from emp 
--where hiredate = '80/12/17';
--where hiredate = '80-12-17';
--where hiredate = '1980/12/17';
where hiredate = '80/12/17'; -- ���н� �迭 ��-��-��  17/DEC/80
-- �˻��� ���ǿ����� ���� �ܿ��� �� Ȭ����ǥ�� ��� ǥ������. ���� ��ҹ��� ���� 

-- �⺻��� ������ ��� : + - * / 
select ename, sal from emp where deptno = 10; 
select ename, sal+1000 from emp where deptno = 10; 
select ename, sal*0.1 "tax" from emp where deptno = 10; 

-- �񱳿����� 

select empno, ename, sal from emp where sal >= 3000; 
select empno, ename, sal from emp where ename >= 'R'; 
select empno, ename, deptno from emp where hiredate >= '82/01/01'; 
-- ���� between and 
select empno, ename, sal from emp where sal >= 2000 and sal <= 3000; -- && 
select empno, ename, sal from emp where sal between 2000 and 3000; 
-- ���� between and
select ename from emp order by ename; 
select ename from emp where ename between 'JAMES' and 'MARTIN';

-- IN ������ 
select empno, ename, deptno from emp 
where deptno in (10,20); 
select * from emp;
-- LIKE ������ : % _ �ΰ��� ��ȣ�� ���� ��� 
--      % : ���ڼ� ���� ����(0������) � ���ڰ� �͵� �������.
--      _ : ���ڼ� �ѱ��� ���ϸ�, � �����̴� �������. 
--      WHERE �÷��� LIKE '%_�� �̿��� ����';
--      ��% : ������ �����ϴ� 
--      %�� : ������ ������ 
--      %��% : ���� �����ϴ�
--      _�� : �ι�°�� ���ΰ� 
--      __�� : ����°�� ���ΰ� 
-- ���� 
select empno, ename, sal from emp 
where sal like '1%'; 
-- ���� 
select empno, ename from emp 
where ename like 'A%';
-- ��¥ 
select empno, ename, hiredate from emp 
where hiredate like '80%';
-- �Ի���� 12���� ������ 
select empno, ename, hiredate from emp 
where hiredate like '___12%';
select empno, ename from emp 
where ename like '%T%';
select empno, ename from emp 
where ename like '%N';

-- IS NULL / IS NOT NULL  : ���� �������� �𸦰�� 
-- NULL�� ������� �𸥴ٴ� ���� ������ �����̴�. 
-- NULL�� = ���ٶ�� �񱳿����ڷ� ���� ������.    == null : is null , != null : is not null 
select * from emp; 
select * from emp 
where comm is null;
select * from emp 
where comm is not null;

-- AND OR : �˻��Ҷ� WHERE�� ���ǽĿ��� ��� : AND�� OR ���� �켱������ ���� 
-- AND  : �˻������� ��� ������ �� 
-- OR   : ������ �ϳ��� ������ �� 
select empno, ename, hiredate, sal from emp 
where hiredate >= '82/01/01' and sal >= 2000; 
select empno, ename, hiredate, sal from emp 
where hiredate >= '82/01/01' or sal >= 2000; 
-- sal 1000�̻� �̸�, comm < 1000 ���� �Ǵ� ���»���� 
select * from emp 
where sal >= 1000 and (comm < 1000 or comm is null);

-- ���� : ORDER BY �����÷��� �Ǵ� �÷���ȣ (�ɼ�) 
--      �������� : ASC (default) 
--      �������� : DESC
--      SQL ������ ���� �������� �������. 
select * from emp;
select hiredate,ename from emp; 
select * from emp order by ename asc; 
select * from emp order by ename desc; 
-- sal >= 1500, �̸����� �������� 
select * from emp 
where sal >= 1500 
order by sal;
select * from emp 
order by deptno asc, sal desc;

select empno, ename, sal, deptno from emp 
order by 4, 3 desc;

/*
-- ���� ������ 
--  UNION       : ������   : �������� ��� ����, �ߺ��� �����ϰ� ���� 
--  UNION ALL   : ������+  : �������� ��� ����, �ߺ����� ���ϰ� ���� ���� 
--  INTERSECT   : ������   : �������� �ߺ��Ǵ� ���� ������, ����. 
--  MINUS       : ������   : �������� ������ ����� ������, ����.(���� �ۼ� ���� �߿�) 
    * ������ ���� ���ǻ��� 
        �� ������ select ���� ���� �÷����� �����ؾ���. 
        �� ������ select ���� ���� �÷��� ������ Ÿ���� �����ؾ���
        �� ������ �÷����� �޶� ������� 
*/    
select * from student;
select * from professor;
--Student : STUDNO NAME ID GRADE JUMIN BIRTHDAY TEL HEIGHT WEIGHT DEPTNO1 DEPTNO2 PROFNO
--Professor : PROFNO NAME ID POSITION PAY HIREDATE BONUS DEPTNO EMAIL HPAGE
-- ������ 
select studno, name, deptno1, 1 
from student where deptno1 = 101 
union 
select profno, name, deptno, 2 
from professor where deptno = 101; 

select studno, name, deptno1, 1 
from student where deptno1 = 101 
union all 
select profno, name, deptno, 2 
from professor where deptno = 101; 

-- �ߺ� ��  
select studno, name, deptno1, deptno2
from student
where deptno1 = 101
union 
select studno, name, deptno1, deptno2
from student
where deptno2 = 201;

-- intersect : ������ 
select studno,  name 
from student where deptno1 = 101
intersect
select studno, name 
from student where deptno2 = 201;

-- minus : ������ 
select empno, ename, sal 
from emp 
minus
select empno, ename, sal 
from emp 
where sal > 2500; 

/*
    ## SQL �Լ� ## 
    ������ �Լ� : �ѹ��� �Ѱ��� �࿡ ���� ó���� �ѹ� ���ִ� �Լ� : �Ѱ��� -> �Ѱ��� ��� 
    ������ �Լ� : �ѹ��� �������� �࿡ ���� ó���� �ѹ� ���ִ� �Լ� : �������� -> �Ѱ��� ��� 
    
    1) ������ �Լ� 
        �����Լ�, �����Լ�, ��¥�Լ�, �Ϲ��Լ�, ��ȯ�Լ� 
        #1. ���� �Լ� 
            LOWER('����')         : �ҹ��ڷ� ��ȯ 
            UPPER('����')         : �빮�ڷ� ��ȯ 
            LENGTH('����')        : ���� ���� ��� 
            CONCAT('����','����') : ���ڿ� ���� 
            SUBSTR('����', idx1, ����) : ���ڸ� idx1 ~ ������ŭ �߶� ��. index�� 1���ͽ��� 
            LPAD('original����', length, '���Թ���') 
                        : original�� ���ʺκп� length ���̰� �ɶ����� ���Թ��ڸ� �߰�����. 
                          'love', 6, '*' -> **love
            RPAD('original����', length, '���Թ���') 
                        : original�� �����ʺκп� ���Թ��ڸ� �߰� 
            LTRIM('org����', '�����ҹ���')
                        : org���ڿ� ���ʿ� �ִ� ������ ���� ����. '*love', '*' -> love
            RTRIM('org����', '�����ҹ���') 
                        : org���ڿ� �����ʿ� �ִ� ������ ���� ����.
        
            REPLACE('org', 'old', 'new')
                        : org���ڿ��ȿ� old�κ��� new�� ��ü 
            INSTR('����', 'Ư������') : ���ھ��� Ư�������� ��ġ �˷���. ��ġ 1 ~ 
                        'abcd', 'a' --> 1 
*/
select * from emp;
select ename, LOWER(ename) from emp; 
select ename, length(ename) from emp;
select ename, job, concat(ename, job) from emp;
select substr('abcd', 3, 2) "3,2" from dual;
select substr('abcde', -3, 2) "-3,2" from dual;
select * from student;
select name, jumin, substr(jumin, 1, 6) from student;
-- jumin �÷��� �̿��ؼ�, �л��̸��� �¾ ����, ���� �Ϸ��� ��¥ ���, deptno1 = 101 
select name, jumin, substr(jumin, 3, 4) "birthday", LPAD(substr(jumin, 3, 4) - 1,4,'0') "d-1" 
from student where deptno1 = 101;
--LPAD('original����', length, '���Թ���') 
-- emp���̺��� ename�̸��� ù �α��ڸ� *�� ǥ���ϱ� 
select ename, replace(ename, SUBSTR(ename, 1, 2), '**') from emp;
select '��ī��' "org", substr('��ī��', 1, 2) from dual;
-- ��**  : REPLACE('org', 'old', 'new') SUBSTR('����', idx1, ����)
select '��ī��' "org", replace('��ī��',substr('��ī��', 2, LENGTH('��ī��') - 1) , '**')
from dual;

/*
    2) ���� �Լ� : �ԷµǴ� ���� ������ �Լ����� ���� 
        ROUND(����, �Ҽ�����) : �ݿø� : 12.345, 2 --> 12.35
        TRUNC(����, �Ҽ�����) : ���ڿ��� �־��� �Ҽ�������ŭ �ڸ� �����ϰ� �ڴ� ���� 12.345, 2 -> 13.34
        MOD(����1, ����2)  : ����1�� ����2�� ���� �������� (�ڹ��� %) 12,10 -> 2 
        CEIL(����)        : �ø� 
        FLOOR(����)       : ���� 
        POWER(����1, ����2) : ����1�� ����2��   3,2 -> 9
*/
SELECT round(12.545, 0) from dual;
select trunc(12.345, 1) from dual;

/*
    3) ��¥ ���� �Լ� 
        # ��¥ ��� 
        ��¥ + ���� = ��¥  ex) 3�� 8��  + 3 = 3�� 11��
        ��¥ - ���� = ��¥ 
        ��¥ - ��¥ = ����  ex) 3�� 8�� - 3�� 5�� = 3
        # ��¥ �Լ� 
        SYSDATE         : �ý����� ���� ��¥�� �ð� 
        MONTHS_BETWEEN  : �� ��¥ ������ ������ 
        ADD_MONTHS      : �־��� ��¥�� ���� ���� 
        NEXT_DAY        : ���ƿ��� ��¥ 
        LAST_DAY        : �ش� ���� ������ ��¥
        ROUND           : �־��� ��¥ �ݿø�
        TRUNC           : �־��� ��¥ ����
*/
select sysdate from dual;

select MONTHS_BETWEEN(SYSDATE, '22/04/29') from dual;
select MONTHS_BETWEEN('22/04/29', '22/03/29') from dual;
select add_months(sysdate, 1) from dual;
select sysdate, next_day('22/03/29', '��') from dual;

select sysdate, round(sysdate), trunc(sysdate) from dual;

/*
    3) ����ȯ �Լ� 
        # ����Ŭ ������ Ÿ�� 
        varchar2(n) : n ��ŭ�� ���ϴ� ������ ���� ����. �ִ� 4000����Ʈ 
        number(p, s) : ���� ����, p ��ü�ڸ��� 1~38, s �Ҽ����ڸ��� -84~127�ڸ�����. ()�������� 
        date        : ��¥ 
        
        char(n)     : n ��ŭ�� �������� ���� ����. �ִ� 2000����Ʈ 
        long        : �������� �������� 2GB
        clob        : �������� �������� 4GB
        raw(n)      : ���� 2�� ������ 200byte
        long raw(n) : ���� 2�� ������ 2GB
        bfile       : �ܺ����Ͽ� ����� �����ͷ� �ִ� 4GB 
        
        # �ڵ� ����ȯ
            select 2 + '2' from dual; 
        # ���� ����ȯ 
            * �Լ� *
            TO_CHAR(����)     : ���� -> ����, ��¥ -> ���� 
            TO_NUMBER('����') : ���� -> ���� 
            TO_DATE('��¥������') : ���� -> ��¥ 
            
        ### TO_CHAR(��¥, '����') :  ��¥ -> ���� 
            * ��¥ ǥ���ϴ� ��� *
                ���� : YYYY / YY / YEAR
                �� : MM (03) / MONTH (MARCH) / MON (MAR)
                �� : DD (08) / DAY ���� / DDTH ���° ������ 
                �ð� : HH24 (24�ð�) / HH (12�ð�) 
                �� : MI 
                �� : SS 
*/
select sysdate, 
to_char(sysdate, 'YYYY') "YYYY", 
to_char(sysdate, 'RRRR') "RRRR",
to_char(sysdate, 'YY') "YY",
to_char(sysdate, 'YEAR') "YEAR"
from dual;

select sysdate, 
to_char(sysdate, 'MM') "MM", 
to_char(sysdate, 'MON') "MON",
to_char(sysdate, 'MONTH') "MONTH"
from dual;

select sysdate, 
to_char(sysdate, 'DD') "DD", 
to_char(sysdate, 'DAY') "DAY",
to_char(sysdate, 'DDTH') "DDTH"
from dual;

select sysdate, to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') from dual;

/*
        ### TO_CHAR(����, '����') : ���� -> ���� 
        * ����Ŭ ǥ���� *
        9   9�� ������ŭ �ڸ����� ǥ�� 
        0   ���ڸ��� 0���� ä��
        $   $ǥ�� ������ ǥ�� 
        .   �Ҽ��� ���� ǥ�� 
        ,   õ���� ���б�ȣ ǥ�� 
*/
select to_char(1234, '99999') from dual;
select to_char(1234, '09999') from dual;
select to_char(1234, '$9999') from dual;
select to_char(1234, '9999.99') from dual;
select to_char(1234567, '9,999,999') from dual;

-- emp ���̺��� ��ȸ�Ͽ� �̸��� 'ALLEN'�� ����� ����� �̸��� ������ ��� 
--      (sal*12)+comm ���, õ���� ���б�ȣ ǥ�� 
select empno, ename, to_char((sal*12) + comm, '999,999') "SALARY" 
from emp 
where ename = 'ALLEN'; 
-- professor ���̺��� ��ȸ, 201�μ� �������� �̸�, �޿�, ���ʽ�, ����(pay*12)+bonus ��� 
select name, pay, bonus, (pay*12)+bonus "SALARY" 
from professor 
where deptno = 201; -- �ϴ� NULL�� ����, �ڿ������ �Լ� �̿��Ͽ� �ذᰡ�� 

-- emp ���̺��� ��ȸ, comm ���� ������ �ִ� ������� 
-- empno, ename, hiredate, �� ����, 15%�λ�ȿ����� ��� 
-- ��, ���� = (sal*12)+comm ���� ���, 15% ����Ȱ͵� �ѿ����� 15% �λ�Ȱ�. ������ $ǥ�� �߰�. 
select empno, ename, hiredate, to_char((sal*12)+comm, '$999,999') "����", 
to_char(((sal*12)+comm)* 1.15, '$999,999') "����+15%" 
from emp 
where comm is not null; 

-- to_number('����') : ���� -> ���� 
select to_number('1') from dual;
select to_number('A') from dual;
-- to_date('��¥�����ǹ���') : ���� -> ��¥ 
select to_date('2022/03/10') from dual;
select to_date('2022-03-10') from dual;
select to_date('22/03/10') from dual;
select to_date('22-03-10') from dual;
select to_date('220310') from dual;

/*
    4) �Ϲ��Լ� 
        # NVL(�÷���, default��) : null���� ������ default ������ ġȯ�ؼ� ó��
        # NVL2(�÷�1, �÷�2, �÷�3) : �÷�1�� null�� �ƴϸ� �÷�2, 
                                    �÷�1�� null �̸� �÷�3
*/
-- emp ���̺� comm�� null�� �ƴϸ� sal+comm, comm�� null�̸� sal
select sal, comm, nvl2(comm, sal+comm, sal) "result"
from emp;

select comm, nvl2(comm, 'Y', 'N') "���" 
from emp; 

select ename, comm, NVL(comm, 0) 
from emp;

-- professor ���̺��� ��ȸ, 201�μ� �������� �̸�, �޿�, ���ʽ�, ����(pay*12)+bonus ��� 
select name, pay, nvl(bonus,0), (pay*12)+NVL(bonus,0) "SALARY" 
from professor 
where deptno = 201; -- �ϴ� NULL�� ����, �ڿ������ �Լ� �̿��Ͽ� �ذᰡ�� 

/*
        # DECODE() : if(���׿�����)�� ����Ŭ sql�� ������ �Լ�, ����Ŭ������ �����ϴ� �Լ� 
        #Ÿ��1. DECODE(A, B, '1', null) : ������ null�� ���� ���� A�� B�� ������ '1', �ƴϸ� null 
        #Ÿ��2. DECODE(A, B, '1', '0') : A�� B�� ������ '1', �ٸ��� '0' ���� 
        #Ÿ��3. DECODE(A, B, '1', 'C', '0') : A�� B�� ������ '1', A�� C�� ������ '0'
        #Ÿ��4. DECODE(A, B, DECODE(C, D, '1', null)) : ������ null�� ��������
                        A�� B�� ���, C��D �� ������ '1'
        #Ÿ��5. DECODE(A, B, DECODE(C, D, '1', '2'))
        #Ÿ��5. DECODE(A, B, DECODE(C, D, '1', '2'), '3')
*/
select empno, ename, deptno, decode(deptno, 10, 'NEW YORK') "LOC" 
from emp;
select empno, ename, deptno, decode(deptno, 10, 'NEW YORK', 'ETC') "LOC" 
from emp;
select empno, ename, deptno, decode(deptno, 10, 'NEW YORK', 20, 'DALLAS') "LOC"
from emp;
select empno, ename, deptno, mgr, decode(deptno, 20, DECODE(mgr, 7566, 'hahaha')) "LOC"
from emp;








































-------------------------------------------------------------------------------------
/*
    [ �����Լ� ]
    ���� 2-4 : emp ���̺���, ������ �̹���(2-4)�� ���� 20�� �μ��� �Ҽӵ� �������� �̸��� 
            2 ~ 3��° ���ڸ� '-'���� �����ؼ� ����ϼ���.
select ename,replace(ename, substr(ename, 2, 2), '--') "REPLACE" 
from emp 
where deptno = 20; 
    ���� 2-5 : Student ���̺���, ������ �̹���(2-5)�� ���� 1����(depto1)�� 101���� �л����� 
            �̸��� �ֹι�ȣ�� ����ϵ�, �ֹι�ȣ�� �� 7�ڸ��� '-'�� '/'�� ǥ�õǰ� ����ϼ���. 
select name, jumin, replace(jumin, substr(jumin, 7, 7), '-/-/-/-') "REPLACE" 
from student
where deptno1 = 101
    ���� 2-6 : Student ���̺��� ������ �̹���(2-6)�� ���� 1������ 102�� �л����� 
            �̸��� ��ȭ��ȣ, ��ȭ��ȣ���� ���ڸ� �κи� '*'ó���Ͽ� ����ϼ���. 
            ��, ��� ���ڸ��� 3�ڸ��� ����. 
select name, tel, replace(tel, substr(tel, 5,3), '***') "REPLACE" 
from student 
where deptno1 = 102; 
    ���� 2-7 : Student ���̺���, ������ �̹���(2-7)�� ���� 1������ 101���� �а� �л����� 
            �̸��� ��ȭ��ȣ�� ��ȭ��ȣ���� ���ڸ��� *�� ǥ���ؼ� ����ϼ���. 
select name, tel, replace(tel,substr(tel, instr(tel, '-')+1, 4) ,'****') "REPLACE" 
from student 
where deptno1 = 101; 
    [to_char]   
    ���� 2-8 : Student ���̺��� birthday �÷��� ����Ͽ� ������ 1���� �л��� 
            �л���ȣ(studno)�� �̸�, birthday�� ������ �̹���(2-8) �� ���� ����ϼ���. 
select studno, name, TO_CHAR(birthday, 'YYYY-MM-DD HH24:MI:SS') "BIRTHDAY" 
from student
where TO_CHAR(birthday, 'MM') = '01'; 
    ���� 2-9 : emp ���̺��� hiredate �÷��� ����Ͽ� �Ի����� 1,2,3���� ������� 
            �����ȣ(empno), �̸�(ename), �Ի����� ������ �̹���(2-9)�� ���� ����ϼ���. 
select empno, ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') "HIREDATE" 
from emp
where TO_CHAR(hiredate, 'MM') in ('01','02','03') ; 
*/
-------------------------------------------------------------------------------------







