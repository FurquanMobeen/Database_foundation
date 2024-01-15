--Retrieve the names and first name of the customers that passed the theoretical exam.
SELECT customer.name, customer.first_name, customer.passed_theory_exam
FROM rijschool.customer
WHERE customer.passed_theory_exam = true
-------------------------------------------------------------------------------------------
--Retrieve the names of customers who have a driving license with the type of transmisson 'Automatic'?
SELECT customer.name, customer.first_name
FROM rijschool.customer
INNER JOIN rijschool.customer_driving_license
ON customer.id = customer_driving_license.customer_id
INNER JOIN rijschool.driving_license
ON customer_driving_license.driving_license_id = driving_license.id
WHERE driving_license.transmission = 'Automatic'
GROUP BY customer.name, customer.first_name
-------------------------------------------------------------------------------------------
--Count the number of customers who have passed the theory exam.
SELECT COUNT(*)
FROM rijschool.customer
WHERE passed_theory_exam = true
-------------------------------------------------------------------------------------------
--Find the number of customers for each type of transmission in their driving license.
	--1: This shows both numbers of the amount of customers that did Manual and Automatic.
	SELECT
		COUNT(CASE WHEN rijschool.driving_license.transmission = 'Manual' THEN 1 END) AS manual_count,
		COUNT(CASE WHEN rijschool.driving_license.transmission = 'Automatic' THEN 1 END) AS automatic_count
	FROM rijschool.driving_license;
	----Find the number of customers for each type of transmission in their driving license.
	-- SELECT customer.id,
	-- 	COUNT(CASE WHEN customer_driving_license.driving_license_id IN(1,15) = driving_license.id IN(1,15) THEN 1 END) AS manual_count,
	-- 	COUNT(CASE WHEN customer_driving_license.driving_license_id IN(16,30) = driving_license.id IN(16,30) THEN 1 END) AS automatic_count
	-- FROM rijschool.customer_driving_license
	-- INNER JOIN rijschool.driving_license
	-- ON customer_driving_license.driving_license_id = driving_license.id 
	-- INNER JOIN rijschool.customer
	-- ON customer.id = customer_driving_license.customer_id
	-- GROUP BY customer.id

	--2: Only the number of customers that did Automatic
	SELECT COUNT(*)
	FROM rijschool.driving_license
	WHERE transmission = 'Automatic'
	--3: Only the number of customers that did Manual
	SELECT COUNT(*)
	FROM rijschool.driving_license
	WHERE transmission = 'Manual'
-------------------------------------------------------------------------------------------
--Retrieve the names of customers who have passed the theory exam and have a driving license with 'Manual' transmission.
SELECT customer.name, customer.first_name
FROM rijschool.customer
INNER JOIN rijschool.lesson
ON customer.id = lesson.id
INNER JOIN rijschool.driving_license
ON customer.id = driving_license.id
WHERE lesson.theoretical = true AND transmission = 'Manual'
-------------------------------------------------------------------------------------------
--Find the total number of lessons (both practical and theoretical) conducted by a specific teacher with a given employee_id.
SELECT employee.id, employee.name, employee.first_name, 
COUNT(lesson.practical) AS total_lessons_practical, COUNT(lesson.theoretical) AS total_lessons_theoretical
FROM rijschool.employee
INNER JOIN rijschool.lesson
ON employee.id = lesson.employee_id_teacher
--WHERE employee.name = 'Aerts' AND employee.first_name = 'Elise'
GROUP BY employee.id, employee.name, employee.first_name
--ORDER BY total_lessons_practical DESC
-------------------------------------------------------------------------------------------
--Write a SQL query to retrieve all customers who rented a vehicle in the last 3 months.
SELECT *
FROM rijschool.customer 
INNER JOIN rijschool.lesson ON customer.id = lesson.customer_id_practical_course
WHERE lesson.date > '2023-11-14'
-------------------------------------------------------------------------------------------
--Create a query to count the total number of vehicles rented by each customer in the last year.
SELECT COUNT(*)
FROM rijschool.vehicle 
INNER JOIN rijschool.lesson ON vehicle.id = lesson.vehicle_id
WHERE EXTRACT(year from date) = 2023
-------------------------------------------------------------------------------------------
--What are the details of lessons and associated vehicles scheduled for the 
--month of June where the vehicle brand is either 'Yamaha' or 'Kawasaki'?
--Order by lesson_id and give us the license plate of the 12th row.
SELECT *
FROM rijschool.lesson INNER JOIN rijschool.vehicle ON lesson.vehicle_id = vehicle.id
WHERE EXTRACT(month from lesson.date) = 06 AND vehicle.brand IN ('Yamaha', 'Kawasaki')
ORDER BY lesson.id 
-------------------------------------------------------------------------------------------
/*What is the count of theory exam failures, along with relevant details such as 
first name, last name, and location name, for customers whose last name ends 
with 'ally' and have failed the theory exam, based on the 'rijschool' schema?
Make sure to order it by the most lessons failed. Give the query needed.*/
SELECT customer.first_name, customer.name, customer.passed_theory_exam, location.name, COUNT(*) AS failed
FROM rijschool.customer
INNER JOIN rijschool.customer_following_theory_lesson ON customer.id = customer_following_theory_lesson.customer_id
INNER JOIN rijschool.lesson ON customer_following_theory_lesson.lesson_id = lesson.id
INNER JOIN rijschool.location ON lesson.location_id = location.id
WHERE customer.passed_theory_exam = false AND customer.name LIKE '%ally'
GROUP BY customer.first_name, customer.name, customer.passed_theory_exam, location.name
ORDER BY COUNT(customer.passed_theory_exam) DESC;
-------------------------------------------------------------------------------------------
/*In which classrooms are all lessons being taken place in? 
Could you also show the ID, duration, location name, classroom capacity & 
subject for all lessons taking place at the date of June 25th 2023?
The answer consists of ONLY 3 answers. Give data of all 3.*/
SELECT classroom.id, lesson.duration_minutes, location.name, classroom.capacity, subject.title
FROM rijschool.classroom 
INNER JOIN rijschool.location ON classroom.location_id = location.id
INNER JOIN rijschool.lesson ON location.id = lesson.location_id
INNER JOIN rijschool.subject ON lesson.subject_id = subject.id
WHERE lesson.date = '2023/06/25'
LIMIT 3
-------------------------------------------------------------------------------------------
--How many theoretical and practical lessons are associated with the teacher 
--whose employee_id is 3 in the "rijschool" schema?
SELECT employee_id_teacher,
COUNT(CASE WHEN lesson.theoretical = true THEN 1 END) AS theoretical_count, 
COUNT(CASE WHEN lesson.practical = true THEN 1 END) AS practical_count
FROM rijschool.lesson 
WHERE employee_id_teacher = 3
GROUP BY employee_id_teacher;
-------------------------------------------------------------------------------------------
-- What is the average passing grade for the theoretical exam? 
-- Just give a straight answer, no need for the query. 1 Decimal only. :)) 
SELECT 
ROUND(AVG(CASE 
		 	WHEN customer.passed_theory_exam = true
		 	THEN 100
		 	ELSE 0
		 	END),1)
			AS avg_theoretical
FROM rijschool.customer
-------------------------------------------------------------------------------------------
/*How many lessons are associated with a driving license of type 'B' and how 
many lessons are associated with a driving license of type 'A2' in the 'rijschool' 
schema? Give a total amount of these two. 
You can use only one query. Give the query AND answers*/
SELECT 
COUNT(CASE WHEN driving_license.license LIKE 'B' THEN 1 END) AS total_license_b,
COUNT(CASE WHEN driving_license.license LIKE 'A2' THEN 1 END) AS total_license_A2
FROM rijschool.lesson 
INNER JOIN rijschool.vehicle 
ON lesson.vehicle_id = vehicle.id
INNER JOIN rijschool.driving_license 
ON vehicle.license_id = driving_license.id 

-- Step 1: Add John Cena to the system
INSERT INTO rijschool.customer (id, first_name, name, passed_theory_exam)
VALUES (1001, 'John', 'Cena', true);


-- Step 2: Plan practical exam for John Cena on 29/06/2024
INSERT INTO rijschool.lesson (vehicle_id, id, date, time_start, practical, theoretical, employee_id_planner, location_id, subject_id, customer_id_practical_course)
VALUES (291, 22962, '2024-06-29', '15:00:00', true, false, 389, 4, 115, 1001);

-- Step 3: Add Yamaha R1M to the vehicles
INSERT INTO rijschool.vehicle (id, license_plate, license_id, brand, model)
VALUES (291, '9-MAVX-023', 4, 'Yamaha', 'YZF-R1M');

-- Step 4: Show all data
--SET search_path TO r0800982_rijschool;
-- Show the result for John Cena's practical exam and vehicle details
SELECT lesson.id, customer.first_name, customer.name, lesson.date, vehicle.license_plate, 
vehicle.license_id, vehicle.model, vehicle.title, driving_license.license, driving_license.transmission
FROM rijschool.lesson
INNER JOIN rijschool.customer ON (customer.id = lesson.customer_id_practical_course)
INNER JOIN rijschool.vehicle ON (lesson.vehicle_id = vehicle.id)
INNER JOIN rijschool.driving_license ON (vehicle.license_id = driving_license.id)
--LEFT JOIN subject ON (lesson.subject_id = subject.id)
--RIGHT JOIN driving_license ON (vehicle.license_id = driving_license.id)
INNER JOIN rijschool.subject ON (lesson.subject_id = subject.id)
INNER JOIN rijschool.location ON (lesson.location_id = location.id)
WHERE lesson.id = 22962
-------------------------------------------------------------------------------------------
/*I want you to make a query where you show all the employees  
(NO DUPLICATES) who aren't planners, where their name ONLY HAVE 2 'E's,  
& give lessons within Haasrode only for the car license(B).  
Also, make sure to order them alphabetically from their first name.  
Make sure they are only teachers, not teacher & planner.  
should look exactly like the output below with the same amount of rows.*/ 
SELECT DISTINCT employee.first_name, employee.name, driving_license.license, location.city
FROM rijschool.lesson
INNER JOIN rijschool.employee ON (lesson.employee_id_teacher = employee.id)
INNER JOIN rijschool.employee_driving_license ON (employee.id = employee_driving_license.employee_id)
INNER JOIN rijschool.driving_license ON (employee_driving_license.driving_license_id = driving_license.id)
INNER JOIN rijschool.location ON (lesson.location_id = location.id)
WHERE location.city = 'Haasrode' AND driving_license.license = 'B' AND employee.name LIKE '%e%e%' AND NOT employee.name LIKE '%e%e%e%'
GROUP BY employee.first_name , employee.name, driving_license.license, location.city, employee.planner HAVING employee.planner = 'false'
ORDER BY employee.first_name
-------------------------------------------------------------------------------------------
/*In which location are the most truck lessons(license C) being passed through?  
Give the full name sof the specific customers with the most truck lessons at 
that specific location.  
Give all the queries as well, remember that as long as the answer is the same 
it's all good. Explain on all queries what you're doing.*/
SELECT customer.name, customer.first_name, location.name, COUNT(driving_license.license) AS lessons_passed
FROM rijschool.lesson
INNER JOIN rijschool.location ON lesson.location_id = location.id
INNER JOIN rijschool.vehicle ON lesson.vehicle_id = vehicle.id
INNER JOIN rijschool.driving_license ON vehicle.license_id = driving_license.id
INNER JOIN rijschool.customer ON lesson.customer_id_practical_course = customer.id
WHERE driving_license.license = 'C'
GROUP BY customer.name, customer.first_name, location.name
ORDER BY COUNT(driving_license.license) DESC;
-------------------------------------------------------------------------------------------
/*Which cars have an automatic transmission? Can you show all the details 
like below? We don't need the id of the cars. 
Make sure It's sorted as followed, order alphabetically by the brand: 
Give us the query & give us the brand & model of the 15th row. */
SELECT vehicle.brand, vehicle.model, vehicle.license_id, driving_license.license, driving_license.transmission
FROM rijschool.vehicle
INNER JOIN rijschool.driving_license 
ON vehicle.license_id = driving_license.id
WHERE driving_license.license = 'B' AND driving_license.transmission = 'Automatic' AND vehicle.model = 'Prius'
ORDER BY vehicle.brand
-------------------------------------------------------------------------------------------
/*Retrieve information about vehicles with license plates that end with '99' 
and start with 'M'. Post query.*/
SELECT *
FROM rijschol.vehicle 
WHERE vehicle.license_plate LIKE '%99' AND vehicle.license_plate LIKE 'M%';
-------------------------------------------------------------------------------------------
/*Retrieve information about driving licenses that have corresponding entries 
in the 'driving_license' table, including the brand, model, driving license ID, 
license, and transmission details.  
Filter the results to include only the driving licenses where the associated 
vehicle information in the 'vehicle' table is missing. Assume the schema is 
'r0800982_rijschool,' and tables include 'vehicle' and 'driving_license. 
Include only the answers, that are sorted like this. 
For example : Ford, Mustang, 2, B, Manual*/
SELECT vehicle.brand, vehicle.model, driving_license.id, driving_license.license, driving_license.transmission
FROM rijschool.vehicle
INNER JOIN rijschool.driving_license
ON vehicle.license_id = driving_license.id
-------------------------------------------------------------------------------------------
/*Look up information such as the customer's full name, driving license ID, 
license type, and transmission. Only include entries where the driving license 
has a license type of 'T'. Display the results ordered by the customer's last 
name, limiting the output to 5 records. 
You should be able to give the full query, but also send as an answer the last 2 
data rows. It should look as mentioned below.*/
SELECT customer.name, customer.first_name, driving_license.id, driving_license.license, driving_license.transmission
FROM rijschool.customer
INNER JOIN rijschool.customer_driving_license
ON customer.id = customer_driving_license.customer_id
INNER JOIN rijschool.driving_license
ON customer_driving_license.driving_license_id = driving_license.id
WHERE driving_license.license = 'T'
ORDER BY customer.name
LIMIT 5
-------------------------------------------------------------------------------------------
/*Achieve this specific result. Which client does it relate to?  
Get the query but also give the answer to the question.*/
SELECT lesson.date, lesson.practical, lesson.employee_id_teacher, lesson.subject_id, subject.title
FROM rijschool.lesson 
INNER JOIN rijschool.subject 
ON lesson.subject_id = subject.id
WHERE lesson.date ='2024-06-29' 
AND lesson.practical = true 
AND lesson.employee_id_teacher is null
-------------------------------------------------------------------------------------------
/*Imagine you have to update all subject id’s with id: 500 where practical is 
true & you also have to update the model of the vehicle called ‘R1M’ to R6. 
How would you do that? Don’t run the query, just give the answer.*/
UPDATE rijschool.lesson
SET subject_id = 500
WHERE practical = true

UPDATE rijschool.vehicle
SET model = 'R6'
WHERE model = 'R1M'
-------------------------------------------------------------------------------------------
/*Display all the names of the needed and the for licenses from the table 
license_requires_license. Put the query necessary.*/
SELECT DL1.id AS driving_license_id_for,
DL1.license AS driving_license_for,
DL2.id AS driving_license_id_needed,
DL2.license AS driving_license_needed
FROM rijschool.license_requires_license LRL
INNER JOIN rijschool.driving_license DL1
ON LRL.driving_license_id_for = DL1.id
INNER JOIN rijschool.driving_license DL2
ON DL2.id = LRL.driving_license_id_needed
-------------------------------------------------------------------------------------------
/*Retrieve information about lessons held in a specific classroom 
(classroom_id = 103) and their corresponding subjects.  
Display the maximum number of participants allowed for each subject 
(max_nr_of_participants), the classroom ID, and the count of lessons 
conducted in that classroom.  
Filter the results to include only those with a maximum number of participants 
greater than or equal to 10.  
Finally, order the results by the maximum number of participants in descending 
order.*/
SELECT lesson.classroom_id, subject.max_nr_of_participants, COUNT(lesson.classroom_id)
FROM rijschool.lesson
INNER JOIN rijschool.subject ON lesson.subject_id = subject.id
WHERE classroom_id = 103 AND subject.max_nr_of_participants >= 10
GROUP BY subject.max_nr_of_participants, lesson.classroom_id 
ORDER BY subject.max_nr_of_participants DESC;
-------------------------------------------------------------------------------------------
/*Retrieve information about the total number of theoretical lessons. 
Give the average number of theoretical lessons across subjects with subject_id 
35 and 65. Ensure the results are grouped by subject_id and ordered by the 
total number of theoretical lessons in descending order. 
Give the query.*/
SELECT lesson.subject_id,
    COUNT(*) AS total_theoretical_lessons,
    ROUND(AVG(COUNT(*)) OVER ()) AS average_theoretical_lessons
FROM rijschool.lesson
WHERE lesson.theoretical = true AND subject_id IN (35, 65)
GROUP BY lesson.subject_id
ORDER BY total_theoretical_lessons DESC;
-------------------------------------------------------------------------------------------
/*Retrieve information about customers who have not passed the theory 
exam. Display the first name, full name, theory exam status, and the total number of 
failed theory lessons for the top 5 customers with the highest count of failed theory lessons.  
Additionally, calculate the average number of failed theory lessons among these top 5 customers.  
Give only the query.*/
SELECT customer.first_name, customer.name, customer.passed_theory_exam, location.name, COUNT(*) AS failed
FROM rijschool.lesson
INNER JOIN rijschool.location 
ON lesson.location_id = location.id
INNER JOIN rijschool.customer_following_theory_lesson 
ON lesson.id = customer_following_theory_lesson.lesson_id
INNER JOIN rijschool.customer
ON customer_following_theory_lesson.customer_id = customer.id
WHERE customer.passed_theory_exam = false
GROUP BY customer.first_name, customer.name, customer.passed_theory_exam, location.name
ORDER BY COUNT(*) DESC
LIMIT 5;

--Calculate the average for the top 5 rows
SELECT ROUND(AVG(failed)) AS "Average lessons top 5"
FROM (
	SELECT customer.first_name, customer.name, customer.passed_theory_exam, location.name, COUNT(*) AS failed
	FROM rijschool.lesson
	INNER JOIN rijschool.location 
	ON lesson.location_id = location.id
	INNER JOIN rijschool.customer_following_theory_lesson 
	ON lesson.id = customer_following_theory_lesson.lesson_id
	INNER JOIN rijschool.customer
	ON customer_following_theory_lesson.customer_id = customer.id
	WHERE customer.passed_theory_exam = false
	GROUP BY customer.first_name, customer.name, customer.passed_theory_exam, location.name
	ORDER BY COUNT(*) DESC
	LIMIT 5
)AS top_5
