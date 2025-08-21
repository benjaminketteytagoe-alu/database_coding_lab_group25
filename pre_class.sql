-- table creation script for Python and Linux courses
CREATE Table IF NOT EXISTS students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    intake_year INT NOT NULL,
);

CREATE Table IF NOT EXISTS linux_grades (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    student_id INT NOT NULL,
    grade_obtained INT NOT NULL,
);

CREATE Table IF NOT EXISTS python_grades (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    student_id INT NOT NULL,
    grade_obtained INT NOT NULL,
);

-- inserting sample data into students table
INSERT INTO students (student_id, student_name, intake_year) VALUES
(1, 'George Brown', 2022),
(2, 'Ineza Kelly', 2024),
(3, 'Mwiza Stacy', 2023),
(4, 'Niyonsaba Eric', 2022),
(5, 'Niyonzima Chris', 2023),
(6, 'Lucas Garcia', 2024),
(7, 'Ishimwe Miller', 2022),
(8, 'Chloe Wilson', 2023),
(9, 'Jackson Davis', 2024),
(10, 'Noah Davis', 2022),
(11, 'Henry Wilson', 2023),
(12, 'Kundwa Julius', 2024),
(13, 'Irakoze Peace', 2022),
(14, 'Isimbi Eunice', 2023),
(15, 'Gwiza Kenny', 2024);

-- inserting sample data into linux_grades table
INSERT INTO linux_grades (course_id, course_name, student_id, grade_obtained) VALUES
('Linux', 1, 85),
('Linux', 2, 48),
('Linux', 3, 78),
('Linux', 4, 25),
('Linux', 5, 82),
('Linux', 6, 95),
('Linux', 7, 30),
('Linux', 8, 50),
('Linux', 9, 87),
('Linux', 10, 89);
-- inserting sample data into python_grades table
INSERT INTO python_grades (course_id, course_name, student_id, grade_obtained) VALUES
('Python', 15, 74),
('Python', 10, 88),
('Python', 12, 92),
('Python', 14, 43),
('Python', 11, 34),
('Python', 13, 91),
('Python', 9, 87),
('Python', 7, 38),
('Python', 6, 95),
('Python', 5, 82);

-- finding students who scored less than 50 in Linux
SELECT s.student_id, s.student_name, lg.grade_obtained
FROM students s
JOIN linux_grades lg ON s.student_id = lg.student_id
WHERE lg.grade_obtained < 50;

-- finding student who took only one course
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (
    SELECT student_id FROM linux_grades
)
AND s.student_id NOT IN (
    SELECT student_id FROM python_grades
)
UNION
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (
    SELECT student_id FROM python_grades
)
AND s.student_id NOT IN (
    SELECT student_id FROM linux_grades
);

-- finding students who took both courses
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (
    SELECT student_id FROM linux_grades
)
AND s.student_id IN (
    SELECT student_id FROM python_grades
);

-- calculating average grade for each course (linux and python sepately)
SELECT 'Linux' AS course_name, AVG(grade_obtained) AS average_grade
FROM linux_grades
UNION
SELECT 'Python' AS course_name, AVG(grade_obtained) AS average_grade
FROM python_grades;

-- Identifying top-performing student across both courses (based on averrage of their grades)
SELECT s.student_id, s.student_name, AVG(lg.grade_obtained) AS average_linux_grade, AVG(pg.grade_obtained) AS average_python_grade
FROM students s
JOIN linux_grades lg ON s.student_id = lg.student_id
JOIN python_grades pg ON s.student_id = pg.student_id
GROUP BY s.student_id, s.student_name
ORDER BY (AVG(lg.grade_obtained) + AVG(pg.grade_obtained)) DESC
LIMIT 1;
