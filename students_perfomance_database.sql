/*
================================================================================
 Student Performance Database
================================================================================
 This script creates and populates a database to track and analyze the
 performance of students enrolled in Linux and Python courses.

 The database consists of three main tables:
 1. students: Stores information about each student.
 2. linux_grades: Stores grades for the Linux course.
 3. python_grades: Stores grades for the Python course.

 The script also includes several queries to analyze the data.
================================================================================
*/


/*
=============================================================================
Schema Setup: Drop existing tables to ensure a clean slate for re-running the script.
The order is important to avoid foreign key constraint errors.
=============================================================================
*/
DROP TABLE IF EXISTS linux_grades;
DROP TABLE IF EXISTS python_grades;
DROP TABLE IF EXISTS students;
/*
=============================================================================
Table: students
Stores unique information for each student.
=============================================================================
*/
CREATE TABLE students(
    student_id INT PRIMARY KEY,
    student_name VARCHAR(150),
    intake_year YEAR
);

-- Insert 20 students into the students table randomly
INSERT INTO students (student_id, student_name, intake_year)
VALUES
    (1, 'Alice Johnson', 2023),
    (2, 'Bob Smith', 2022),
    (3, 'Charlie Brown', 2023),
    (4, 'Diana Prince', 2024),
    (5, 'Ethan Hunt', 2023),
    (6, 'Fiona Gallagher', 2022),
    (7, 'George Miller', 2024),
    (8, 'Hannah Davis', 2023),
    (9, 'Ian Wright', 2022),
    (10, 'Julia Roberts', 2024),
    (11, 'Kevin Hart', 2023),
    (12, 'Laura Wilson', 2022),
    (13, 'Michael Scott', 2024),
    (14, 'Nina Simone', 2023),
    (15, 'Oscar Wilde', 2022),
    (16, 'Paula Abdul', 2024),
    (17, 'Quincy Jones', 2023),
    (18, 'Rachel Green', 2022),
    (19, 'Steve Rogers', 2024),
    (20, 'Tina Fey', 2023);

/*
=============================================================================
Table: linux_grades
Stores grade information for students enrolled in the Linux course.
=============================================================================
*/
 CREATE TABLE linux_grades (
    course_id INT DEFAULT 1,
    course_name VARCHAR(50),
    student_id INT,
    grade_obtained VARCHAR(5),
    PRIMARY KEY (course_id, student_id),
    Foreign Key (student_id) REFERENCES students(student_id)
 );
/*
=============================================================================
Data Insertion: linux_grades
=============================================================================
*/
INSERT INTO linux_grades (course_id, course_name, student_id, grade_obtained)
VALUES
    (1, 'Linux Basics', 10, '85%'),
    (1, 'Linux Basics', 11, '90%'),
    (1, 'Linux Basics', 12, '78%'),
    (1, 'Linux Basics', 13, '88%'),
    (1, 'Linux Basics', 14, '92%'),
    (1, 'Linux Basics', 15, '80%'),
    (1, 'Linux Basics', 16, '95%'),
    (1, 'Linux Basics', 17, '89%'),
    (1, 'Linux Basics', 18, '76%'),
    (1, 'Linux Basics', 19, '84%'),
    (1, 'Linux Basics', 20, '91%'),
    (1, 'Linux Basics', 1, '45%'),
    (1, 'Linux Basics', 2, '49%');

/*
=============================================================================
Query 1: Find students who scored below 50% in the Linux Basics course.
This query uses an INNER JOIN to link students with their Linux grades
and filters for grades less than 50.
=============================================================================
*/
SELECT s.student_name
FROM students s
JOIN linux_grades lg ON s.student_id = lg.student_id
WHERE lg.course_name = 'Linux Basics' AND CAST(REPLACE(lg.grade_obtained, '%', '') AS UNSIGNED) < 50;
/*
=============================================================================
Table: python_grades
Stores grade information for students enrolled in the Python course.
=============================================================================
*/
CREATE TABLE python_grades (
    course_id INT DEFAULT 2,
    course_name VARCHAR(50),
    student_id INT,
    grade_obtained VARCHAR(5),
    PRIMARY KEY (course_id, student_id),
    Foreign Key (student_id) REFERENCES students(student_id)
 );
 /*
=============================================================================
Data Insertion: python_grades
=============================================================================
*/
INSERT INTO python_grades (course_id, course_name, student_id, grade_obtained)
VALUES
    (2, 'Python Basics', 3, '88%'),
    (2, 'Python Basics', 4, '92%'),
    (2, 'Python Basics', 5, '85%'),
    (2, 'Python Basics', 6, '78%'),
    (2, 'Python Basics', 7, '90%'),
    (2, 'Python Basics', 8, '87%'),
    (2, 'Python Basics', 9, '80%'),
    (2, 'Python Basics', 1, '95%'),
    (2, 'Python Basics', 11, '89%'),
    (2, 'Python Basics', 2, '76%'),
    (2, 'Python Basics', 13, '84%'),
    (2, 'Python Basics', 14, '91%'),
    (2, 'Python Basics', 15, '45%'),
    (2, 'Python Basics', 16, '49%'),
    (2, 'Python Basics', 17, '88%');

/*
=============================================================================
Query 2: List students who are enrolled in only one of the two courses.
This is achieved by using LEFT JOINs from the students table to each
grades table and then finding rows where one join succeeded (is NOT NULL)
and the other failed (is NULL).
=============================================================================
*/
SELECT s.student_id, s.student_name
FROM students s
LEFT JOIN linux_grades lg ON s.student_id = lg.student_id
LEFT JOIN python_grades pg ON s.student_id = pg.student_id
WHERE (lg.student_id IS NULL AND pg.student_id IS NOT NULL)
   OR (lg.student_id IS NOT NULL AND pg.student_id IS NULL);
/*
=============================================================================
Query 3: List students who are enrolled in both Linux and Python courses.
An INNER JOIN between all three tables effectively filters for students
who have records in both the linux_grades and python_grades tables.
=============================================================================
*/
SELECT s.student_id, s.student_name
FROM students s
JOIN linux_grades lg ON s.student_id = lg.student_id
JOIN python_grades pg ON s.student_id = pg.student_id;

/*
=============================================================================
Query 4: Calculate the average grade for each course.
This query calculates the average for each course in a separate SELECT
statement and then combines the results into a single list using UNION ALL.
The grade, stored as a string like '85%', is converted to a number first.
=============================================================================

*/
SELECT lg.course_name AS course, AVG(CAST(REPLACE(lg.grade_obtained, '%', '') AS UNSIGNED)) AS average_grade
FROM linux_grades lg
GROUP BY lg.course_name
UNION ALL
SELECT pg.course_name AS course, AVG(CAST(REPLACE(pg.grade_obtained, '%', '') AS UNSIGNED)) AS average_grade
FROM python_grades pg
GROUP BY pg.course_name;

/*
=============================================================================
Query 5: Identify the top-performing student based on their average grade
across both courses.
A Common Table Expression (CTE) named 'all_grades' is used to create a
temporary, unified list of all grades from both courses. This simplifies
the main query, which then calculates the average for each student and
finds the one with the highest average.
=============================================================================

*/
WITH all_grades AS (
    SELECT student_id, CAST(REPLACE(grade_obtained, '%', '') AS UNSIGNED) AS numeric_grade
    FROM linux_grades
    UNION ALL
    SELECT student_id, CAST(REPLACE(grade_obtained, '%', '') AS UNSIGNED) AS numeric_grade
    FROM python_grades
)
SELECT 
    s.student_name, 
    AVG(ag.numeric_grade) AS average_grade
FROM 
    students s
JOIN 
    all_grades ag ON s.student_id = ag.student_id
GROUP BY 
    s.student_id, s.student_name
ORDER BY 
    average_grade DESC
LIMIT 1;