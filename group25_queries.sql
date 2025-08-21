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
