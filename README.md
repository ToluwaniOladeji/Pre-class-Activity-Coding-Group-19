# Student Performance Database – ALU Rwanda

##  Overview
This project is a **pre-class activity** for ALU Rwanda students.  
It uses **MySQL** to create a database that tracks and analyzes student performance in **Linux** and **Python** courses.  

The script (`student_performance.sql`) creates the database, inserts sample data, and demonstrates queries for analyzing student grades.

---

##  Database Structure
The database contains three tables:

1. **students**
   - `student_id` (Primary Key)
   - `student_name`
   - `intake_year`

2. **linux_grades**
   - `course_id` (Primary Key, Auto Increment)
   - `course_name` (default = "Linux")
   - `student_id` (Foreign Key → students)
   - `grade_obtained`

3. **python_grades**
   - `course_id` (Primary Key, Auto Increment)
   - `course_name` (default = "Python")
   - `student_id` (Foreign Key → students)
   - `grade_obtained`

---

##  Sample Data
- **15 students** are included in the dataset.  
- Some students take **only Linux**, some take **only Python**, and some take **both**.  
- Grades are stored as percentages (0–100).

---

##  Queries Implemented
The SQL script answers the following:

1. **Students scoring < 50% in Linux**
   ```sql
   SELECT s.student_id, s.student_name, l.grade_obtained
   FROM students s
   JOIN linux_grades l ON s.student_id = l.student_id
   WHERE l.grade_obtained < 50;
   ```

2. **Students who took only one course (Linux or Python, not both)**  
   ```sql
   SELECT s.student_id, s.student_name
   FROM students s
   WHERE (s.student_id IN (SELECT student_id FROM linux_grades)
          AND s.student_id NOT IN (SELECT student_id FROM python_grades))
      OR (s.student_id IN (SELECT student_id FROM python_grades)
          AND s.student_id NOT IN (SELECT student_id FROM linux_grades));
   ```

3. **Students who took both courses**
   ```sql
   SELECT s.student_id, s.student_name
   FROM students s
   WHERE s.student_id IN (SELECT student_id FROM linux_grades)
     AND s.student_id IN (SELECT student_id FROM python_grades);
   ```

4. **Average grade per course**
   ```sql
   SELECT 'Linux' AS course, AVG(grade_obtained) AS avg_grade
   FROM linux_grades
   UNION
   SELECT 'Python' AS course, AVG(grade_obtained) AS avg_grade
   FROM python_grades;
   ```

5. **Top-performing student across both courses**  
   (Average of their Linux + Python grades)
   ```sql
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
   ```

---

##  How to Run
1. Open MySQL Workbench or MySQL CLI.
2. Load the script:
   ```bash
   SOURCE student_performance.sql;
   ```
3. Switch to the database:
   ```sql
   USE alu_student_performance;
   ```
4. Run queries individually to see results.

---

##  Expected Results (with sample data)
- **Q1:** Students who failed Linux (<50%) → `Uchechukwu`, `Muludiki`, `Johnson`.  
- **Q2:** Students who took only one course → 8 students.  
- **Q3:** Students who took both courses → 7 students.  
- **Q4:** Average Linux grade ≈ `65.8%`, Python grade ≈ `69.5%`.  
- **Q5:** Top performer → **Benson Boone (90%)**.

---

##  Authors
Prepared by **ALU Rwanda Coding Lab Group 19**  
Course: *Linux & Python Programming*
