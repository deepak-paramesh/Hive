-bash-4.1$ vi users.txt
1	Amit	100	DNA
2	Sumit	200	DNA
3	Yadav	300	DNA
4	Sunil	500	FCS
5	Kranti	100	FCS
6	Mahoor	200	FCS

-bash-4.1$ vi locations.txt
1	UP
2	BIHAR
3	MP
4	AP
5	MAHARASHTRA
6	GOA

USE default;

CREATE TABLE users
(
id INT,
name STRING,
salary INT,
unit STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t';

CREATE TABLE locations
(
id INT,
location STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t';

LOAD DATA LOCAL INPATH 'users.txt'
INTO TABLE users;

LOAD DATA LOCAL INPATH 'locations.txt'
INTO TABLE locations;

-------------------------------------------
Getting maximum salary across all the units
-------------------------------------------
SELECT unit, MAX(salary) FROM users
GROUP BY unit;

DNA	300
FCS	500

-------------------------------------------
Getting list of employees who have maximum salary across all the units
-------------------------------------------
--Not possible with GROUP BY

SELECT id, name, salary, rank FROM
(
SELECT id, name, salary, rank() OVER (PARTITION BY unit ORDER BY salary DESC) AS rank
FROM users
) temp
WHERE rank = 1;

--------------------------
RANK according to salary
--------------------------

--Skips intermediate numbers in case of a tie.

SELECT rank() OVER (ORDER BY salary), id, name, salary, unit
FROM users;

1	1	Amit	100	DNA
1	5	Kranti	100	FCS
3	2	Sumit	200	DNA
3	6	Mahoor	200	FCS
5	3	Yadav	300	DNA
6	4	Sunil	500	FCS

-------------------------------
DENSE_RANK according to salary
-------------------------------

--Doesn't skip intermediate numbers in case of a tie.

SELECT dense_rank() OVER (ORDER BY salary), id, name, salary, unit
FROM users;

1	1	Amit	100	DNA
1	5	Kranti	100	FCS
2	2	Sumit	200	DNA
2	6	Mahoor	200	FCS
3	3	Yadav	300	DNA
4	4	Sunil	500	FCS

---------------------------------------------
DENSE_RANK according to salary for every unit
---------------------------------------------

SELECT dense_rank() OVER (PARTITION BY unit ORDER BY salary DESC) AS rank, id, name, salary, unit
FROM users;

1	3	Yadav	300	DNA
2	2	Sumit	200	DNA
3	1	Amit	100	DNA
1	4	Sunil	500	FCS
2	6	Mahoor	200	FCS
3	5	Kranti	100	FCS

---------------------------------------------
Top 2 highest paid employees for every unit
---------------------------------------------

SELECT name, salary, unit, rank 
FROM
(
SELECT dense_rank() OVER (PARTITION BY unit ORDER BY salary DESC) AS rank, id, name, salary, unit
FROM users
) temp
WHERE rank <= 2;

Yadav	300	DNA	1
Sumit	200	DNA	2
Sunil	500	FCS	1
Mahoor	200	FCS	2

-----------------------------------------------------------------------------
Getting current name and salary alongwith next higher salary in the same unit
-----------------------------------------------------------------------------

SELECT name, salary, LEAD(salary) OVER (PARTITION BY unit ORDER BY salary)
FROM users;

Amit	100	200
Sumit	200	300
Yadav	300	NULL
Kranti	100	200
Mahoor	200	500
Sunil	500	NULL

-------------------------------------------------------------------------------------
Getting current name and salary alongwith next to next higher salary in the same unit
-------------------------------------------------------------------------------------

SELECT name, salary, LEAD(salary, 2) OVER (PARTITION BY unit ORDER BY salary)
FROM users;

Amit	100	300
Sumit	200	NULL
Yadav	300	NULL
Kranti	100	500
Mahoor	200	NULL
Sunil	500	NULL

------------------------------------------------------------------------------------------------------------------
Getting current name and salary alongwith next to next higher salary in the same unit replacing NULL with -1
------------------------------------------------------------------------------------------------------------------

SELECT name, salary, LEAD(salary, 2, -1) OVER (PARTITION BY unit ORDER BY salary)
FROM users;

Amit	100	300
Sumit	200	-1
Yadav	300	-1
Kranti	100	500
Mahoor	200	-1
Sunil	500	-1

-------------------------------------------------------------------------------------
Getting current name and salary alongwith the closest lower salary
-------------------------------------------------------------------------------------

SELECT salary, LAG(salary) OVER (PARTITION BY unit ORDER BY salary)
FROM users;

100	NULL
200	100
300	200
100	NULL
200	100
500	200
