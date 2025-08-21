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
