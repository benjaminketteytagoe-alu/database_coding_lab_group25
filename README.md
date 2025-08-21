# ALU Rwanda Student Performance Database

A comprehensive MySQL database system designed to track and analyze student grades for Linux and Python courses at African Leadership University (ALU) Rwanda.


## Project Overview

This project implements a relational database system to efficiently manage and analyze student performance data across two core technical courses at ALU Rwanda:

- **Linux Fundamentals** - System administration and command-line proficiency
- **Python Programming** - Programming fundamentals and application development

The system enables academic administrators, instructors, and students to track progress, identify performance patterns, and make data-driven decisions about academic support and curriculum improvements.

### Key Objectives

- **Performance Tracking**: Monitor individual student progress across multiple courses
- **Academic Analytics**: Generate insights on course difficulty and student success rates
- **Intervention Support**: Identify at-risk students requiring additional academic support
- **Curriculum Assessment**: Evaluate course effectiveness through grade distribution analysis

## Database Architecture

The database follows a normalized relational design with three core entities:

```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐
│   students  │    │ linux_grades │    │python_grades │
├─────────────┤    ├──────────────┤    ├──────────────┤
│ student_id  │◄───┤ student_id   │    │ student_id   │───►
│ student_name│    │ course_id    │    │ course_id    │
│ intake_year │    │ course_name  │    │ course_name  │
└─────────────┘    │grade_obtained│    │grade_obtained│
                   └──────────────┘    └──────────────┘
```

### Design Principles

- **Normalization**: Eliminates data redundancy and ensures data integrity
- **Referential Integrity**: Foreign key constraints maintain data consistency
- **Scalability**: Structure supports easy addition of new courses and students
- **Performance**: Optimized for common query patterns and reporting needs

## Prerequisites

### Software Requirements

- **MySQL Server** (Version 5.7 or higher)
- **MySQL Workbench** or command-line client
- **Git** for version control

### System Requirements

- Operating System: Windows, macOS, or Linux
- Memory: Minimum 4GB RAM
- Storage: At least 100MB free space
- Network: Internet connection for downloading dependencies

## Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/benjaminketteytagoe-alu/database_coding_lab_group25.git
cd database_coding_lab_group25
```

### 2. Database Setup

#### Option A: MySQL Workbench
1. Open MySQL Workbench
2. Connect to your MySQL server
3. Open the `group25_queries.sql` file
4. Execute the entire script

#### Option B: Command Line
```bash
mysql -u [username] -p < group25_queries.sql
```

### 3. Verify Installation

```sql
USE alu_coding_lab_group25;
SHOW TABLES;
```

Expected output:
```
+----------------------------------+
| Tables_in_alu_student_performance|
+----------------------------------+
| linux_grades                     |
| python_grades                    |
| students                         |
+----------------------------------+
```

## Database Schema

### Students Table

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| student_id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique student identifier |
| student_name | VARCHAR(100) | NOT NULL | Full student name |
| intake_year | INT | NOT NULL | Year student enrolled at ALU |

**Purpose**: Central repository for student information across all academic programs.

### Linux Grades Table

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| course_id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique course record identifier |
| course_name | VARCHAR(100) | NOT NULL, DEFAULT 'Linux Fundamentals' | Course title |
| student_id | INT | FOREIGN KEY → students(student_id) | Reference to student |
| grade_obtained | DECIMAL(5,2) | NOT NULL | Student's numerical grade (0-100) |

**Purpose**: Tracks student performance in Linux system administration course.

### Python Grades Table

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| course_id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique course record identifier |
| course_name | VARCHAR(100) | NOT NULL, DEFAULT 'Python Programming' | Course title |
| student_id | INT | FOREIGN KEY → students(student_id) | Reference to student |
| grade_obtained | DECIMAL(5,2) | NOT NULL | Student's numerical grade (0-100) |

**Purpose**: Tracks student performance in Python programming course.

## Sample Data

The database includes comprehensive test data representing realistic scenarios:

### Student Demographics
- **Total Students**: 18 students
- **Intake Years**: 2021-2023 (simulating multiple cohorts)
- **Names**: Authentic Rwandan names reflecting local culture
- **Distribution**: Even spread across intake years

### Course Enrollment Patterns
- **Linux Only**: 5 students (28%)
- **Python Only**: 4 students (22%)
- **Both Courses**: 9 students (50%)
- **Total Enrollments**: 27 course registrations

### Grade Distribution
- **Linux Course**: 14 students enrolled
  - Average: 64.8%
  - Range: 35.8% - 91.2%
  - Below 50%: 4 students (29%)

- **Python Course**: 13 students enrolled
  - Average: 82.4%
  - Range: 68.7% - 94.8%
  - Below 50%: 0 students

## Query Implementations

### 1. Sample Data Insertion
**Purpose**: Populate database with representative test data
**Technique**: Bulk INSERT statements with realistic values
**Result**: 18 students, 14 Linux grades, 13 Python grades

### 2. Low-Performing Linux Students
```sql
SELECT s.student_name, lg.grade_obtained
FROM students s
JOIN linux_grades lg ON s.student_id = lg.student_id
WHERE lg.grade_obtained < 50;
```
**Purpose**: Identify students needing academic intervention
**Technique**: INNER JOIN with WHERE clause filtering
**Result**: 4 students scoring below 50% in Linux

### 3. Single-Course Students
```sql
-- Linux only students
SELECT s.student_name, 'Linux Only' as course_taken
FROM students s
JOIN linux_grades lg ON s.student_id = lg.student_id
LEFT JOIN python_grades pg ON s.student_id = pg.student_id
WHERE pg.student_id IS NULL

UNION

-- Python only students  
SELECT s.student_name, 'Python Only' as course_taken
FROM students s
JOIN python_grades pg ON s.student_id = pg.student_id
LEFT JOIN linux_grades lg ON s.student_id = lg.student_id
WHERE lg.student_id IS NULL;
```
**Purpose**: Analyze course selection patterns
**Technique**: LEFT JOIN with NULL checks, UNION for combining results
**Result**: 9 students taking only one course

### 4. Dual-Course Students
```sql
SELECT s.student_name, lg.grade_obtained, pg.grade_obtained
FROM students s
JOIN linux_grades lg ON s.student_id = lg.student_id
JOIN python_grades pg ON s.student_id = pg.student_id;
```
**Purpose**: Compare performance across both courses
**Technique**: INNER JOINs requiring presence in both grade tables
**Result**: 9 students enrolled in both courses

### 5. Course Performance Analytics
```sql
SELECT 'Linux Fundamentals' as course, AVG(grade_obtained) as avg_grade
FROM linux_grades
UNION
SELECT 'Python Programming' as course, AVG(grade_obtained) as avg_grade
FROM python_grades;
```
**Purpose**: Compare overall course difficulty and student success
**Technique**: Aggregate functions with UNION for comparative analysis
**Result**: Linux avg: 64.8%, Python avg: 82.4%

### 6. Top Student Identification
```sql
SELECT s.student_name, 
       ROUND((lg.grade_obtained + pg.grade_obtained) / 2, 2) as avg_grade
FROM students s
JOIN linux_grades lg ON s.student_id = lg.student_id
JOIN python_grades pg ON s.student_id = pg.student_id
ORDER BY avg_grade DESC LIMIT 1;
```
**Purpose**: Recognize highest-achieving student across both courses
**Technique**: Calculated field with aggregate function, ORDER BY with LIMIT
**Result**: Top student with 90.35% average

## Usage Instructions

### Running Individual Queries

1. **Connect to Database**:
   ```sql
   USE alu_coding_lab_group25;
   ```

2. **Execute Specific Query**: Copy and paste any query from the SQL file

3. **Modify Parameters**: Adjust grade thresholds, course names, or date ranges as needed

### Common Use Cases

#### Academic Advisors
- Identify at-risk students: Run Query #2
- Track dual-enrollment students: Run Query #4
- Generate performance reports: Run Query #5

#### Course Instructors  
- Assess course difficulty: Compare averages from Query #5
- Find high-achievers: Run Query #6
- Analyze enrollment patterns: Run Query #3

#### Students
- Check personal grades: Modify queries with specific student_id
- Compare with class average: Use Query #5 results as benchmark

### Data Maintenance

#### Adding New Students
```sql
INSERT INTO students (student_name, intake_year) 
VALUES ('New Student', 2024);
```

#### Recording New Grades
```sql
INSERT INTO linux_grades (student_id, grade_obtained) 
VALUES (19, 78.5);
```

#### Updating Existing Grades
```sql
UPDATE linux_grades 
SET grade_obtained = 82.0 
WHERE student_id = 1;
```

## Testing & Validation

### Data Integrity Tests

1. **Foreign Key Constraints**:
   ```sql
   -- This should fail
   INSERT INTO linux_grades (student_id, grade_obtained) 
   VALUES (999, 75.0);
   ```

2. **Grade Range Validation**:
   ```sql
   -- Verify all grades are 0-100
   SELECT * FROM linux_grades WHERE grade_obtained < 0 OR grade_obtained > 100;
   SELECT * FROM python_grades WHERE grade_obtained < 0 OR grade_obtained > 100;
   ```

3. **Data Completeness**:
   ```sql
   -- Check for NULL values
   SELECT * FROM students WHERE student_name IS NULL OR intake_year IS NULL;
   ```

### Query Result Validation

- **Query #2**: Should return exactly 4 students with Linux grades < 50%
- **Query #3**: Should return 9 students (5 Linux-only + 4 Python-only)
- **Query #4**: Should return exactly 9 students with both course grades
- **Query #5**: Linux average ≈ 64.8%, Python average ≈ 82.4%
- **Query #6**: Should return one student with highest combined average

### Performance Testing

```sql
-- Check query execution time
SET profiling = 1;
[Run your query]
SHOW PROFILES;
```

## Performance Analysis

### Key Insights from Sample Data

1. **Course Difficulty**: 
   - Python shows higher average grades (82.4% vs 64.8%)
   - Linux has 29% failure rate (< 50%), Python has 0%
   - Suggests Linux requires more foundational support

2. **Enrollment Patterns**:
   - 50% of students take both courses (ideal for comprehensive learning)
   - 28% take only Linux (possibly system administration focus)
   - 22% take only Python (possibly development focus)

3. **Academic Success Factors**:
   - Students taking both courses show higher engagement
   - Intake year doesn't significantly correlate with performance
   - Individual variation suggests need for personalized support

### Recommendations

1. **Academic Support**: Implement Linux tutoring program for struggling students
2. **Course Sequencing**: Consider making Python prerequisite for Linux
3. **Resource Allocation**: Increase Linux lab hours and practice opportunities
4. **Success Tracking**: Monitor dual-course students for comprehensive skill development

## Advanced Features

### Indexes for Performance
```sql
-- Add indexes for frequently queried columns
CREATE INDEX idx_student_intake ON students(intake_year);
CREATE INDEX idx_linux_grade ON linux_grades(grade_obtained);
CREATE INDEX idx_python_grade ON python_grades(grade_obtained);
```

### Views for Common Queries
```sql
-- Create view for comprehensive student overview
CREATE VIEW student_overview AS
SELECT 
    s.student_id,
    s.student_name,
    s.intake_year,
    lg.grade_obtained AS linux_grade,
    pg.grade_obtained AS python_grade,
    CASE 
        WHEN lg.grade_obtained IS NOT NULL AND pg.grade_obtained IS NOT NULL 
        THEN (lg.grade_obtained + pg.grade_obtained) / 2 
        ELSE NULL 
    END AS average_grade
FROM students s
LEFT JOIN linux_grades lg ON s.student_id = lg.student_id
LEFT JOIN python_grades pg ON s.student_id = pg.student_id;
```

### Stored Procedures (PLSQL)
```sql
-- Procedure to add new student with validation
DELIMITER //
CREATE PROCEDURE AddNewStudent(
    IN p_name VARCHAR(100),
    IN p_year INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF p_year < 2020 OR p_year > YEAR(CURDATE()) + 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid intake year';
    END IF;
    
    INSERT INTO students (student_name, intake_year) VALUES (p_name, p_year);
    
    COMMIT;
END //
DELIMITER ;
```

## Contributing

We welcome contributions to improve this database system! Here's how you can help:

### Development Setup
1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test thoroughly
4. Submit a pull request with detailed description

### Contribution Guidelines
- Follow SQL naming conventions (snake_case)
- Include comprehensive comments for new queries
- Add test data for new features
- Update documentation for schema changes
- Ensure backward compatibility

### Areas for Improvement
- Additional course support
- Grade history tracking
- Performance optimization
- Reporting dashboard integration
- Mobile app API endpoints

