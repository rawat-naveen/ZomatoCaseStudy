
# Zomato Case Study

This project aims to explore the Zamato Sales data to understand top sales trend, customer behaviour.

## Tables to create
drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);
## Questions to Answer

1. What is the total amount each customer spend on zomoto ?
2. How many days has each customer visited zomoto ?
3. What was the first product purchased by each customer ?
4. What is the most purchaed item on the menu and how many times was it purchased by all customer ?
5. Which item was the most popular for each customer ?
6. Which item was purchased first by the customer after they become a member ?
7. Which item was purchased just before the customerbecome a member ?
8. What is the total orders and amount spent for each member before they become a member ?
If buying each product generates points for eg 5rs = 2 zomoto points and each product has different purchasing points for eg for p1 5rs = 1 zomoto point, for p2 10rs = 5 zomoto point and p3 5rs = 1 zomoto points. Calculate total points collected by each customers and for which product most points have been given till now ?
            
9. Calculate Points collected by each customers and for which product most points have been given till now ?
11. In the first one year after a customer joins the gold program (including their join data ) irrespective, of what the customer has purchased they earn 5 zomoto points for every 10 RS spent who earned more more 1 or 3 and what was their points earnings in their yr.
12. Rank all the transaction of the customers.
13. Rank all the transaction for each number whenever they are a zomoto gold number for every non gold number transaction mark as 0.

