select sysdate from dual;

-- resultType="string"
select id from test;
select id from test where id = 'java';

-- resultType="int"
select age from test;

-- resutlType="date" / "java.util.Timestamp"
select reg from test;

-- resultType="com.test.model.TestDTO"
select * from test;

select count(*) from test;
select max(age) from test;
select * from test;

select * from test where id='spring03';

update test set pw='1234',age=33 where id='spring01';

-- ��ü
select count(*) from test;
select count(*) from test where age='10';

-- id,pwüũ
select COUNT(*) from test where id ='spring01' and pw='1234';
-- id ������� üũ
select count(*) from test where id='spring01';

-- id, pw, age�� ��ġ�ϴ� ���ڵ� ��
select COUNT(*) from test where id ='spring01' and pw='1234' and age=33;

--update test set pw=#{pw}, age=#{age} where id=#{id};

select count(*) from test where id in ('spring01','spring02','spring03','spring','spring100');
select * from test where id in ('spring01','spring02','spring03','spring','spring100');

select * from test where id like '%s';


select count(*) from test;
--insert into test values(#{id}, #{pw},#{age},sysdate);
