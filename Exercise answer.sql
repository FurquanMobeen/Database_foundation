
--Return all fields from customers.
SELECT *
FROM r0933100.customers

--Return all fields from products.
SELECT *
FROM r0933100.products

--Return customer name and country from customers.
SELECT contact_name, country
FROM r0933100.customers

--Return all shippers sorted ascending by the shipper name.
SELECT *
FROM r0933100.shippers
ORDER BY company_name ASC

--Return name, country and city from customers. Order on country than city.
SELECT contact_name, country, city
FROM r0933100.customers
ORDER BY country, city

--Return all fields from the first 3 records of employees.
SELECT *
FROM r0933100.employees
LIMIT 3

--Return all the fields from the table suppliers. All countries can only be shown 1 time.
SELECT DISTINCT country
FROM r0933100.suppliers
ORDER BY country

--Return all countries and contact names from table suppliers. Every combination should be unique.
SELECT DISTINCT country, contact_name
FROM r0933100.suppliers
ORDER BY country

--Return all the orders where there is a date assigned. A specific date can only be shown 1 time.
SELECT DISTINCT order_date
FROM r0933100.orders

--Sort the table Customers based on the country (ascending) and on city (descending).
SELECT *
FROM r0933100.customers
ORDER BY country ASC and city DESC

--Show me the information from the Mexican employees.  
FROM r0933100.customers
WHERE country LIKE 'Mexico'

--Show all information from the orders that are place after 10th July 1996.
SELECT * 
FROM r0933100.orders
WHERE order_date > '1996-07-10'
ORDER BY order_date

--Show all information from the orders that are place after 10th July 1996 and order it by ID.
SELECT * 
FROM r0933100.orders
WHERE order_date > '1996-07-10'
ORDER BY order_id

--Which customers are based in Paris? Create an alphabetic list with the company names from these customers.
SELECT *
FROM r0933100.customers
WHERE city LIKE 'Paris'
ORDER BY company_name 

--Which employees are hired after 1th of January 1994? Create a list from the employees with the familyname, function and date when they are hired.
SELECT *
FROM r0933100.employees
WHERE hire_date > '1994-01-01'

--Create a list from the employees with the familyname, function and date when they are hired.
SELECT last_name, title, hire_date
FROM r0933100.employees

--A customer called about an order that is placed at 2th October 1996. The financial department wants to know every informationabout this order. 
--Because the information is based in 2 tables(Orders, Orders details) we will need 2 queries. Later we will do thisone query.
SELECT *
FROM r0933100.orders
WHERE order_date = '1996-10-02';
SELECT *
FROM r0933100.order_details
WHERE order_id = 10319

--For which employees (familyname and firstname) don't we have the region?
SELECT last_name, first_name
FROM r0933100.employees
WHERE region IS NULL 

--Give the address information from all the customers that live in postcode which starts with a 'W'.
SELECT *
FROM r0933100.customers
WHERE postal_code LIKE 'W%'

--Give the address from all the customers where the contactname second character is A. Sort first on country, then postcode.
SELECT *
FROM r0933100.customers
WHERE contact_name LIKE '_a%'
ORDER BY country, postal_code

--Give the fax and name of the suppliers where we don't know the fax. Sort the name ascending.
SELECT contact_name, fax 
FROM r0933100.suppliers
WHERE fax IS NULL
ORDER BY contact_name

--Give the fax and name of the suppliers where we do know the fax. Sort the name ascending.
SELECT contact_name, fax 
FROM r0933100.suppliers
WHERE fax IS NOT NULL
ORDER BY contact_name

--Show the data from 'sales' customers (function start with sales) that come from Germany and France.  
SELECT *
FROM r0933100.customers
WHERE country IN ('Germany', 'France') AND contact_title LIKE '%Sales%'

--Show the data from all the other customers then the exercise above.
SELECT * 
FROM r0933100.customers
WHERE country NOT IN ('Germany', 'France') AND contact_title NOT LIKE '%Sales%'

--Show all the female 'Sales representatives' and the male 'sales manages' (employees).
SELECT *
FROM r0933100.employees
WHERE (title_of_courtesy = 'Ms.' AND title = 'Sales Representative') 
OR (title_of_courtesy IN ('Dr.', 'Mr.') AND title = 'Sales Manager')

--Show all the clients with name and contactname where the contactname starts or ends with the letter A.
SELECT company_name, contact_name
FROM r0933100.customers
WHERE company_name LIKE 'A%' OR company_name LIKE '%A' 

--Show all the customers where fax or phone is empty.
SELECT *
FROM r0933100.customers
WHERE phone IS NULL OR fax IS NULL

--Show following products (CHAI, KONBU, TOFU), sorted on product name.
SELECT *
FROM r0933100.products
WHERE product_name IN ('Chai', 'Konbu', 'Tofu')
ORDER BY product_name

--Show all the order where the shipping date is between 8th september 1996 and 9th october 1996.
SELECT *
FROM r0933100.orders
WHERE shipped_date BETWEEN '1996-09-08' AND '1996-10-09'

--Give the products with a unit price between 10 and 12 and where there are more than 10 units in stock1.
SELECT *
FROM r0933100.products
WHERE unit_price BETWEEN 10 AND 12 
AND units_in_stock > 10

--Give the products with a quantity per unit from 10 and 12, and where there are more than 10 units in stock.
SELECT * 
FROM r0933100.products
WHERE units_in_stock > 10 
AND (quantity_per_unit IN ('10 %','12%'))

--How many customers are there from Germany.
SELECT COUNT(*)
FROM r0933100.customers
WHERE country = 'Germany'

--How many items are sold in total.
SELECT SUM(quantity) 
FROM r0933100.order_details

--What is the average unit price from the products that are not in an order.
SELECT AVG(unit_price)
FROM r0933100.products
WHERE units_on_order > 0

--What is the maximum assigned discount form an product that is ordered by a customer.
SELECT MAX(discount)
FROM r0933100.order_details

-- Give a list of the orderid, unitprice, quantity and total from order details.Total is a 
-- column that is calculated by multiplying unitprice with quantity.Add a correct column 
--name as well.
SELECT order_id, product_id, unit_price, quantity, unit_price *
quantity AS "total_price" 
FROM r0933100.order_details

-- Give a list with product names, unit price, new price from the products. New 
-- price is calculated by increasing the unit price with 2%
SELECT product_name, unit_price * 1.02 AS NewPrice
FROM r0933100.products

-- From how many employees we know the region?
SELECT COUNT(*) AS amount_of_employees
FROM r0933100.employees
WHERE region IS NOT NULL

-- Give a list with product names, unit price, new price from the products. New 
-- price is calculated by increasing the unit price with 2%, but round it up
SELECT product_name, unit_price, ROUND(unit_price * 1.02)
AS new_price
FROM r0933100.products

--Give a list with the names from the employees with their starting date together 
--with the age they were at that time.
SELECT first_name, last_name, hire_date, 
EXTRACT(YEAR FROM AGE(hire_date, birth_date)) 
AS "age_at_start"
FROM r0933100.employees;

--Show the product name, unit price and a new price where unit price is plus 2% and 
--and show only the new price when bigger then 50.
SELECT product_name, unit_price, 
ROUND(unit_price * 1.02) AS new_price
FROM r0933100.products
WHERE ROUND(unit_price * 1.02) > 50

--Show a new identification code from the employees. Every identification code 
--consist out (2 first letters of the family name and 1 letter from the first name) 
--Everything should be in capital.
SELECT UPPER(CONCAT(LEFT(last_name,2), LEFT(first_name,1))) 
AS indentification_code
FROM r0933100.employees

--Show the most recent hiring date per function.
SELECT title, MAX(hire_date)
AS most_recent_hiringdate
FROM r0933100.employees
GROUP BY title

--What is the average unit price and the average quantity from the sold products?
SELECT product_id,
ROUND(AVG(unit_price)) AS avg_unit_price,
ROUND(AVG(quantity)) AS avg_quantity
FROM r0933100.order_details
GROUP BY product_id

--How many suppliers do you have for Japan and USA? Sort by the country with the most suppliers
SELECT country, COUNT(*)
FROM r0933100.suppliers
WHERE country IN ('Japan', 'USA')
GROUP BY country
ORDER BY COUNT(*) DESC

--Count the employees per city but only show the city that have more than 1 employee.
SELECT city, COUNT(*) AS employee_count
FROM r0933100.employees
GROUP BY city
HAVING COUNT(*) > 1

--What is the maximum and minimum unitPrice per categoryID?
SELECT category_id, 
MAX(unit_price) AS max_init_price, 
MIN(unit_price) AS min_init_price
FROM r0933100.products
GROUP BY category_id

--What is the average stock unit per category for product that are more expensive 
--than 10. Show only the information when the average of stock is greater than 40.
SELECT category_id, product_name,
AVG(units_in_stock) AS avg_stock_unit_per_category
FROM r0933100.products
WHERE unit_price > 10
GROUP BY category_id, product_name
HAVING AVG(units_in_stock) > 40
ORDER BY 3 DESC