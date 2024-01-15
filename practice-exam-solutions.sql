---         Question 1


-- Answer is "M-QJG-400"

--SET search_path TO rijschool;

SELECT L.id, L.date, V.id, V.brand, V.license_plate
FROM lesson L
JOIN vehicle V ON L.vehicle_id = V.id
WHERE 
	EXTRACT(MONTH FROM L.date) = 06 AND V.brand LIKE 'Yamaha' OR 
	EXTRACT(MONTH FROM L.date) = 06 AND V.brand LIKE 'Kawasaki'
ORDER BY lesson_id;


---         Question 2


--SET search_path TO rijschool;
SELECT C.first_name, C.name, C.passed_theory_exam, LO.name, COUNT(*) AS "total lessons failed"
FROM lesson L
INNER JOIN location LO ON L.location_id = LO.id
INNER JOIN customer_following_theory_lesson TL ON L.id = TL.lesson_id
INNER JOIN customer C ON TL.customer_id = C.id
WHERE C.passed_theory_exam = false AND C.name LIKE '_ally'
GROUP BY C.first_name, C.name, C.passed_theory_exam, LO.name
ORDER BY 5 DESC;


---         Question 3


-- Answer: 22416	"2023-06-25"	120	202	"Rijschool Alken"	20	"Maintaining a safe distance from emergency vehicles"
--         22417	"2023-06-25"	120	101	"Rijschool Haasrode"	20	"Be familiar with the different types of traffic lights and their meanings."
--         22418	"2023-06-25"	120	405	"Rijschool Tienen"	20	"Being extra cautious around pedestrians and children"

--SET search_path TO rijschool;
SELECT LE.id, LE.date, LE.duration_minutes, LE.classroom_id, LO.name, CL.capacity, S.title
FROM lesson LE
INNER JOIN location LO ON (LE.location_id = LO.id)
INNER JOIN classroom CL ON (LE.classroom_id = CL.id)
INNER JOIN subject S ON (LE.subject_id = S.id)
WHERE EXTRACT(YEAR from date) = 2023 AND EXTRACT(MONTH from date) = 06 AND EXTRACT(DAY from date) = 25
-- OR
-- WHERE date = '2023-06-25'


---         Question 4


--SET search_path TO rijschool;
SELECT
  employee_id_teacher,
  COUNT(CASE WHEN theoretical THEN 1 END) AS theoretical_count,
  COUNT(CASE WHEN practical THEN 1 END) AS practical_count
FROM lesson L
INNER JOIN employee E ON (L.employee_id_teacher = E.id)
WHERE employee_id_teacher = 3
GROUP BY employee_id_teacher
ORDER BY employee_id_teacher;


---         Question 5

-- Answer : 50.4

--SET search_path TO rijschool;
SELECT ROUND(AVG(CASE 
				 WHEN passed_theory_exam 
				 THEN 100 
				 ELSE 0 
				 END), 1) 
				 AS "Average passing grade"
FROM customer;


---         Question 6


-- Answer: 'B' = 572, 'A2' = 362

--SET search_path TO rijschool;
SELECT 
    COUNT(DL.license) AS total_license_B_lessons,
    -- when you want to add a specific data to the result, you can use the following syntax:
    -- this is how you can use subqueries for this question
    (SELECT COUNT(DL.license)
        FROM lesson L
        INNER JOIN vehicle V ON L.vehicle_id = V.id
        INNER JOIN driving_license DL ON V.license_id = DL.id
        WHERE DL.license = 'A2') AS total_license_A2_lessons
FROM lesson L
INNER JOIN vehicle V ON L.vehicle_id = V.id
INNER JOIN driving_license DL ON V.license_id = DL.id
WHERE DL.license = 'B';


---         Question 7

-- Step 1: Add John Cena to the system
INSERT INTO customer (id, first_name, name, passed_theory_exam)
VALUES (1001, 'John', 'Cena', true);


-- Step 2: Plan practical exam for John Cena on 29/06/2024
INSERT INTO lesson (vehicle_id, id, date, time_start, practical, theoretical, employee_id_planner, location_id, subject_id, customer_id_practical_course)
VALUES (291, 22962, '2024-06-29', '15:00:00', true, false, 389, 4, 115, 1001);

-- Step 3: Add Yamaha R1M to the vehicles
INSERT INTO vehicle (id, license_plate, license_id, brand, model)
VALUES (291, '9-MAVX-023', 4, 'Yamaha', 'YZF-R1M');

-- Step 4: Show all data
--SET search_path TO r0800982_rijschool;
-- Show the result for John Cena's practical exam and vehicle details
SELECT L.id, C.first_name, C.name, L.date, V.license_plate, 
V.license_id, V.model, S.title, DL.license, DL.transmission
FROM lesson L
INNER JOIN customer C ON (C.id = L.customer_id_practical_course)
INNER JOIN vehicle V ON (L.vehicle_id = V.id)
INNER JOIN driving_license DL ON (V.license_id = DL.id)
--LEFT JOIN subject S ON (L.subject_id = S.id)
--RIGHT JOIN driving_license DL ON (V.license_id = DL.id)
INNER JOIN subject S ON (L.subject_id = S.id)
INNER JOIN location LO ON (L.location_id = LO.id)
WHERE L.id = 22962


---         Question 8


--SET search_path TO rijschool;
SELECT DISTINCT E.first_name, E.name, DL.license, LO.city
FROM lesson LE
INNER JOIN employee E ON (LE.employee_id_teacher = E.id)
INNER JOIN employee_driving_license EDL ON (E.id = EDL.employee_id)
INNER JOIN driving_license DL ON (EDL.driving_license_id = DL.id)
INNER JOIN location LO ON (LE.location_id = LO.id)
WHERE LO.city = 'Haasrode' AND DL.license = 'B' AND E.name LIKE '%e%e%' AND NOT E.name LIKE '%e%e%e%'
GROUP BY E.first_name , E.name, DL.license, LO.city, E.planner HAVING E.planner = 'false'
ORDER BY first_name


---         Question 9


-- 1 - Find the most lessons 'C' being taken at every school, Answer : Rijschool Tienen.

SET search_path TO r0800982_rijschool;
SELECT LO.name, COUNT(DL.license) AS "Most lessons being taken"
FROM lesson L
INNER JOIN location LO ON L.location_id = LO.id
INNER JOIN vehicle V ON L.vehicle_id = V.id
INNER JOIN driving_license DL ON V.license_id = DL.id
INNER JOIN customer C ON L.customer_id_practical_course = C.id
WHERE DL.license = 'C'
GROUP BY LO.name
ORDER BY 2 DESC;


-- 2 - Find the most lessons 'C' being taken at rijschool Tienen

-- Answer:  "Laïla"	"Bengefield"
--          "André"	"Hizir"
--          "Gösta"	"Moscrop"
--          "Marie-hélène"	"Dargue"


---         Question 10


-- Answer : Toyota Prius

SET search_path TO r0800982_rijschool;
SELECT V.brand, V.model, V.license_id, DL.license, DL.transmission
FROM vehicle V
INNER JOIN driving_license DL ON V.license_id = DL.id
WHERE license = 'B' AND transmission = 'Automatic'
ORDER BY 1;


---         Question 11


SET search_path TO r0800982_rijschool;

SELECT *
FROM vehicle 
WHERE license_plate LIKE '%99' AND license_plate LIKE 'M%';

---         Question 12

-- Answers : NULL NULL	15	"T"	"Manual"
-- 		       NULL NULL  30	"T"	"Automatic"

SET search_path TO r0800982_rijschool;

SELECT V.brand, V.model, DL.id, DL.license, DL.transmission
--FROM driving_license
FROM vehicle V
RIGHT JOIN driving_license DL ON DL.id = V.license_ID
WHERE V.id is NULL;

---         Question 13


SET search_path TO r0800982_rijschool;

SELECT C.name, C.first_name, DL.id, DL.license, DL.transmission
FROM customer C
INNER JOIN customer_driving_license CDL ON C.id = CDL.customer_id
--FROM customer_driving_license CDL
RIGHT JOIN driving_license DL ON CDL.driving_license_id = DL.id
WHERE DL.license = 'T'
ORDER BY name
LIMIT 5;


---         Question 14


SET search_path TO r0800982_rijschool;

SELECT L.date, L.practical, L.employee_id_teacher, L.subject_id, S.title
FROM lesson L
INNER JOIN subject S ON L.subject_id = S.id
LEFT JOIN classroom C ON L.classroom_id = C.id
WHERE practical is true;


---         Question 15


SET search_path TO r0800982_rijschool;

UPDATE lesson
SET subject_id = 500
WHERE practical is true;

UPDATE vehicle
SET model = 'YZF_R6'
WHERE model = 'R1M';


---         Question 16

-- Answer: Relationship table that indicates which driving licenses are required for other driving licenses.
--         Imagine you need to figure out what license you need for A: you take a look at the relationship table.
--         It's really simple lol


---         Question 17


SET search_path TO r0800982_rijschool;

SELECT -- It's also possible to make 2 joins on the same table. Good practice, again thank you Sergey!!
    dl1.id AS driving_license_id_for,
    dl1.license AS driving_license_for,
    dl2.id AS driving_license_id_needed,
    dl2.license AS driving_license_needed
FROM
    license_requires_license lrl
INNER JOIN
    driving_license dl1 ON lrl.driving_license_id_for = dl1.id
INNER JOIN
    driving_license dl2 ON lrl.driving_license_id_needed = dl2.id;


---         Question 18


SET search_path TO r0800982_rijschool;

SELECT S.max_nr_of_participants, L.classroom_id, COUNT(L.classroom_id)
FROM lesson L
INNER JOIN subject S ON L.subject_id = S.id
WHERE classroom_id = 103
GROUP BY S.max_nr_of_participants, L.classroom_id 
HAVING S.max_nr_of_participants >= 10
ORDER BY 1 DESC;


---         Question 19


SET search_path TO r0800982_rijschool;
SELECT subject_id,
    COUNT(*) AS total_theoretical_lessons,
    ROUND(AVG(COUNT(*)) OVER ()) AS average_theoretical_lessons
FROM lesson
WHERE theoretical = true AND subject_id IN (35, 65)
GROUP BY subject_id
ORDER BY total_theoretical_lessons DESC;


---         Question 20


--SET search_path TO rijschool;

SELECT
    C.first_name,
    C.name,
    C.passed_theory_exam,
    LO.name,
    COUNT(*) AS "total_lessons_failed"
FROM
    lesson L
INNER JOIN
    location LO ON L.location_id = LO.id
INNER JOIN
    customer_following_theory_lesson TL ON L.id = TL.lesson_id
INNER JOIN
    customer C ON TL.customer_id = C.id
WHERE
    C.passed_theory_exam = false
GROUP BY
    C.first_name,
    C.name,
    C.passed_theory_exam,
    LO.name
ORDER BY
    "total_lessons_failed" DESC
LIMIT 5;

-- Calculate the average for the top 5 rows
SELECT
    ROUND(AVG("total_lessons_failed")) AS "Average lessons top 5"
FROM (
    -- Your original query here
    SELECT
        C.first_name,
        C.name,
        C.passed_theory_exam,
        LO.name,
        COUNT(*) AS "total_lessons_failed"
    FROM
        lesson L
    INNER JOIN
        location LO ON L.location_id = LO.id
    INNER JOIN
        customer_following_theory_lesson TL ON L.id = TL.lesson_id
    INNER JOIN
        customer C ON TL.customer_id = C.id
    WHERE
        C.passed_theory_exam = false
    GROUP BY
        C.first_name,
        C.name,
        C.passed_theory_exam,
        LO.name
    ORDER BY
        "total_lessons_failed" DESC
    LIMIT 5
) AS top5;


