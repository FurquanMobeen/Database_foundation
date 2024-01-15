--Retrieve the names and first name of the customers that passed the theoretical exam.
SELECT customer.name, customer.first_name, customer.passed_theory_exam
FROM rijschool.customer
WHERE customer.passed_theory_exam = true

--Retrieve the names of customers who have a driving license with the type of transmisson 'Automatic'?
SELECT customer.name, customer.first_name
FROM rijschool.customer
INNER JOIN rijschool.customer_driving_license
ON customer.id = customer_driving_license.customer_id
INNER JOIN rijschool.driving_license
ON customer_driving_license.driving_license_id = driving_license.id
WHERE driving_license.transmission = 'Automatic'
GROUP BY customer.name, customer.first_name

--Count the number of customers who have passed the theory exam.
SELECT COUNT(*)
FROM rijschool.customer
WHERE passed_theory_exam = true

--Find the number of customers for each type of transmission in their driving license.
	--1: This shows both numbers of the amount of customers that did Manual and Automatic.
	SELECT
		COUNT(CASE WHEN rijschool.driving_license.transmission = 'Manual' THEN 1 END) AS manual_count,
		COUNT(CASE WHEN rijschool.driving_license.transmission = 'Automatic' THEN 1 END) AS automatic_count
	FROM rijschool.driving_license;

	--2: Only the number of customers that did Automatic
	SELECT COUNT(*)
	FROM rijschool.driving_license
	WHERE transmission = 'Automatic'
	--3: Only the number of customers that did Manual
	SELECT COUNT(*)
	FROM rijschool.driving_license
	WHERE transmission = 'Manual'

--Retrieve the names of customers who have passed the theory exam and have a driving license with 'Manual' transmission.
SELECT customer.name, customer.first_name
FROM rijschool.customer
INNER JOIN rijschool.lesson
ON customer.id = lesson.id
INNER JOIN rijschool.driving_license
ON customer.id = driving_license.id
WHERE lesson.theoretical = true AND transmission = 'Manual'

--Find the total number of lessons (both practical and theoretical) conducted by a specific teacher with a given employee_id.
SELECT employee.id, employee.name, employee.first_name, 
COUNT(lesson.practical) AS total_lessons_practical, COUNT(lesson.theoretical) AS total_lessons_theoretical
FROM rijschool.employee
INNER JOIN rijschool.lesson
ON employee.id = lesson.employee_id_teacher
--WHERE employee.name = 'Aerts' AND employee.first_name = 'Elise'
GROUP BY employee.id, employee.name, employee.first_name
--ORDER BY total_lessons_practical DESC

--Write a SQL query to retrieve all customers who rented a vehicle in the last 3 months.
SELECT *
FROM rijschool.customer 
INNER JOIN rijschool.lesson ON customer.id = lesson.customer_id_practical_course
WHERE lesson.date > '2023-11-14'

--Create a query to count the total number of vehicles rented by each customer in the last year.
SELECT COUNT(*)
FROM rijschool.vehicle 
INNER JOIN rijschool.lesson ON vehicle.id = lesson.vehicle_id
WHERE EXTRACT(year from date) = 2023

