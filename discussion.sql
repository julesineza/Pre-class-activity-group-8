-- creating the tables 
CREATE TABLE IF NOT EXISTS students ( student_id INT PRIMARY KEY AUTO_INCREMENT, student_name VARCHAR(20), intake_year INT);

CREATE TABLE if NOT EXISTS linux_grades ( course_id INT PRIMARY KEY AUTO_INCREMENT , course_name VARCHAR(20) , student_id INT , grade_obtained FLOAT , FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE table IF NOT EXISTS python_grades (course_id INT PRIMARY KEY AUTO_INCREMENT, course_name VARCHAR(20) ,student_id INT , grade_obtained FLOAT , Foreign Key (student_id) REFERENCES students(student_id));

--inserting sample data

INSERT INTO students (student_name, intake_year) VALUES 
('Alice Mukamana', 2022),
('Jean Bosco', 2023),
('Claudine Uwase', 2022),
('Eric Niyonzima', 2021),
('Sandrine Ingabire', 2023),
('Patrick Mugisha', 2022),
('Aline Dusenge', 2021),
('David Habimana', 2023),
('Esther Uwimana', 2022),
('Brian Ntirenganya', 2022),
('Diane Umutoni', 2023),
('Samuel Mugenzi', 2021),
('Naomi Uwamahoro', 2022),
('Kevin Rugira', 2021),
('Hope Mbabazi', 2023);


INSERT into linux_grades (course_name,student_id, grade_obtained) VALUES 
('Linux Fundamentals', 1, 85),
('Linux Fundamentals', 2, 78),
('Linux Fundamentals', 4, 88),
('Linux Fundamentals', 6, 73),
('Linux Fundamentals', 7, 90),
('Linux Fundamentals', 9, 67),
('Linux Fundamentals', 10, 92),
('Linux Fundamentals', 12, 80),
('Linux Fundamentals', 13, 76),
('Linux Fundamentals', 15, 45);


INSERT into python_grades (course_name,student_id, grade_obtained) VALUES 
('Python Programming', 1, 91),
('Python Programming', 3, 83),
('Python Programming', 4, 88),
('Python Programming', 5, 72),
('Python Programming', 6, 79),
('Python Programming', 8, 64),
('Python Programming', 9, 86),
('Python Programming', 10, 93),
('Python Programming', 11, 77),
('Python Programming', 13, 84),
('Python Programming', 14, 68),
('Python Programming', 15, 75);

--Find students who scored less than 50% in the Linux course

SELECT s.student_name, l.grade_obtained
FROM students s
JOIN linux_grades l ON s.student_id = l.student_id
WHERE l.grade_obtained < 50



-- Find students who took only one course (either Linux or Python, not both).

SELECT student_id, student_name
FROM students
WHERE student_id IN (
    SELECT student_id FROM linux_grades
    WHERE student_id NOT IN (SELECT student_id FROM python_grades)
    UNION
    SELECT student_id FROM python_grades
    WHERE student_id NOT IN (SELECT student_id FROM linux_grades)
);




--Find students who took both courses.

SELECT s.student_name , s.intake_year , lg.grade_obtained as linux_grade , pg.grade_obtained as python_grade
FROM students s 
INNER JOIN linux_grades lg ON s.student_id = lg.student_id
INNER JOIN python_grades pg ON s.student_id = pg.student_id
ORDER BY s.student_name;

--Calculate the average grade per course (Linux and Python separately).
SELECT 'Linux Fundamentals' AS course, ROUND(AVG(grade_obtained),2) AS avg_grade
FROM linux_grades
UNION
SELECT 'Python Programming' as course, ROUND(AVG(grade_obtained),2) AS avg_grade
FROM python_grades;

--Identify the top-performing student across both courses (based on the average of their grades).
SELECT 
    s.student_name,
    s.intake_year,
    ROUND(AVG(combined_grades.grade_obtained), 2) as overall_average,
    COUNT(combined_grades.grade_obtained) as courses_taken
FROM students s
JOIN (
    SELECT student_id, grade_obtained FROM linux_grades
    UNION ALL
    SELECT student_id, grade_obtained FROM python_grades
) combined_grades ON s.student_id = combined_grades.student_id
GROUP BY s.student_id, s.student_name, s.intake_year
ORDER BY overall_average DESC
LIMIT 1;