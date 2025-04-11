/*******************************************************
 * Project: Sales Time Intelligence - SQL Case Study
 * File: sales-time-intelligence-sql-case-study
 * Author: Sudais Shah
 * Description:
 * This file contains all the SQL queries demonstrating
 * PostgreSQL date/time functions applied to our sales data
 * for a deep analysis of time-based patterns and trends.
 *
 * Pre-requisites:
 * - Run `db/sales_db_setup.sql` to create the necessary tables
 *   and insert sample data.
 *
 * How to Run:
 * - Use psql or any PostgreSQL client to execute the queries.
 * - Execute each section individually to observe the output.
 *
 * ------------------------------------------------------
 * Query Sections:
 * 1. Basic Date/Time Functions
 * 2. Time Series Analysis
 * 3. Advanced Aggregations using Time Functions
 *
 * Enjoy exploring time-based analytics!
 *******************************************************/

--                        1. Date Range Filtering:
--Q1 - Find all orders from the Orders table where the order date is between 2023-01-01 and 2023-12-31.

SELECT * FROM Orders
WHERE order_date
BETWEEN '2023-01-01' AND '2023-12-31';

--Q2 - Query for all customers who signed up in the last 30 days from the Customers table.

SELECT * FROM Customers
WHERE 
signup_date >=  CURRENT_DATE - INTERVAL '30 DAYS'

--                          2. Extracting Date Parts:      
--Q3 - List the order_id, order_date, and extract the year and month from the order_date in the Orders table.

SELECT order_id , order_date ,
       EXTRACT(year from order_date) as year , 
       EXTRACT(month from order_date) as month 
FROM order ;
                -- mY sQL
--SELECT order_id , order_date , YEAR(order_date) as year , MONTH(order_date) as month FROM order ;


--Q4 - From the Orders table, retrieve all orders that occurred in the month of January, regardless of the year.

SELECT order_id , order_date ,
       EXTRACT(month FROM order_date) as month FROM orders
GROUP by 1 , 2
Having EXTRACT(month FROM order_date) = 1;    -- MY SQL ONLY USE MONTH FUNCTION

--Q5 - Extract the day of the week (e.g Monday, Tuesday) from the order_date in the Orders table.

SELECT order_id,  order_date, 
      TO_CHAR(order_date, 'Day') AS day_of_week -- mY sQL USE DAYOFWEEK
FROM Orders;

--                                     3. Date Difference Calculations:
--Q6 - Calculate the number of days between the signup_date and today's date for each customer in the Customers table.

SELECT customer_id, customer_name, signup_date,
       CURRENT_DATE - signup_date AS days_since_signup
FROM Customers;

--Q7 - Find all orders where the difference between the order_date and the current date is more than 90 days.

SELECT  order_id, customer_id, order_date,
         CURRENT_DATE - order_date AS days_since_order
FROM Orders
WHERE CURRENT_DATE - order_date > 90;

--Q8 - From the Orders table, find the total number of days between the order_date and the signup_date for each customer.

SELECT C.signup_date - O.order_date as total_days from Customers C
JOIN  Orders O ON C.customer_id = O.customer_id;

--                                                 4. Time Manipulation:
--Q9 - Retrieve the total time duration of each order by calculating the difference between order_time and order_date in the Orders table.

SELECT order_id,customer_id,order_date,order_time,
       (order_date + order_time) - order_date::timestamp AS total_duration
FROM Orders;

--Q10 - From the Orders table, find all orders where the order_time is between 10:00:00 and 12:00:00 on any given day.
SELECT  order_id, customer_id, order_date, order_time
FROM Orders 
WHERE order_time between '10:00:00' AND '12:00:00'

--                                      5. Date and Time Arithmetic:
--Q11 - Add 30 days to the order_date in the Orders table and display the new date as extended_order_date.

SELECT  order_id, customer_id, order_date, 
        order_date + INTERVAL '30 DAYS' AS extended_date
FROM Orders 

--Q12 - Subtract 2 hours from order_time and show the updated time as adjusted_order_time.
SELECT  order_id, customer_id, order_datorder_time, --for addition use DATE_ADD()
order_time - INTERVAL '2 HOURS' AS adjusted_Order_time -- DATE_SUB(order_time, INTERVAL 2 HOUR) AS adjusted_order_time
FROM Orders 

--Q13 - From the Orders table, create a new column showing the date and time 7 days from the order_date and order_time.

SELECT  order_id, customer_id, order_da order_time, --for addition use DATE_ADD()
        order_date + order_time  + INTERVAL '7 DAYS' AS adjusted_Order_time -- DATE_SUB(order_time, INTERVAL 2 HOUR) AS adjusted_order_time
FROM Orders

------ My Sql
--DATE_ADD(CONCAT(order_date, ' ', order_time), INTERVAL 7 DAY) AS date_time_plus_7_days


--                                        6. Grouping by Date/Time:
--Q14 - Group all orders by year and month, showing the total order amount (amount) for each month in the Orders table.

SELECT EXTRACT(YEAR FROM  order_date) AS Yearly_Orders , 
       EXTRACT(MONTH FROM order_date) AS Monthly_Orders ,
       sum(amount) as  Order_amount 
FROM Orders
GROUP BY Monthly_Orders , Yearly_Orders 
ORDER BY Monthly_Orders , Yearly_Orders ASC

--Q15 - Count the number of orders placed on each day of the week (Monday, Tuesday, etc.) from the Orders table.

SELECT TO_CHAR(order_date, 'Day') AS day_of_week,
       COUNT(*) AS order_count
FROM Orders
GROUP BY TO_CHAR(order_date, 'Day'), EXTRACT(DOW FROM order_date)
ORDER BY EXTRACT(DOW FROM order_date);

----- MY SQL
SELECT 
    DAYNAME(order_date) AS day_of_week,
    COUNT(*) AS order_count
FROM Orders
GROUP BY DAYNAME(order_date), DAYOFWEEK(order_date)
ORDER BY DAYOFWEEK(order_date);

--                                        7. Handling Time Zones:
--Q16 - Convert the order_time (which is in UTC) to your local time zone and display it as local_order_time (assuming a time zone offset of +5 hours).

SELECT *, order_time + INTERVAL '5 hours' AS Local_Order_Time
FROM Orders

-- SOLUTION 2 
SELECT   order_id,  order_time,
        (order_time AT TIME ZONE 'UTC') AT TIME ZONE 'Asia/Karachi' AS local_order_time
FROM Orders; -- CONVERT_TZ(order_time, '+00:00', '+05:00') AS local_order_time // MY SQL


--Q17 - Convert the signup_date to a specific time zone (like UTC +3) and show it as local_signup_date.

SELECT *, Convert_TZ(order_time,'','+5:00:00') AS Local_Order_Time
FROM Orders

--                             8. Working with Week Numbers:
--Q18 - Extract the week number from the order_date in the Orders table (e.g., Week 1, Week 2, etc.).

SELECT  order_id, order_date, EXTRACT(WEEK FROM order_date) AS week_number
FROM Orders;

--Q19 - Find all orders that occurred in the last week (from today).
SELECT *
FROM Orders
WHERE order_date >= CURRENT_DATE - INTERVAL '7 DAYS'
ORDER BY order_date DESC

--                                 9. Handling NULL Dates:
--Q20 - Find all orders in the Orders table where the order_date is NULL.
SELECT * FROM Orders 
WHERE order_date is null

--Q21 - List all customers who haven’t placed any orders (i.e , customers without any entries in the Orders table).

SELECT c.customer_id, c.customer_name, c.signup_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--                                    10. Advanced Date Calculations:
--Q22 - Create a query that finds the total number of orders placed each day over the past month and display the results as a list of 
                                                                                -- dates and the number of orders for each date.
SELECT  EXTRACT(DAY FROM order_date) AS orders_per_day, COUNT(*) 
FROM Orders
WHERE EXTRACT(MONTH FROM order_date) = 10 -- or currenttime - interval - 1 month 
GROUP BY orders_per_day
ORDER BY orders_per_day ASC


--@23 - Retrieve the average order amount (amount) for each quarter (Q1, Q2, Q3, Q4) based on the order_date in the Orders table.

SELECT  EXTRACT(YEAR FROM order_date) , EXTRACT(QUARTER FROM order_date), COUNT(amount) 
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date) ,EXTRACT(QUARTER FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date) ,EXTRACT(QUARTER FROM order_date) ASC


--                               11. Using CURRENT_DATE and CURRENT_TIME:
--Q24 - Retrieve all orders placed today (use CURRENT_DATE) from the Orders table.

SELECT * FROM orders WHERE 
order_date = CURRENT_DATE

--Q25 - From the Orders table, find orders placed before the current time (use CURRENT_TIME).

SELECT * FROM orders WHERE 
CURRENT_TIME < order_time 

--                           12. Working with Date and Time Functions:
--Q26 - Use the EXTRACT() function to get the hour part from order_time in the Orders table.
SELECT * , EXTRACT(HOUR FROM order_time) as hour 
FROM orders


--Q27 - Use the DATE_TRUNC() function to truncate order_date to the beginning of the month.
SELECT  DATE_TRUNC('month', order_date) AS truncated_date, -- my sql   DATE_FORMAT(order_date, '%Y-%m-01') AS truncated_date, 
        COUNT(*) AS order_count
FROM Orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY truncated_date;


--                                   13. Handling Time Intervals:
--Q28 - Add 1 month to all order_date entries in the Orders table and display the updated date as next_month_order_date.
SELECT * , order_date + INTERVAL '1 MONTH' as next_month_order_date
FROM orders

--Q29 - Subtract 15 days from the signup_date for all customers in the Customers table and display it as signup_date_minus_15.
SELECT * , order_date - INTERVAL '15 DAYS' as next_month_order_date
FROM orders

--                                   14. Finding Time Gaps in Orders:
--Q30 - Identify customers who have placed multiple orders, and for each customer, find the time gap between their first and last order.
SELECT  customer_id, MIN(order_date) AS first_order_date, MAX(order_date) AS last_order_date,
        MAX(order_date) - MIN(order_date) AS time_gap -- DATEDIFF(MAX(order_date), MIN(order_date)) AS time_gap
FROM Orders
GROUP BY customer_id
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY customer_id;

--------------------------for every order
SELECT  customer_id, order_id, order_date, order_time,
       LAG(order_date + order_time) OVER (PARTITION BY customer_id ORDER BY order_date, order_time) AS previous_order_datetime,
       (order_date + order_time) - LAG(order_date + order_time) OVER (PARTITION BY customer_id ORDER BY order_date, order_time) AS time_gap
FROM Orders
ORDER BY customer_id, order_date, order_time;

-------------my sql --
SELECT  customer_id, order_id, order_date, order_time,
        CONCAT(order_date, ' ', order_time) AS current_order_datetime,
       LAG(CONCAT(order_date, ' ', order_time)) OVER (PARTITION BY customer_id ORDER BY order_date, order_time) AS previous_order_datetime,
       TIMESTAMPDIFF(SECOND, 
        LAG(CONCAT(order_date, ' ', order_time)) OVER (PARTITION BY customer_id ORDER BY order_date, order_time), 
        CONCAT(order_date, ' ', order_time)) AS time_gap_in_seconds
FROM Orders
ORDER BY customer_id, order_date, order_time;

--Q31 - From the Orders table, identify the longest gap between consecutive orders for each customer.
WITH cte AS(
     SELECT  customer_id as customer_id , order_date as order_date , order_time as order_time ,
            Lag(order_date + order_time ) Over (Partition BY customer_id Order By order_date,order_time ASC), 
            order_date + order_time -  Lag(order_date + order_time ) Over (Partition BY customer_id Order By order_date,order_time ASC) as log_gap
     FROM orders)
SELECT customer_id , Max(log_gap)
FROM cte
GROUP BY 1
limit 1

--                                           15. Date Formatting:
--Q32 - Format the order_date in the Orders table as YYYY-MM-DD and display it as formatted_order_date.
SELECT *,TO_CHAR(order_date,'YYYY-MM-DD'--AM
) -- my sql date_format(order_date,'%y-%m-%d')
FROM orders

--Q34 - From the Orders table, display the order_time in HH:MM:SS format.
SELECT *,TO_CHAR(order_time,'HH12:MI:SS') -- my sql date_format(order_date,'%h-%i-%s %p')
FROM orders

/*******************************************************
 * End of Time-based Queries
 *
 * Summary:
 * - Demonstrated a variety of PostgreSQL date/time functions.
 * - Analyzed sales trends, patterns, and time series data.
 *
 * Note:
 * - Ensure that you have executed the setup script before
 *   running these queries.
 *******************************************************/





