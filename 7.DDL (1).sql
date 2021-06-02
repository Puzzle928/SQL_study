-- 7.DDL.sql
-- DDL(Data Definition Language) : 데이터 정의 언어
-- table 생성(create)과 삭제(drop), table 구조 수정(alter)


/*
[1] table 생성 명령어
    create table table명(
		칼럼명1 칼럼타입[(사이즈)] [제약조건] ,
		칼럼명2....
    ); 

[2] table 삭제 명령어
	drop table table명;

[3] table 구조 수정 명령어
	- 서비스 중에 table 구조 변경은 엄청난 일
	alter table table명 ..
*/

--1. table삭제 
drop table test;

-- 불필요한 table 정리
purge recyclebin;


--2. table 생성  
-- name(varchar2(20byte)), age(number(3)) 칼럼 보유한 people table 생성
create table people(
	name varchar2(20),
	age number(2)
);




-- 3. 서브 쿼리 활용해서 emp01 table 생성
-- (이미 존재하는 table기반으로 생성)
-- emp table의 모든 데이터로 emp01 생성
-- 4. 서브쿼리 활용해서 특정 칼럼(empno)만으로 emp02 table 생성
drop table emp01;

create table emp01 as select * from emp;
desc emp01;
select * from emp01;

drop table emp02;
create table emp02 as select empno from emp;
desc emp02;
select * from emp02;



--5. ?deptno=10 조건문 반영해서 empno, ename, deptno로 
-- emp03 table 생성
drop table emp03;

create table emp03 as select empno, ename, deptno 
from emp
where deptno=10;

desc emp03;
select * from emp03;





-- 6. ? 데이터 insert없이 table 구조로만 새로운 emp04 table생성시 
-- 사용되는 조건식 : where=거짓

drop table emp04;
create table emp04 as select * from emp where 1=0;
desc emp04;
select * from emp04;



-- emp01 table로 실습해 보기

-- alter 명령어로 이미 존재하는 table의 구조를 조작

--7. emp01 table에 job이라는 특정 칼럼 추가(job varchar2(10))
-- 이미 데이터를 보유한 table에 새로운 job칼럼 추가 가능 
-- add() : 컬럼 추가 함수

desc emp01;
drop table emp01;
create table emp01 as select empno, ename from emp;
desc emp01;

-- job 컬럼 추가(add(컬럼명 타입(사이즈)))
alter table emp01 add (job varchar2(10));

desc emp01;
select * from emp01;


--8. 이미 존재하는 칼럼 사이즈 변경 시도해 보기
-- 데이터 미 존재 칼럼의 사이즈 크게 또는 작게 수정 가능
-- modify(컬러명 타입(크기))

desc emp01;
alter table emp01 modify(job varchar2(20));
desc emp01;

desc emp01;
alter table emp01 modify(job varchar2(10));
desc emp01;


--9. 이미 데이터가 존재할 경우 칼럼 사이즈가 큰 사이즈의 컬럼으로 변경 가능 
-- 혹 사이즈 감소시 주의사항 : 
-- 			이미 존재하는 데이터보다 적은 사이즈로 변경 절대 불가
		-- 데이터 크기 보다 컬럼 사이즈를 적게 변경시도는 데이터 손실하려는 악행!!!
		-- RDBMS는 절대 허락하지 않음 
drop table emp01;
create table emp01 as select empno, ename, job from emp;
select * from emp01;
desc emp01;
 
-- 기존 컬럼 사이즈보다 크게 수정
alter table emp01 modify(job varchar2(20));
desc emp01;
select * from emp01;

-- 기존 컬럼 및 데이터 사이즈보다 작게 수정
-- 오류 왜? 데이터 크기보다 작게 수정 시도는 무조건 실패
alter table emp01 modify(job varchar2(5));
desc emp01;
select * from emp01;

alter table emp01 modify(job varchar2(10));
desc emp01;
select * from emp01;

--10. job 칼럼 삭제 
-- 데이터 존재시에도 자동 삭제 
-- drop 
-- drop시에 필요 정보 : 1번 - 컬럼명만


desc emp01;
alter table emp01 drop column job;
desc emp01;
select * from emp01;

--11. emp01을 test01로 table 이름 변경
rename emp01 to test01;
desc emp01;
desc test01;

--12. table의 순수 데이터만 완벽하게 삭제하는 명령어 
truncate table test01;

-- 12-1 단계 : table의 데이터만 삭제 -> 검색 -> 복원 -> 검색
	-- 삭제 도 가능, 복원도 가능
	-- 복원시 명령어 : >rollback;

	-- rollback은 영구 저장된 시점이 A라 가정 ...insert/update/delete... rollback시 A지점까지 복구
select * from test01;
delete from test01;
rollback;  -- 복원 명령어
select * from test01;

-- 12-2단계 : table의 데이터만 삭제 -> 검색 -> 복원 -> 검색
	-- 삭제후 데이터 복원 불가 !!!!!

select * from test01;
truncate table test01;
rollback;   -- 의미없음
select * from test01; -- 데이터 없음
-- 12-3. 참고 drop table 은 복원 불가 