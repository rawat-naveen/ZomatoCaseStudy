CREATE DATABASE zomoto;
USE zomoto;

CREATE TABLE goldusers_signup(userid INT, gold_signup_date DATE);
INSERT INTO goldusers_signup(userid,gold_signup_date) VALUES (1,'2017-09-22'), (3,'2017-04-21');
SELECT * FROM goldusers_signup;

CREATE TABLE users(userid INT, signup_date DATE);
INSERT INTO users(userid,signup_date) VALUES (1,'2014-09-02'),(2,'2015-01-15'),(3,'2014-11-04');
SELECT * FROM users;

CREATE TABLE sales(userid INT, created_date DATE, product_id INT);
INSERT INTO sales(userid,created_date,product_id) VALUES (1,'2017-04-19',2), (3,'2019-12-18',1), (2,'2020-07-20',3), 
														 (1,'2019-10-23',2), (1,'2018-03-19',3), (3,'2016-12-20',2), 
                                                         (1,'2016-11-09',1), (1,'2016-05-20',3), (2,'2017-09-24',1), 
                                                         (1,'2017-03-11',2), (1,'2016-03-11',1), (3,'2016-11-10',1), 
                                                         (3,'2017-12-07',2), (3,'2016-12-15',2), (2,'2017-11-08',2), 
                                                         (2,'2018-09-10',3);

SELECT * FROM sales;

CREATE TABLE product(product_id INT, product_name TEXT, price INT);
INSERT INTO product(product_id, product_name, price) VALUES (1, 'p1', 980),(2,'p2',870),(3,'p3',330);
SELECT * FROM product;

-- DataSets are
SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;


-- 1. What is the total amount each customer spend on zomoto;

SELECT t1.userid, SUM(t2.price) AS 'Total' 
FROM sales AS t1
JOIN product AS t2
ON t1.product_id = t2.product_id
GROUP BY t1.userid
ORDER BY t1.userid;

-- 2. How many days has each customer visited zomoto?
SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;


SELECT userid, COUNT(distinct created_date) AS 'visit'
FROM sales
GROUP BY userid;

-- 3. What was the first product purchased by each customer?
SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;

SELECT * FROM (
	SELECT *,
	RANK() OVER(partition by userid order by created_date ) AS 'Rank'
	FROM sales) as t
WHERE t.rank= 1;

-- 4. What is the most purchaed item on the menu and how many times was it purchased by all customer ?
SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;

-- The most purchaed item on the menu

SELECT product_id
FROM sales
GROUP BY product_id
ORDER BY COUNT(product_id) DESC LIMIT 1;

-- how many times was it purchased by all customer 

SELECT userid , COUNT(product_id) AS 'Total' FROM sales
WHERE product_id = (SELECT product_id
FROM sales
GROUP BY product_id
ORDER BY COUNT(product_id) DESC LIMIT 1)
GROUP BY userid;


-- 5. Which item was the most popular for each customer?
SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;


SELECT * FROM 
(
SELECT *,
	RANK() OVER(partition by userid ORDER BY Cnt DESC)  AS 'Popular'
FROM
( SELECT userid, product_id , COUNT(product_id) AS Cnt 
FROM sales
GROUP BY product_id, userid
ORDER BY userid
) as t
) as b
WHERE Popular = 1;

-- 6. Which item was purchased first by the customer after they become a member?

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;

SELECT * FROM
(SELECT t1.userid,t1.gold_signup_date, t2.created_date, t2.product_id,
RANK() OVER(partition by t1.userid ORDER BY created_date) AS r
FROM goldusers_signup AS t1
JOIN sales AS t2
ON t1.userid = t2.userid
AND created_date >= gold_signup_date 
) AS t
WHERE r = 1
;

-- 7. Which item was purchased just before the customerbecome a member?

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;
SELECT * FROM
(
SELECT t1.userid, t2.gold_signup_date ,t1.created_date,
RANK() OVER(partition by userid ORDER BY created_date desc) AS r
FROM sales AS t1
JOIN goldusers_signup AS t2
ON t1.userid = t2.userid
AND created_date <= gold_signup_date
) AS t
WHERE
r = 1;

-- 8. What is the total orders and amount spent for each member before they become a member ?

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;

SELECT userid, COUNT(*) AS "Visit", SUM(price) AS "Total"FROM
(
SELECT t1.userid, t1.gold_signup_date, t3.price, t2.created_date
FROM goldusers_signup AS t1
JOIN sales AS t2
ON t1.userid = t2.userid
JOIN product AS t3
ON t2.product_id = t3.product_id
AND created_date <= gold_signup_date
) as t
GROUP BY userid
ORDER BY userid;

-- 9. If buying each product generates points for eg 5rs = 2 zomoto points and each product has different purchasing points 
   -- for eg for p1 5rs = 1 zomoto point, for p2 10rs = 5 zomoto point and p3 5rs = 1 zomoto points.
 --   Calculate total points collected by each customers and for which product most points have been given till now.
   
SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;

SELECT userid, SUM(Points) FROM
(
SELECT c.userid, c.product_id, SUM(price) as Total_sum,
	(
    CASE
		WHEN product_id = 1 THEN ROUND(SUM(price) /5,0)
        WHEN product_id = 2 THEN ROUND(SUM(price) /2,0)
        WHEN product_id = 3 THEN ROUND(SUM(price) /5,0)
        END
    ) AS "Points"
FROM
(
SELECT t2.*,t1.price FROM
product AS t1
JOIN 
sales AS t2
ON 
t1.product_id = t2.product_id
) AS c
GROUP BY c.userid,c.product_id
ORDER BY userid
) AS b
GROUP BY userid;


-- 10. Calculate Points collected by each customers and for which product most points have been given till now.
SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;

SELECT c.product_id, SUM(Total_Points) FROM
(
SELECT b.* ,
	(
      CASE
		WHEN product_id = 1 THEN ROUND(total_sum/5,0)
        WHEN product_id = 2 THEN ROUND(total_sum/2,0)
        WHEN product_id = 3 THEN ROUND(total_sum/5,0)
        END
	) AS "Total_Points"
FROM
(
SELECT a.userid, a.product_id, SUM(price) AS total_sum FROM
(
SELECT t1.userid, t2.product_id, t2.price  FROM sales AS t1
JOIN product AS t2
ON t1.product_id = t2.product_id 
) AS a
GROUP BY a.userid, a.product_id
ORDER BY userid
) AS b
) as c
GROUP BY product_id
;


-- 11. In the first one year after a customer joins the gold program (including their join data ) irrespective, of what the customer has purchased 
    -- they earn 5 zomoto points for every 10 RS spent who earned more more 1 or 3 and what was their points earnings in their yr?

-- 1 zp = 2rs
-- 0.5 zp = 1rs

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;


SELECT a.*, ROUND(c.price * 0.5,0) AS total_points FROM
(
SELECT t1.userid, t2.product_id,  t2.created_date ,t1.gold_signup_date FROM goldusers_signup AS t1
JOIN sales AS t2
ON t1.userid = t2.userid
AND t2.created_date >= t1.gold_signup_date AND t2.created_date <= date_add(gold_signup_date ,INTERVAL 1 year)
) AS a
JOIN 
product AS c
ON a.product_id = c.product_id
;

-- 11. Rank all the transaction of the customers.

SELECT * FROM sales;
SELECT * FROM product;
SELECT * FROM users;
SELECT * FROM goldusers_signup;


SELECT *,
	rank() OVER(partition by userid order by created_date) AS Rnk
FROM 
sales;

-- 13.Rank all the transaction for each number whenever they are a zomoto gold number for every non gold number transaction mark as 0.

SELECT * FROM sales;
SELECT * FROM goldusers_signup;




SELECT a.*, 
	CASE WHEN a.gold_signup_date IS NULL THEN 0 ELSE RANK() OVER(partition by userid order by created_date DESC)  END as rnk
from
(
SELECT t1.userid, t1.created_date ,t2.gold_signup_date,t1.product_id
FROM  sales AS t1
LEFT JOIN goldusers_signup AS t2
ON t1.userid = t2.userid
AND t1.created_date >= t2.gold_signup_date) as a;
