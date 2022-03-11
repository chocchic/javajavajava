/*

1. ���̺� ���� : CREATE 
    CREATE TABLE [���̺��] (
        �÷��� �÷�������Ÿ�� (�ɼ�),
        �÷��� �÷�������Ÿ�� (�ɼ�), 
        ....
    );
    
    �÷��� : ���ĺ��ҹ��ں����� 
    ������Ÿ�� : �ݵ�� ���    ����: varchar2(���ڱ��̰�), ����:number, ��¥: date 
    �ɼ� : �������� contraint (��������) 
            �������� �ڷᰡ �ԷµǴ� ���� �����ϱ� ���ؼ� �������� ��Ģ�� ������ ���°�
        
        not null    : null ���� ���� �� ����.  
        unique      : �ߺ���� �� �� ����.  
        primary key : �߿���. not null + unique ���·� 
                    ���̺�� �Ѱ��� �ִ� ���°� ����, ���̺�� �Ѱ� �÷��� pk ��������. 
                    ���ڵ带 �������� ������ ��. 
        foreign key : �ΰ� ���̺��� �����Ű���� �ٸ����̺��� PK�� �Ǵ� �÷��� 
                    ���� ���̺� FK �� ���� 
        default     : ����Ʈ �� ���� 
        check       : ���� üũ�� �˻��ϰ� �� �� �ִ�
        
    * ���̺� ������ ���ǻ��� 
        - ���̺� �̸��� �÷��� �׻� ���ĺ����� ���� 
            A-Z ����, 0-9����, $#_ ��밡��, ����X 
        - �÷��� ����� ��� �Ұ� 
        - �� �������� ���̺�� �ߺ� �Ұ� 
        - �� ���̺� �ȿ��� �÷��̸��� �ߺ� �Ұ�, �ٸ����̺����� �÷��̸��� �����ص� ����. 
*/
create table test(
    id varchar2(50) primary key, 
    pw varchar2(50) not null,
    age number default 1, 
    reg date default sysdate
); 
-- ����ڰ� ������ ���̺�� ��ȸ 
select table_name from user_tables;
-- ���̺� ���� Ȯ�� 
desc test;
select * from test;

/*
2. ���ڵ� �߰� : INSERT (not null �Ӽ��� ���� �÷����� �ݵ�� ���� �־��ֱ�) 
    1) ��� �÷��� ������ �߰� (���̺��ڿ� �÷������, ������ ����) 
    INSERT INTO [���̺��] VALUES( [������ ��ǥ�����ڷ� �÷�������� ����] );
        default �ɼ� ���� X 

    2) ���ϴ� �÷��� ������ �߰� (�÷��� ������ �������, ��� ���� �ۼ��� �÷���������) 
    INSERT INTO [���̺��(�÷���,�÷���,..)] VALUES( [�÷����ۼ��� ������� ���� ����] ); 
        default �ɼ��� 2)������ ��츸 ó����. 
*/
insert into test values('java', '1234', 20, sysdate); 
insert into test(pw, id, age, reg) values('java01', '1234', 10, sysdate); 
insert into test(id, pw) values('java01', '0000');

insert into test values('java02', '0000', 2, sysdate); 
insert into test values('java03', '0000', 10, sysdate);
insert into test values('java04', '0000', 30, sysdate);
insert into test values('java05', '1234', 40, sysdate);
insert into test values('java06', '0000', 50, sysdate);
insert into test values('java07', '1111', 10, sysdate);
insert into test values('java08', '1212', 10, sysdate);
insert into test values('java09', '0000', 100, sysdate);
insert into test values('java10', '0000', 5, sysdate);
commit;


select * from test;
select * from test 
where pw = '0000';
select * from test 
where age > 10;
select * from test 
order by id desc; 

/*
3. ���ڵ� ���� : UPDATE
    1) �ϰ� ���� 
        UPDATE [���̺��] SET [�÷���=��]; 
        
    2) ���ڵ� ���� ���� 
        UPDATE [���̺��] SET [�÷���=�� (,�÷���=��,...)] 
        WHERE [���ǽ�]; 
*/
select * from test;
update test set pw='0000';  -- ��� ���ڵ��� pw���� 0000���� �ٲٱ� 
commit;

update test set pw='1234' 
where id='java01';
commit;

update test set pw='1111' 
where age = 10; 
commit;

insert into test values('java11', '1234', 10, sysdate);
select * from test;

/*
4. ���ڵ� ���� : DELETE 
    1) ��ü ���ڵ� ���� 
        DELETE FROM [���̺��];     : ���̺��� ��� ������ ����, ���� �ݳ��� ������ (���̺�����)
        TRUNCATE TABLE [���̺��]; : ���̺��� ��� ������ ����, ����ϴ� ������ �ݳ� (���̺�����)
        
    2) ���ڵ� ���� ���� 
        DELETE FROM [���̺��] 
        WHERE [���ǽ�]; 
*/
delete from test 
where id = '1234';
commit;
select * from test; 

--delete from test;  ���ڵ� ��� ������ 
--truncate table test; ���ڵ� ��� ������, �����ϴ� ������ �ݳ� 

/*
5. ���̺� ���� ���� : ALTER
    1) �÷� �߰� ALTER - ADD
        ALTER TABLE [���̺��] ADD ( [�÷��� ������Ÿ�� (�ɼ�)] ); 
        
        * �÷��� �÷����̿� �߰� �Ұ�, �׻� �� �ڿ� �߰� 
        * ���̺� �̹� �����Ͱ� �� �������� not null �ɼ� �ټ� ����. default ����. 
        
    2) �÷� Ÿ�� ���� ALTER - MODIFY
        ALTER TABLE [���̺��] MODIFY ( [�÷��� ������Ÿ�� (�ɼ�)] ); 
        
        * �÷������ ������� 
        - �ش� �÷��� ũ�⸦ �ø� ���� ������ �������� ����, ���� ������ �Ѽ� ���. 
        - �ش� �÷��� NULL ���� ������ �ְų� ���̺� �ƹ� ���ڵ尡 ������ �÷��� ũ�⸦ ���� �� �ִ�. 
        - �ش� �÷��� NULL ������ ������ ������ ������ ������ ������ �� �ִ�. 
        - �ش� �÷��� DEFAULT ���� �ٲٸ� ���� ���Ŀ� �߻��ϴ� ���ڵ� ���Կ��� ������ �ش�. ������ �״�� 
        - �ش� �÷��� NULL���� ���� ��쿡�� NOT NULL �������� �߰� ����. 
        
    3) �÷� �̸� ���� ALTER - RENAME
        ALTER TABLE [���̺��] RENAME COLUMN [�� �÷���] TO [�� �÷���]; 
        
    4) �÷� ���� ALTER - DROP
        ALTER TABLE [���̺��] DROP COLUMN [�÷���]; 

        * �ѹ��� �Ѱ��� �÷��� ���� ����, ������ ���̺� �Ѱ��̻��� �÷��� �����־����. 
        * �����Ǹ� ���� �Ұ��� 
*/
select * from test;
-- �÷� �߰�
alter table test add(name varchar2(50));
commit;
-- �÷� Ÿ�� ����
alter table test modify(name number); 
-- �÷� �̸� ���� 
alter table test rename column name to nickname;
commit;
-- �÷� ���� 
alter table test drop column nickname;

/*
6. ���̺� ���� : DROP 
    : ���̺� ��ü�� ���� 
    
    DROP TABLE [���̺��]; 
*/
-- drop table test;

/*
7. ����(��Ī) : ALIAS 
    : ��ȸ�� ����� ������ ����(alias) �� �ο��ؼ� �÷� ���̺�(��)�� ������ �� �ִ�. 
    ���� ���̺��� �÷����� ������� �ʰ�, �˻��� ǥ�� �������� �ѹ� �ٴ´�. 
    
        SELECT [�÷���] [����], [�÷���] [����] FROM [���̺��] [����];
        SELECT [�÷���] as [����], [�÷���] as [����] FROM [���̺��];

        * ������ �÷��� �ٷ� �ڿ� �ۼ�
        * �÷���� ���� ���̿� AS, as Ű���带 ����� ���� �ִ�. 
        * ������ �ֵ���ǥ�� ��� ǥ���ϸ� ���� �����̳� Ư�����ڸ� ���Խ�ų �� �ְ�, 
                ��ҹ��� �����ϰ� �� ���� �ִ�. -> �ֵ���ǥ ������ ���� �ִ�.  
        * FROM���� ���̺� ������ �����ϸ�, SELECT ���忡�� ���̺�� ��� ��� ����.  
*/
select id, pw from test;
select id as "����� ���̵�", pw as ��й�ȣ from test as t;
select t.id "����� ���̵�", t.pw ��й�ȣ from test t;

/*
8. Ʈ������ Transaction 
    ������ ó���� �� ���� 
    Ʈ������ : ���� Ŀ���� �Ͼ �� ~ ���� Ŀ�� �������� �۾� 

9. �����Լ� 
    1) ���� 
        COUNT   : �������� ���� 
        SUM     : �������� ����
        AVG     : �������� ��հ�
        MAX     : �������� ���� ū�� 
        MIN     : �������� ���� ������ 
        ...
        
        * �ϳ��Ǵ� �������� �ְ�, �ϳ��� ������� ��ȯ�ϴ� ���� 
*/
select count(*) from test;
select empno, count(*) from emp;
select count(*), count(comm) from emp; 
select sum(comm) from emp; 
select avg(comm) from emp; -- null�� ������ ������ ��� 
select avg(nvl(comm, 0)) from emp; -- null�� ī��Ʈ�ؼ� ��ü ��� 
select max(hiredate) from emp; -- ���� �ֽ� 
select min(hiredate) from emp; -- ���� ������ 
select * from emp;

/*
10. GROUP BY : Ư�� �������� �������� �׷�ȭ 

    GROUP BY [�׷��� ����] 
    
    * WHERE �� ��, ORDER BY ��. 
*/
select deptno, count(*) from emp 
--where 
group by deptno
order by 2 desc; 

select * from emp;
-- job�� ��������, �� ������ �ش��ϴ� �����, ������ ��� �޿�,
--  ������ �ְ� �޿�, �ּ� �޿�, �޿��հ� 
select job, count(*) "�ο���", round(avg(sal),2) "��� �޿�",
max(sal) "�ְ� �޿�", min(sal) "�����޿�",
sum(sal) "�޿� �հ�"
from emp
group by job;

/*
11. HAVING �� 
    WHERE ������ �����Լ� ��� �Ұ�. 
    �����Լ��� ���� ���Ҷ� ��� 
*/
-- job���� �������� 3���̻��� job�� �ο��� ��� 
select job, count(empno) "������" 
from emp 
--where count(*) > 3
group by job
having count(empno) >= 3;
-- ��ü ������ 5000�� �ʰ��ϴ� JOB�� ����, 
-- job�� �� �޿� �հ踦 ��ȸ, 
-- ��, job�� 'SALESMAN' �� �����ϰ� �� �޿� �հ�� �������� ���� 
select job, sum(sal) "�޿� �հ�" 
from emp
where job != 'SALESMAN'     -- �����Լ��� ���ǻ�� �Ұ� 
group by job                -- �ݵ�� �÷����̿;�, ����X
having sum(sal) > 5000 
order by sum(sal) desc;

/*
12. ���� ���� 
    : ������ �ȿ� �������� �ۼ��ϴ� ���� 
    
    SELECT * FROM [���̺��];
    
    SELECT * FROM ( ���������� ); 
    SELECT * FROM ( ����������( �������� ) ); 
*/
select empno, sal from (select empno, ename, sal from emp); 
select * 
from (
    select empno, ename, job 
    from emp
    
) where sal > 3000; -- ����, ���������� sal �� ��� �ܺο��� ���ǰ˻� �Ұ� 

select * from emp;
-- �����ȣ 7900�� ������ ������ ���� ������ ���� ����� �̸��� ���� ��� 
select empno, ename, job 
from emp
where job = (select job from emp where empno = 7900); 

/*
13. ���� JOIN 
    : �� �̻��� ���̺��� �����Ͽ� �����͸� �˻��ϴ� ��� 
    �� ���̺� ��� �Ѱ��� �÷��� ���� �����ϴ� ���¿��� �Ѵ�. 
    
    test  a,b,c,d,e
    ����ȭ : �ϳ��� ���̺��� �������� ���̺�� �������� �������� �и��ϴ� ���. 
    ����ȭ�� �������̺� ����� �ִ� �����͵��� �����ؼ� �������� ����� �����̴�. 

    [Oracle Join]
    select a.col1, b.col1 from table1 a, table2 b where a.col2=b.col2; 
    [ANSI Join]
    select a.col1, b.col1 from table1 a [inner] join table2 b on a.col2=b.col2;
    
    1) EQUI Join  ����� 
        
*/
select * from emp e, dept d
where d.deptno = e.deptno; 
-- empno, ename, dname ��� 
-- Oracle 
select empno, ename, dname 
from emp e, dept d
where e.deptno = d.deptno; 
-- ANSI 
select e.empno, e.ename, d.dname 
from emp e join dept d
on e.deptno = d.deptno; 

-- �л����̺�� �������̺��� join �Ͽ� 
-- �л��̸��� ���������̸��� ��� (profno) 
SELECT s.name "�л��̸�" , p.name "���������̸�"
from student s, professor p 
where s.profno = p.profno; 

/*
14. SELF Join 
    �����ϰ� ���� �����Ͱ� �ϳ��� ���̺� �� ����ִ� ��� 
*/
-- ������ȣ, �����̸��� �ش� ������ ����� ��ȣ�� �̸� ��� 
select e1.empno, e1.ename, e1.mgr, e2.ename 
from emp e1, emp e2 
where e1.mgr = e2.empno; 

/*
15. ������ SEQUENCE
    : ����(unique)�� ���� �������ִ� ����Ŭ ��ü 
    �������� �����ϸ� ���������� �����ϴ� �÷��� �ڵ������� ���� �� �� �ְ�, 
    �ַ� PK�� ����� ���� �Ѵ�. 
    number Ÿ���� pk ���� �����Ҷ� ���. 
    �������� ���̺���� ���������� ����ǰ� �����ȴ�. 

    1) ������ ���� 
        
        CREATE SEQUENCE [��������] (�ɼ�); 
        
        * �ɼ� : �������� 
        START WITH n : �������� ���۰��� ����. 
        INCREMENT BY n : ������ ����. DEFAULT 1 
        MAXVALUE : �ִ밪 
        MINVALUE : �ּҰ� 
        CYCLE / NOCYCLE : �ִ밪 ���޽� ��ȯ ���� 
        CACHE n / NOCACHE : ������ �����ӵ��� �����ϱ� ���� ĳ�̿��� ����.  

        * �������� : ���̺��_seq   seq_���̺�� 

    2) ������ ��� 
        ��������.CURRVAL    : ������� ������ ��ȣ. 
        ��������.NEXTVAL    : ������ȣ 
        
    3) ������ ���� 
        DROP SEQUENCE [��������]; 
*/
create sequence test_seq nocache;
commit;
select test_seq.nextval from dual;
select test_seq.currval from dual;
select * from test;

insert into test values('pikachu', '1111', test_seq.nextval, sysdate); 

drop sequence test_seq;

-- ����1. student(�л�), department(�а�), professor(����) ���̺� join �Ͽ� 
--      �л��̸�, �л����а��̸�(dname), ���������̸� ���  
--       ��, �л��� �а��� DEPTNO1�� �������� ã�� 
-- ����2. student ���̺��� ��ȸ�Ͽ� 1������ 101���� �л����� �̸��� 
--      �� �л����� ���������̸��� ����ϼ���. 












