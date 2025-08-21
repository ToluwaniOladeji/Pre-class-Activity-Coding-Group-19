
-- Student Performance Database - ALU Rwanda

-- 1. Creating the Database
CREATE DATABASE IF NOT EXISTS alu_student_performance;
USE alu_student_performance;

-- 2. Dropping tables if they exist 
DROP TABLE IF EXISTS python_grades;
DROP TABLE IF EXISTS linux_grades;
DROP TABLE IF EXISTS students;

-- 3. Creating Tables
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    intake_year INT NOT NULL
);

CREATE TABLE linux_grades (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(50) DEFAULT 'Linux',
    student_id INT,
    grade_obtained DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE python_grades (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(50) DEFAULT 'Python',
    student_id INT,
    grade_obtained DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- 4. Sample Data
INSERT INTO students VALUES
(1, 'Oladeji Toluwani', 2023),
(2, 'Uchechukwu Chukwuebuka Ezeibe', 2023),
(3, 'Ménès Nagnon Adisso', 2023),
(4, 'Divine Mutesi', 2023),
(5, 'Muludiki Frederick', 2023),
(6, 'Benson Boone', 2024),
(7, 'Adeleke David', 2024),
(8, 'Johnson David', 2024),
(9, 'Diane Celeste', 2024),
(10, 'Ojotule King', 2024),
(11, 'Emma Briggs', 2025),
(12, 'Zion Micheal', 2025),
(13, 'Mitchele Lawal', 2025),
(14, 'Nirere Aliyah Sayinzoga', 2025),
(15, 'Brian Kiki Konyen Nakuwa', 2025);

-- Linux grades 
INSERT INTO linux_grades (student_id, grade_obtained) VALUES
(1, 75.5), (2, 49.0), (3, 88.5), (4, 62.0), (5, 40.0),
(6, 95.0), (7, 55.0), (8, 30.0), (9, 78.0), (10, 82.0),
(11, 69.0);

-- Python grades 
INSERT INTO python_grades (student_id, grade_obtained) VALUES
(3, 91.0), (4, 45.0), (5, 68.0), (6, 85.0), (7, 92.0),
(8, 52.0), (9, 60.0), (12, 73.0), (13, 88.0), (14, 34.0),
(15, 77.0);

-- QUERIES

-- Q1: Students who scored less than 50% in the Linux course
SELECT s.student_id, s.student_name, l.grade_obtained
FROM students s
JOIN linux_grades l ON s.student_id = l.student_id
WHERE l.grade_obtained < 50;

-- Q2: Students who took only one course (Linux OR Python, not both)
SELECT s.student_id, s.student_name
FROM students s
WHERE (s.student_id IN (SELECT student_id FROM linux_grades)
       AND s.student_id NOT IN (SELECT student_id FROM python_grades))
   OR (s.student_id IN (SELECT student_id FROM python_grades)
       AND s.student_id NOT IN (SELECT student_id FROM linux_grades));

-- Q3: Students who took both courses
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (SELECT student_id FROM linux_grades)
  AND s.student_id IN (SELECT student_id FROM python_grades);

-- Q4: Average grade per course
SELECT 'Linux' AS course, AVG(grade_obtained) AS avg_grade
FROM linux_grades
UNION
SELECT 'Python' AS course, AVG(grade_obtained) AS avg_grade
FROM python_grades;

-- Q5: Top-performing student across both courses
-- (average of their grades across Linux + Python)
SELECT s.student_id, s.student_name,
       AVG(g.grade) AS overall_average
FROM students s
JOIN (
    SELECT student_id, grade_obtained AS grade FROM linux_grades
    UNION ALL
    SELECT student_id, grade_obtained AS grade FROM python_grades
) g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
ORDER BY overall_average DESC
LIMIT 1;
