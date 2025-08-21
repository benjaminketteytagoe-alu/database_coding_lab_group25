-- A Database for tracking Linux and Python course grades

-- Create database
CREATE DATABASE IF NOT EXISTS alu_coding_lab_group25;

USE alu_coding_lab_group25;

-- Drop tables if they exist to know if tables already exist or not
DROP TABLE IF EXISTS linux_grades;

DROP TABLE IF EXISTS python_grades;

DROP TABLE IF EXISTS students;

-- Create students table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    intake_year INT NOT NULL
);

-- Create linux_grades table
CREATE TABLE linux_grades (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL DEFAULT 'Linux Fundamentals',
    student_id INT NOT NULL,
    grade_obtained DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students (student_id)
);

-- Create python_grades table
CREATE TABLE python_grades (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL DEFAULT 'Python Programming',
    student_id INT NOT NULL,
    grade_obtained DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students (student_id)
);
-- QUERY 1: Inserting sample data into each table for effectiveness and trials

-- Insert students data (15+ students from different intake years)
INSERT INTO
    students (student_name, intake_year)
VALUES ('Alice Uwimana', 2022),
    ('Bob Nkurunziza', 2023),
    ('Catherine Mukamana', 2022),
    ('David Habimana', 2023),
    ('Emma Nyirahabimana', 2021),
    ('Frank Gasana', 2022),
    ('Grace Uwimana', 2023),
    ('Henry Mugisha', 2021),
    ('Isabella Uwase', 2022),
    ('Joseph Niyonzima', 2023),
    ('Kate Mukamugema', 2021),
    ('Liam Uwizeyimana', 2022),
    ('Marie Uwineza', 2023),
    ('Nathan Nsengimana', 2021),
    ('Olivia Uwimana', 2022),
    ('Patrick Gasana', 2023),
    ('Queen Mukamana', 2022),
    ('Robert Habimana', 2021);

-- Insert Linux grades (mix of students, some scoring below 50%)
INSERT INTO
    linux_grades (
        course_name,
        student_id,
        grade_obtained
    )
VALUES ('Linux Fundamentals', 1, 78.5),
    ('Linux Fundamentals', 2, 45.0),
    ('Linux Fundamentals', 3, 82.3),
    ('Linux Fundamentals', 4, 38.7),
    ('Linux Fundamentals', 5, 91.2),
    ('Linux Fundamentals', 6, 67.8),
    ('Linux Fundamentals', 7, 42.1),
    ('Linux Fundamentals', 8, 85.6),
    ('Linux Fundamentals', 9, 73.4),
    (
        'Linux Fundamentals',
        10,
        56.9
    ),
    (
        'Linux Fundamentals',
        11,
        48.3
    ),
    (
        'Linux Fundamentals',
        12,
        89.7
    ),
    (
        'Linux Fundamentals',
        13,
        35.8
    ),
    (
        'Linux Fundamentals',
        14,
        76.2
    );
<<<<<<< HEAD



-- Insert Python grades (mix of students, some took only Python, some took both)
INSERT INTO
    python_grades (
        course_name,
        student_id,
        grade_obtained
    )
VALUES ('Python Programming', 1, 85.2),
    ('Python Programming', 3, 79.6),
    ('Python Programming', 5, 88.4),
    ('Python Programming', 6, 72.1),
    ('Python Programming', 8, 92.3),
    ('Python Programming', 9, 68.7),
    (
        'Python Programming',
        10,
        81.5
    ),
    (
        'Python Programming',
        12,
        94.8
    ),
    (
        'Python Programming',
        14,
        87.9
    ),
    (
        'Python Programming',
        15,
        76.3
    ),
    (
        'Python Programming',
        16,
        69.8
    ),
    (
        'Python Programming',
        17,
        83.6
    ),
    (
        'Python Programming',
        18,
        91.4
    );
-- QUERY 2: Find students who scored less than 50% in the Linux course

-- Students with Linux grades below 50% using inner joins
SELECT s.student_id, s.student_name, s.intake_year, lg.grade_obtained as linux_grade
FROM students s
    JOIN linux_grades lg ON s.student_id = lg.student_id
WHERE
    lg.grade_obtained < 50
ORDER BY lg.grade_obtained ASC;

-- QUERY 3: Find students who took only one course (either Linux or Python, not both)

-- Students who took only Linux (not Python)
SELECT s.student_id, s.student_name, s.intake_year, 'Linux Only' as course_taken
FROM
    students s
    JOIN linux_grades lg ON s.student_id = lg.student_id
    LEFT JOIN python_grades pg ON s.student_id = pg.student_id
WHERE
    pg.student_id IS NULL
UNION

-- Students who took only Python (not Linux)
SELECT s.student_id, s.student_name, s.intake_year, 'Python Only' as course_taken
FROM
    students s
    JOIN python_grades pg ON s.student_id = pg.student_id
    LEFT JOIN linux_grades lg ON s.student_id = lg.student_id
WHERE
    lg.student_id IS NULL
ORDER BY student_id;

-- QUERY 4: Find students who took both courses

-- Students who took both Linux and Python courses
SELECT
    s.student_id,
    s.student_name,
    s.intake_year,
    lg.grade_obtained as linux_grade,
    pg.grade_obtained as python_grade
FROM
    students s
    JOIN linux_grades lg ON s.student_id = lg.student_id
    JOIN python_grades pg ON s.student_id = pg.student_id
ORDER BY s.student_id;

-- QUERY 5: Calculate the average grade per course (Linux and Python separately)

-- Average grade for Linux course
SELECT
    'Linux Fundamentals' as course_name,
    ROUND(AVG(grade_obtained), 2) as average_grade, -- this calculates the average and rounds to two decimal places
    COUNT(*) as total_students
FROM linux_grades
UNION

-- Average grade for Python course
SELECT
    'Python Programming' as course_name,
    ROUND(AVG(grade_obtained), 2) as average_grade,
    COUNT(*) as total_students
FROM python_grades;

-- =========================================================================
-- QUERY 6: Identify the top-performing student across both courses
-- =========================================================================

-- Top-performing student based on average of their grades across both courses
SELECT
    s.student_id,
    s.student_name,
    s.intake_year,
    lg.grade_obtained as linux_grade,
    pg.grade_obtained as python_grade,
    ROUND(
        (
            lg.grade_obtained + pg.grade_obtained
        ) / 2,
        2
    ) as average_grade
FROM
    students s
    JOIN linux_grades lg ON s.student_id = lg.student_id
    JOIN python_grades pg ON s.student_id = pg.student_id
ORDER BY average_grade DESC
LIMIT 1;

-- =========================================================================
-- ADDITIONAL USEFUL QUERIES
-- =========================================================================

-- Summary statistics for all students
SELECT 'Total Students' as metric, COUNT(*) as count
FROM students
UNION
SELECT 'Students in Linux Course' as metric, COUNT(*) as count
FROM linux_grades
UNION
SELECT 'Students in Python Course' as metric, COUNT(*) as count
FROM python_grades
UNION
SELECT 'Students in Both Courses' as metric, COUNT(*) as count
FROM (
        SELECT s.student_id
        FROM
            students s
            JOIN linux_grades lg ON s.student_id = lg.student_id
            JOIN python_grades pg ON s.student_id = pg.student_id
    ) as both_courses;

-- View all data for verification
SELECT '=== STUDENTS TABLE ===' as info;

SELECT * FROM students ORDER BY student_id;

SELECT '=== LINUX GRADES TABLE ===' as info;

SELECT * FROM linux_grades ORDER BY student_id;

SELECT '=== PYTHON GRADES TABLE ===' as info;

SELECT * FROM python_grades ORDER BY student_id;
