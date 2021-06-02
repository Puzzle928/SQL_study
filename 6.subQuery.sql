-- 6.subQuery.sql
-- select문 내에 포함된 또 다른 select문 작성 방법
-- 참고 : join 또는 subquery로 동일한 결과값 검색, 상황에 따라 어떤 문장으로 검색할지는 그때그때 다름

-- 문법 : 비교 연산자(대소비교, 동등비교) 오른쪽에 () 안에 select문 작성 
--	   : create 및 insert 에도 사용 가능

--	   : tip - 개발시 다수의 test 위해서 원본이 아닌 복사본 table활용 권장(수업시간에 적용) 

-- 실행순서 : sub query가 main 쿼리 이전에 실행


-- tip : >purge recyclebin;
	-- oracle db 자체가 자동 생성해주는 table 단, db사용자 관점에선 불필요
	-- 따라서 쓰레기통 비우듯이 삭제 하는 명령어



/* 
페북 - 추천[클릭, 취향저격, 시청도 당연, 해당 화면에서 멈춤 ... 탐색 ...]
	table 구조 설계
		개인 정보 + 취향 + 고객 탐색 정보(은닉)  ...
		기본적으로 table 수
			경우의 수 1 : 하나의 table에 다 저장?
				join 속도는 느리니 하나의 table로 설계 ... 의심 해 보기


			경우의 수 2 : 고객 정보 table / client가 action 취하는 정보만 저장하는 취향 table / 페북이 고객들 탐색을 위한 테이블..?

			선호 방식 2번
				join or subquery 필수 
				실행 속도 test - 튜닝 후에 sql 결정

*/


--1. SMITH라는 직원 부서명 검색
select dname
from emp, dept
where ename='SMITH' and emp.deptno = dept.deptno;
  
-- sub query
-- SMITH 사원의 부서 번호 검색 후에 해당 번호와 일치되는 
-- 부서테이블의 부서 번호와 일치되는 부서명 검색
select dname
from dept
where deptno=(
	select deptno from emp where ename = 'SMITH'
);


--2. SMITH와 동일한 직급(job)을 가진 사원들의 
-- 모든 정보 검색(SMITH 포함)

select *
from emp
where job = (
	select job 
	from emp
	where ename='SMITH'
);


select *
from emp
where job = (
	select job 
	from emp
	where ename='SMITH'
) and ename != 'SMITH';


select *
from emp
where job = 'CLERK' and ename != 'SMITH';



--3. SMITH와 급여가 동일(=)하거나 더 많은(>=) 
-- 사원명(ename)과 급여(sal) 검색
-- SMITH 제외해서 검색하기
select ename, sal
from emp
where sal >= (select sal 
			from emp 
			where ename='SMITH') and ename != 'SMITH';


--4. DALLAS에 근무하는(=) 사원의 이름, 부서 번호 검색
select ename, deptno
from emp
where deptno=(select deptno 
			  from dept 
			  where loc='DALLAS');



--5. 평균(avg(sal)) 급여보다 더 많이 받는(>) 사원만 검색

select avg(sal) from emp;
select sal from emp;
select sal from emp order by sal desc;
select ename, sal from emp order by sal desc;


select ename, sal
from emp
where sal > (
	select avg(sal) from emp
);


-- 1~5번까지는 sub query의 결과가 단일 row 즉 단일 결과값



-- 다중행 서브 쿼리(sub query의 결과값이 하나 이상)
-- 6.급여가 3000이상 사원이 소속된 부서에 속한  사원이름, 급여 검색
	--급여가 3000이상 사원의 부서 번호
	-- in

select sal, deptno from emp where sal >= 3000;

select ename, sal from emp where deptno in (10, 20);
select ename, sal, deptno from emp where deptno in (10, 20);

select ename, sal
from emp
where deptno in (
	select deptno 
	from emp 
	where sal >= 3000
);

--7. in 연산자(in ())를 이용하여 부서별(groub by)로 
-- 가장 급여를 많이 받는(max()) 사원의 정보(사번, 사원명, 급여, 부서번호) 검색
select deptno, max(sal)
from emp
group by deptno;

-- group by 절에서 사용했던 컬럼명 이외에는 select 절에 사용 불가
-- 단 그룹함수의 parameter 컬럼명으론 사용 가능

select empno, ename, sal, deptno
from emp 
where (deptno, sal) in (select deptno, max(sal)
						from emp
						group by deptno);


select empno, ename, sal, deptno
from emp 
where sal in (select max(sal)
			 from emp
			 group by deptno);
	
--8. 직무(job)이 MANAGER인 사람이 속한 부서의 부서 번호와 
-- 부서명(dname)과 지역검색(loc)

select deptno, dname, loc
from dept
where deptno(select deptno from emp where job = 'MANAGER')

















select deptno, dname, loc
from dept
where deptno in (select deptno 
				from emp 
				where job='MANAGER');


