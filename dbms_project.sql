SET FOREIGN_KEY_CHECKS = 0;

-- ============================================
-- STEP 1: CLEAN ALL EXISTING DATA
-- ============================================

-- Delete data from all tables in reverse dependency order
DELETE FROM clo_attainment;
DELETE FROM student_scores;
DELETE FROM assessment_clo_mapping;
DELETE FROM assessment_tools;
DELETE FROM clo_plo_mapping;
DELETE FROM clos;
DELETE FROM enrollments;
DELETE FROM faculty_courses;
DELETE FROM courses;
DELETE FROM plos;
DELETE FROM programs;
DELETE FROM users;

-- Reset auto-increment counters
ALTER TABLE clo_attainment AUTO_INCREMENT = 1;
ALTER TABLE student_scores AUTO_INCREMENT = 1;
ALTER TABLE assessment_clo_mapping AUTO_INCREMENT = 1;
ALTER TABLE assessment_tools AUTO_INCREMENT = 1;
ALTER TABLE clo_plo_mapping AUTO_INCREMENT = 1;
ALTER TABLE clos AUTO_INCREMENT = 1;
ALTER TABLE enrollments AUTO_INCREMENT = 1;
ALTER TABLE faculty_courses AUTO_INCREMENT = 1;
ALTER TABLE courses AUTO_INCREMENT = 1;
ALTER TABLE plos AUTO_INCREMENT = 1;
ALTER TABLE programs AUTO_INCREMENT = 1;
ALTER TABLE users AUTO_INCREMENT = 1;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- STEP 2: START TRANSACTION FOR DATA INSERTION
-- ============================================

START TRANSACTION;

-- ============================================
-- SEED USERS (Admin, Faculty, Students)
-- ============================================

INSERT INTO users (username, password, email, role, full_name) VALUES
('admin', 'adminpassword', 'admin@thapar.edu', 'admin', 'Admin User'),
('faculty1', 'facultypassword', 'faculty1@thapar.edu', 'faculty', 'Dr. Jane Doe'),
('faculty2', 'facultypassword', 'faculty2@thapar.edu', 'faculty', 'Dr. Rajesh Kumar'),
('faculty3', 'facultypassword', 'faculty3@thapar.edu', 'faculty', 'Dr. Sarah Johnson'),
('student1', 'studentpassword', 'student1@thapar.edu', 'student', 'Rohan Sharma'),
('student2', 'studentpassword', 'student2@thapar.edu', 'student', 'Priya Singh'),
('student3', 'studentpassword', 'student3@thapar.edu', 'student', 'Amit Patel'),
('student4', 'studentpassword', 'student4@thapar.edu', 'student', 'Sneha Gupta'),
('student5', 'studentpassword', 'student5@thapar.edu', 'student', 'Vikram Reddy'),
('student6', 'studentpassword', 'student6@thapar.edu', 'student', 'Anjali Mehta');

-- Get User IDs for reference
SET @admin_id = (SELECT user_id FROM users WHERE username = 'admin');
SET @faculty1_id = (SELECT user_id FROM users WHERE username = 'faculty1');
SET @faculty2_id = (SELECT user_id FROM users WHERE username = 'faculty2');
SET @faculty3_id = (SELECT user_id FROM users WHERE username = 'faculty3');
SET @student1_id = (SELECT user_id FROM users WHERE username = 'student1');
SET @student2_id = (SELECT user_id FROM users WHERE username = 'student2');
SET @student3_id = (SELECT user_id FROM users WHERE username = 'student3');
SET @student4_id = (SELECT user_id FROM users WHERE username = 'student4');
SET @student5_id = (SELECT user_id FROM users WHERE username = 'student5');
SET @student6_id = (SELECT user_id FROM users WHERE username = 'student6');

-- ============================================
-- SEED PROGRAM
-- ============================================

INSERT INTO programs (program_code, program_name, department, description) VALUES
('BEECE', 'B.E. (Electrical and Computer Engineering)', 'Electrical and Computer Engineering', 'Course Scheme and Syllabus for B.E. (Electrical and Computer Engineering) 2023 Batch.');

SET @program_id = LAST_INSERT_ID();

-- ============================================
-- SEED PLOs (Program Learning Outcomes)
-- ============================================

INSERT INTO plos (program_id, plo_code, plo_description) VALUES
(@program_id, 'PLO1', 'Engineering knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems.'),
(@program_id, 'PLO2', 'Problem analysis: Identify, formulate, review research literature, and analyze complex engineering problems reaching substantiated conclusions using first principles of mathematics, natural sciences, and engineering sciences.'),
(@program_id, 'PLO3', 'Design/development of solutions: Design solutions for complex engineering problems and design system components or processes that meet the specified needs with appropriate consideration for the public health and safety, and the cultural, societal, and environmental considerations.'),
(@program_id, 'PLO4', 'Conduct investigations of complex problems: Use research-based knowledge and research methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions.'),
(@program_id, 'PLO5', 'Modern tool usage: Create, select, and apply appropriate techniques, resources, and modern engineering and IT tools including prediction and modeling to complex engineering activities with an understanding of the limitations.'),
(@program_id, 'PLO6', 'The engineer and society: Apply reasoning informed by the contextual knowledge to assess societal, health, safety, legal and cultural issues and the consequent responsibilities relevant to the professional engineering practice.'),
(@program_id, 'PLO7', 'Environment and sustainability: Understand the impact of the professional engineering solutions in societal and environmental contexts, and demonstrate the knowledge of, and need for sustainable development.'),
(@program_id, 'PLO8', 'Ethics: Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice.'),
(@program_id, 'PLO9', 'Individual and team work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.'),
(@program_id, 'PLO10', 'Communication: Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and write effective reports and design documentation, make effective presentations, and give and receive clear instructions.'),
(@program_id, 'PLO11', 'Project management and finance: Demonstrate knowledge and understanding of the engineering and management principles and apply these to ones own work, as a member and leader in a team, to manage projects and in multidisciplinary environments.'),
(@program_id, 'PLO12', 'Life-long learning: Recognize the need for, and have the preparation and ability to engage in independent and life-long learning in the broadest context of technological change.');

-- Get PLO IDs for mapping
SET @plo1_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO1');
SET @plo2_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO2');
SET @plo3_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO3');
SET @plo4_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO4');
SET @plo5_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO5');
SET @plo6_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO6');
SET @plo7_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO7');
SET @plo8_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO8');
SET @plo9_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO9');
SET @plo10_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO10');
SET @plo11_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO11');
SET @plo12_id = (SELECT plo_id FROM plos WHERE program_id = @program_id AND plo_code = 'PLO12');

-- ============================================
-- SEMESTER I COURSES
-- ============================================

-- Course: UPH013 - PHYSICS
INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'UPH013', 'PHYSICS', 4.5, 'I');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty1_id, @course_id, '2024-08-01');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2024-08-05', 'active'), 
(@student2_id, @course_id, '2024-08-05', 'active'),
(@student3_id, @course_id, '2024-08-05', 'active'),
(@student4_id, @course_id, '2024-08-05', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'Understand damped and simple harmonic motion, the role of reverberation in designing a hall and generation and detection of ultrasonic waves.', 'Understand'),
(@course_id, 'CLO2', 'use Maxwell\'s equations to describe propagation of EM waves in a medium.', 'Apply'),
(@course_id, 'CLO3', 'demonstrate interference, diffraction and polarization of light.', 'Apply'),
(@course_id, 'CLO4', 'explain the working principle of Lasers.', 'Understand'),
(@course_id, 'CLO5', 'use the concept of wave function to find probability of a particle confined in a box.', 'Apply'),
(@course_id, 'CLO6', 'perform an experiment, collect data, tabulate and report them and interpret the results with error analysis.', 'Apply');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1');
SET @clo_id_2 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2');
SET @clo_id_3 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3');
SET @clo_id_4 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo1_id, '1'),
(@clo_id_2, @plo2_id, '2'),
(@clo_id_3, @plo1_id, '2'),
(@clo_id_4, @plo1_id, '2');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Quiz 1', 'quiz', 20, 10.00, '2024-09-15'),
(@course_id, 'Midterm Exam', 'midterm', 50, 30.00, '2024-10-20'),
(@course_id, 'Lab Assignment 1', 'lab', 30, 15.00, '2024-10-01'),
(@course_id, 'Final Exam', 'final', 100, 45.00, '2024-12-15');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Lab Assignment 1');
SET @assessment_id_4 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, @clo_id_1, 50.00),
(@assessment_id_1, @clo_id_2, 50.00),
(@assessment_id_2, @clo_id_1, 25.00),
(@assessment_id_2, @clo_id_2, 25.00),
(@assessment_id_2, @clo_id_3, 25.00),
(@assessment_id_2, @clo_id_4, 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO6'), 100.00),
(@assessment_id_4, @clo_id_1, 20.00),
(@assessment_id_4, @clo_id_2, 20.00),
(@assessment_id_4, @clo_id_3, 20.00),
(@assessment_id_4, @clo_id_4, 20.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO5'), 20.00);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 17.00),
(@enrollment_id_1, @assessment_id_2, 26.00),
(@enrollment_id_1, @assessment_id_3, 43.00),
(@enrollment_id_1, @assessment_id_4, 82.00),
(@enrollment_id_2, @assessment_id_1, 15.00),
(@enrollment_id_2, @assessment_id_2, 24.00),
(@enrollment_id_2, @assessment_id_3, 39.00),
(@enrollment_id_2, @assessment_id_4, 75.00),
(@enrollment_id_3, @assessment_id_1, 18.00),
(@enrollment_id_3, @assessment_id_2, 28.00),
(@enrollment_id_3, @assessment_id_3, 46.00),
(@enrollment_id_3, @assessment_id_4, 87.00),
(@enrollment_id_4, @assessment_id_1, 14.00),
(@enrollment_id_4, @assessment_id_2, 22.00),
(@enrollment_id_4, @assessment_id_3, 36.00),
(@enrollment_id_4, @assessment_id_4, 70.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 84.00, 'attained'),
(@enrollment_id_1, @clo_id_2, 82.50, 'attained'),
(@enrollment_id_2, @clo_id_1, 76.00, 'attained'),
(@enrollment_id_2, @clo_id_2, 75.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 88.00, 'highly_attained'),
(@enrollment_id_3, @clo_id_2, 86.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 71.00, 'attained'),
(@enrollment_id_4, @clo_id_2, 69.00, 'partially_attained');

-- ============================================
-- Course: UES102 - MANUFACTURING PROCESSES
-- ============================================

INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'UES102', 'MANUFACTURING PROCESSES', 3.0, 'I');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty1_id, @course_id, '2024-08-01');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2024-08-05', 'active'), 
(@student2_id, @course_id, '2024-08-05', 'active'),
(@student3_id, @course_id, '2024-08-05', 'active'),
(@student4_id, @course_id, '2024-08-05', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'identify & analyse various machining processes/operations for manufacturing of industrial components.', 'Analyze'),
(@course_id, 'CLO2', 'apply the basic principle of bulk and sheet metal forming operations.', 'Apply'),
(@course_id, 'CLO3', 'apply the knowledge of metal casting for different requirements.', 'Apply'),
(@course_id, 'CLO4', 'identify and analyse the requirements to for achieving a sound welded joint apply the concept of smart manufacturing.', 'Analyze');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1');
SET @clo_id_2 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo1_id, '1'),
(@clo_id_2, @plo1_id, '2');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Quiz 1', 'quiz', 20, 15.00, '2024-09-18'),
(@course_id, 'Midterm Exam', 'midterm', 50, 35.00, '2024-10-23'),
(@course_id, 'Final Exam', 'final', 100, 50.00, '2024-12-17');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, @clo_id_1, 50.00),
(@assessment_id_1, @clo_id_2, 50.00),
(@assessment_id_2, @clo_id_1, 25.00),
(@assessment_id_2, @clo_id_2, 25.00),
(@assessment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3'), 25.00),
(@assessment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00),
(@assessment_id_3, @clo_id_1, 25.00),
(@assessment_id_3, @clo_id_2, 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3'), 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 17.00),
(@enrollment_id_1, @assessment_id_2, 42.00),
(@enrollment_id_1, @assessment_id_3, 80.00),
(@enrollment_id_2, @assessment_id_1, 15.00),
(@enrollment_id_2, @assessment_id_2, 38.00),
(@enrollment_id_2, @assessment_id_3, 73.00),
(@enrollment_id_3, @assessment_id_1, 18.00),
(@enrollment_id_3, @assessment_id_2, 45.00),
(@enrollment_id_3, @assessment_id_3, 85.00),
(@enrollment_id_4, @assessment_id_1, 14.00),
(@enrollment_id_4, @assessment_id_2, 35.00),
(@enrollment_id_4, @assessment_id_3, 68.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 81.00, 'attained'),
(@enrollment_id_2, @clo_id_1, 74.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 86.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 69.00, 'partially_attained');

-- ============================================
-- Course: UMA010 - MATHEMATICS-I
-- ============================================

INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'UMA010', 'MATHEMATICS-I', 3.5, 'I');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty2_id, @course_id, '2024-08-01');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2024-08-05', 'active'), 
(@student2_id, @course_id, '2024-08-05', 'active'),
(@student3_id, @course_id, '2024-08-05', 'active'),
(@student4_id, @course_id, '2024-08-05', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'determine the convergence/divergence of infinite series, approximation of functions using power and Taylor\'s series expansion and error estimation.', 'Apply'),
(@course_id, 'CLO2', 'examine functions of several variables, define and compute partial derivatives, directional derivatives, and their use in finding maxima and minima in some engineering problems.', 'Apply'),
(@course_id, 'CLO3', 'evaluate multiple integrals in Cartesian and Polar coordinates, and their applications to engineering problems.', 'Evaluate'),
(@course_id, 'CLO4', 'represent complex numbers in Cartesian and Polar forms and test the analyticity of complex functions by using Cauchy Riemann equations.', 'Apply');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1');
SET @clo_id_2 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo1_id, '3'),
(@clo_id_2, @plo1_id, '3');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Quiz 1', 'quiz', 20, 10.00, '2024-09-14'),
(@course_id, 'Quiz 2', 'quiz', 20, 10.00, '2024-10-12'),
(@course_id, 'Midterm Exam', 'midterm', 50, 30.00, '2024-10-24'),
(@course_id, 'Final Exam', 'final', 100, 50.00, '2024-12-19');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 2');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_4 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, @clo_id_1, 100.00),
(@assessment_id_2, @clo_id_2, 100.00),
(@assessment_id_3, @clo_id_1, 30.00),
(@assessment_id_3, @clo_id_2, 40.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3'), 30.00),
(@assessment_id_4, @clo_id_1, 25.00),
(@assessment_id_4, @clo_id_2, 25.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3'), 25.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 18.00),
(@enrollment_id_1, @assessment_id_2, 17.00),
(@enrollment_id_1, @assessment_id_3, 44.00),
(@enrollment_id_1, @assessment_id_4, 83.00),
(@enrollment_id_2, @assessment_id_1, 16.00),
(@enrollment_id_2, @assessment_id_2, 15.00),
(@enrollment_id_2, @assessment_id_3, 40.00),
(@enrollment_id_2, @assessment_id_4, 76.00),
(@enrollment_id_3, @assessment_id_1, 19.00),
(@enrollment_id_3, @assessment_id_2, 18.00),
(@enrollment_id_3, @assessment_id_3, 47.00),
(@enrollment_id_3, @assessment_id_4, 88.00),
(@enrollment_id_4, @assessment_id_1, 15.00),
(@enrollment_id_4, @assessment_id_2, 14.00),
(@enrollment_id_4, @assessment_id_3, 37.00),
(@enrollment_id_4, @assessment_id_4, 71.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 84.00, 'attained'),
(@enrollment_id_1, @clo_id_2, 82.00, 'attained'),
(@enrollment_id_2, @clo_id_1, 77.00, 'attained'),
(@enrollment_id_2, @clo_id_2, 75.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 89.00, 'highly_attained'),
(@enrollment_id_3, @clo_id_2, 87.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 72.00, 'attained'),
(@enrollment_id_4, @clo_id_2, 70.00, 'attained');

-- ============================================
-- SEMESTER II COURSES
-- ============================================

-- Course: UCB009 - CHEMISTRY
INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'UCB009', 'CHEMISTRY', 4.0, 'II');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty3_id, @course_id, '2025-01-10');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2025-01-15', 'active'), 
(@student2_id, @course_id, '2025-01-15', 'active'),
(@student3_id, @course_id, '2025-01-15', 'active'),
(@student4_id, @course_id, '2025-01-15', 'active'),
(@student5_id, @course_id, '2025-01-15', 'active'),
(@student6_id, @course_id, '2025-01-15', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'recognize principles and applications of atomic and molecular spectroscopy.', 'Understand'),
(@course_id, 'CLO2', 'explain the concepts of conductometric titrations, modern batteries and corrosion.', 'Understand'),
(@course_id, 'CLO3', 'apply and execute water quality parameter and treatment methods.', 'Apply'),
(@course_id, 'CLO4', 'discuss the concept of alternative fuels, application of polymers and SMILES.', 'Understand'),
(@course_id, 'CLO5', 'execute laboratory techniques like pH metry, potentiometry, spectrophotometry, conductometry and volumetry.', 'Apply');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3');
SET @clo_id_2 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo7_id, '2'),
(@clo_id_2, @plo7_id, '2');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Quiz 1', 'quiz', 20, 10.00, '2025-02-15'),
(@course_id, 'Lab Assignment 1', 'lab', 30, 15.00, '2025-03-01'),
(@course_id, 'Midterm Exam', 'midterm', 50, 30.00, '2025-03-20'),
(@course_id, 'Lab Assignment 2', 'lab', 30, 15.00, '2025-04-10'),
(@course_id, 'Final Exam', 'final', 100, 30.00, '2025-05-15');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Lab Assignment 1');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_4 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Lab Assignment 2');
SET @assessment_id_5 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 50.00),
(@assessment_id_1, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2'), 50.00),
(@assessment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO5'), 100.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2'), 25.00),
(@assessment_id_3, @clo_id_1, 25.00),
(@assessment_id_3, @clo_id_2, 25.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO5'), 100.00),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 20.00),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2'), 20.00),
(@assessment_id_5, @clo_id_1, 20.00),
(@assessment_id_5, @clo_id_2, 20.00),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO5'), 20.00);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);
SET @enrollment_id_5 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student5_id AND course_id = @course_id);
SET @enrollment_id_6 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student6_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 17.00),
(@enrollment_id_1, @assessment_id_2, 26.00),
(@enrollment_id_1, @assessment_id_3, 43.00),
(@enrollment_id_1, @assessment_id_4, 27.00),
(@enrollment_id_1, @assessment_id_5, 82.00),
(@enrollment_id_2, @assessment_id_1, 16.00),
(@enrollment_id_2, @assessment_id_2, 24.00),
(@enrollment_id_2, @assessment_id_3, 39.00),
(@enrollment_id_2, @assessment_id_4, 25.00),
(@enrollment_id_2, @assessment_id_5, 76.00),
(@enrollment_id_3, @assessment_id_1, 18.00),
(@enrollment_id_3, @assessment_id_2, 28.00),
(@enrollment_id_3, @assessment_id_3, 46.00),
(@enrollment_id_3, @assessment_id_4, 28.00),
(@enrollment_id_3, @assessment_id_5, 87.00),
(@enrollment_id_4, @assessment_id_1, 15.00),
(@enrollment_id_4, @assessment_id_2, 23.00),
(@enrollment_id_4, @assessment_id_3, 37.00),
(@enrollment_id_4, @assessment_id_4, 24.00),
(@enrollment_id_4, @assessment_id_5, 72.00),
(@enrollment_id_5, @assessment_id_1, 17.00),
(@enrollment_id_5, @assessment_id_2, 25.00),
(@enrollment_id_5, @assessment_id_3, 41.00),
(@enrollment_id_5, @assessment_id_4, 26.00),
(@enrollment_id_5, @assessment_id_5, 79.00),
(@enrollment_id_6, @assessment_id_1, 14.00),
(@enrollment_id_6, @assessment_id_2, 22.00),
(@enrollment_id_6, @assessment_id_3, 35.00),
(@enrollment_id_6, @assessment_id_4, 23.00),
(@enrollment_id_6, @assessment_id_5, 68.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 83.00, 'attained'),
(@enrollment_id_2, @clo_id_1, 76.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 87.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 71.00, 'attained'),
(@enrollment_id_5, @clo_id_1, 79.00, 'attained'),
(@enrollment_id_6, @clo_id_1, 67.00, 'partially_attained');

-- ============================================
-- Course: UES103 - PROGRAMMING FOR PROBLEM SOLVING
-- ============================================

INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'UES103', 'PROGRAMMING FOR PROBLEM SOLVING', 4.0, 'II');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty1_id, @course_id, '2025-01-10');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2025-01-15', 'active'), 
(@student2_id, @course_id, '2025-01-15', 'active'),
(@student3_id, @course_id, '2025-01-15', 'active'),
(@student4_id, @course_id, '2025-01-15', 'active'),
(@student5_id, @course_id, '2025-01-15', 'active'),
(@student6_id, @course_id, '2025-01-15', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'Comprehend and analyze the concepts of number system, memory, compilation and debugging of the programs in C language.', 'Analyze'),
(@course_id, 'CLO2', 'Analyze the control & iterative statements to solve the problems with C language source codes.', 'Analyze'),
(@course_id, 'CLO3', 'Design and create programs for problem solving involving arrays, strings and pointers.', 'Create'),
(@course_id, 'CLO4', 'Evaluate and analyze the programming concepts based on user define data types and file handling using C language.', 'Evaluate');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3');
SET @clo_id_2 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo3_id, '3'),
(@clo_id_2, @plo2_id, '2');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Assignment 1', 'assignment', 25, 10.00, '2025-02-10'),
(@course_id, 'Assignment 2', 'assignment', 25, 10.00, '2025-03-05'),
(@course_id, 'Midterm Exam', 'midterm', 50, 30.00, '2025-03-22'),
(@course_id, 'Project', 'project', 40, 20.00, '2025-04-20'),
(@course_id, 'Final Exam', 'final', 100, 30.00, '2025-05-16');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Assignment 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Assignment 2');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_4 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Project');
SET @assessment_id_5 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 50.00),
(@assessment_id_1, @clo_id_2, 50.00),
(@assessment_id_2, @clo_id_2, 50.00),
(@assessment_id_2, @clo_id_1, 50.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 25.00),
(@assessment_id_3, @clo_id_2, 25.00),
(@assessment_id_3, @clo_id_1, 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00),
(@assessment_id_4, @clo_id_1, 60.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 40.00),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 25.00),
(@assessment_id_5, @clo_id_2, 25.00),
(@assessment_id_5, @clo_id_1, 25.00),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);
SET @enrollment_id_5 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student5_id AND course_id = @course_id);
SET @enrollment_id_6 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student6_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 22.00),
(@enrollment_id_1, @assessment_id_2, 23.00),
(@enrollment_id_1, @assessment_id_3, 44.00),
(@enrollment_id_1, @assessment_id_4, 36.00),
(@enrollment_id_1, @assessment_id_5, 84.00),
(@enrollment_id_2, @assessment_id_1, 20.00),
(@enrollment_id_2, @assessment_id_2, 21.00),
(@enrollment_id_2, @assessment_id_3, 40.00),
(@enrollment_id_2, @assessment_id_4, 33.00),
(@enrollment_id_2, @assessment_id_5, 78.00),
(@enrollment_id_3, @assessment_id_1, 23.00),
(@enrollment_id_3, @assessment_id_2, 24.00),
(@enrollment_id_3, @assessment_id_3, 47.00),
(@enrollment_id_3, @assessment_id_4, 38.00),
(@enrollment_id_3, @assessment_id_5, 89.00),
(@enrollment_id_4, @assessment_id_1, 19.00),
(@enrollment_id_4, @assessment_id_2, 20.00),
(@enrollment_id_4, @assessment_id_3, 37.00),
(@enrollment_id_4, @assessment_id_4, 30.00),
(@enrollment_id_4, @assessment_id_5, 73.00),
(@enrollment_id_5, @assessment_id_1, 21.00),
(@enrollment_id_5, @assessment_id_2, 22.00),
(@enrollment_id_5, @assessment_id_3, 42.00),
(@enrollment_id_5, @assessment_id_4, 35.00),
(@enrollment_id_5, @assessment_id_5, 81.00),
(@enrollment_id_6, @assessment_id_1, 18.00),
(@enrollment_id_6, @assessment_id_2, 19.00),
(@enrollment_id_6, @assessment_id_3, 35.00),
(@enrollment_id_6, @assessment_id_4, 28.00),
(@enrollment_id_6, @assessment_id_5, 70.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 85.00, 'highly_attained'),
(@enrollment_id_2, @clo_id_1, 78.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 89.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 72.00, 'attained'),
(@enrollment_id_5, @clo_id_1, 81.00, 'attained'),
(@enrollment_id_6, @clo_id_1, 69.00, 'partially_attained');

-- ============================================
-- Course: UES013 - ELECTRICAL & ELECTRONICS ENGINEERING
-- ============================================

INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'UES013', 'ELECTRICAL & ELECTRONICS ENGINEERING', 4.5, 'II');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty2_id, @course_id, '2025-01-10');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2025-01-15', 'active'), 
(@student2_id, @course_id, '2025-01-15', 'active'),
(@student3_id, @course_id, '2025-01-15', 'active'),
(@student4_id, @course_id, '2025-01-15', 'active'),
(@student5_id, @course_id, '2025-01-15', 'active'),
(@student6_id, @course_id, '2025-01-15', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'Apply various networks laws and theorems to solve de circuits.', 'Apply'),
(@course_id, 'CLO2', 'Compute different ac quantities with phasor representation.', 'Apply'),
(@course_id, 'CLO3', 'Comprehend the operation in magnetic circuits, single phase transformer and rotating machines.', 'Understand'),
(@course_id, 'CLO4', 'Recognize and apply the number systems and Boolean algebra.', 'Apply'),
(@course_id, 'CLO5', 'Reduce and simplify Boolean expressions and implement them with logic gates.', 'Apply'),
(@course_id, 'CLO6', 'Discuss and explain the working of diode, transistor and operational amplifier, their configurations and applications.', 'Understand');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1');
SET @clo_id_2 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO5');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo1_id, '2'),
(@clo_id_2, @plo2_id, '2');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Quiz 1', 'quiz', 20, 10.00, '2025-02-18'),
(@course_id, 'Lab Assignment 1', 'lab', 30, 15.00, '2025-03-08'),
(@course_id, 'Midterm Exam', 'midterm', 50, 30.00, '2025-03-25'),
(@course_id, 'Lab Assignment 2', 'lab', 30, 15.00, '2025-04-15'),
(@course_id, 'Final Exam', 'final', 100, 30.00, '2025-05-18');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Lab Assignment 1');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_4 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Lab Assignment 2');
SET @assessment_id_5 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, @clo_id_1, 50.00),
(@assessment_id_1, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2'), 50.00),
(@assessment_id_2, @clo_id_1, 100.00),
(@assessment_id_3, @clo_id_1, 20.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2'), 20.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3'), 20.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 20.00),
(@assessment_id_3, @clo_id_2, 20.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO6'), 100.00),
(@assessment_id_5, @clo_id_1, 16.67),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2'), 16.67),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3'), 16.67),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 16.67),
(@assessment_id_5, @clo_id_2, 16.66),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO6'), 16.66);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);
SET @enrollment_id_5 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student5_id AND course_id = @course_id);
SET @enrollment_id_6 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student6_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 18.00),
(@enrollment_id_1, @assessment_id_2, 27.00),
(@enrollment_id_1, @assessment_id_3, 44.00),
(@enrollment_id_1, @assessment_id_4, 28.00),
(@enrollment_id_1, @assessment_id_5, 85.00),
(@enrollment_id_2, @assessment_id_1, 16.00),
(@enrollment_id_2, @assessment_id_2, 24.00),
(@enrollment_id_2, @assessment_id_3, 40.00),
(@enrollment_id_2, @assessment_id_4, 25.00),
(@enrollment_id_2, @assessment_id_5, 77.00),
(@enrollment_id_3, @assessment_id_1, 19.00),
(@enrollment_id_3, @assessment_id_2, 28.00),
(@enrollment_id_3, @assessment_id_3, 47.00),
(@enrollment_id_3, @assessment_id_4, 29.00),
(@enrollment_id_3, @assessment_id_5, 90.00),
(@enrollment_id_4, @assessment_id_1, 15.00),
(@enrollment_id_4, @assessment_id_2, 23.00),
(@enrollment_id_4, @assessment_id_3, 37.00),
(@enrollment_id_4, @assessment_id_4, 24.00),
(@enrollment_id_4, @assessment_id_5, 72.00),
(@enrollment_id_5, @assessment_id_1, 17.00),
(@enrollment_id_5, @assessment_id_2, 26.00),
(@enrollment_id_5, @assessment_id_3, 42.00),
(@enrollment_id_5, @assessment_id_4, 27.00),
(@enrollment_id_5, @assessment_id_5, 82.00),
(@enrollment_id_6, @assessment_id_1, 14.00),
(@enrollment_id_6, @assessment_id_2, 22.00),
(@enrollment_id_6, @assessment_id_3, 35.00),
(@enrollment_id_6, @assessment_id_4, 23.00),
(@enrollment_id_6, @assessment_id_5, 68.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 84.00, 'attained'),
(@enrollment_id_2, @clo_id_1, 76.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 89.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 71.00, 'attained'),
(@enrollment_id_5, @clo_id_1, 81.00, 'attained'),
(@enrollment_id_6, @clo_id_1, 67.00, 'partially_attained');

-- ============================================
-- Course: UEN008 - ENERGY AND ENVIRONMENT
-- ============================================

INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'UEN008', 'ENERGY AND ENVIRONMENT', 2.0, 'II');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty3_id, @course_id, '2025-01-10');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2025-01-15', 'active'), 
(@student2_id, @course_id, '2025-01-15', 'active'),
(@student3_id, @course_id, '2025-01-15', 'active'),
(@student4_id, @course_id, '2025-01-15', 'active'),
(@student5_id, @course_id, '2025-01-15', 'active'),
(@student6_id, @course_id, '2025-01-15', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'comprehend the interdisciplinary context of environmental issues with reference to sustainability.', 'Understand'),
(@course_id, 'CLO2', 'assess the impact of anthropogenic activities on the various elements of environment and apply suitable techniques to mitigate their impact.', 'Apply'),
(@course_id, 'CLO3', 'demonstrate the application of technology in real time assessment and control of pollutants.', 'Apply'),
(@course_id, 'CLO4', 'correlate environmental concerns with the conventional energy sources associated and assess the uses and limitations of non-conventional energy technologies.', 'Analyze');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo7_id, '3');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Quiz 1', 'quiz', 20, 20.00, '2025-02-20'),
(@course_id, 'Midterm Exam', 'midterm', 50, 40.00, '2025-03-28'),
(@course_id, 'Final Exam', 'final', 100, 40.00, '2025-05-20');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 50.00),
(@assessment_id_1, @clo_id_1, 50.00),
(@assessment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 25.00),
(@assessment_id_2, @clo_id_1, 25.00),
(@assessment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3'), 25.00),
(@assessment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 25.00),
(@assessment_id_3, @clo_id_1, 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3'), 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);
SET @enrollment_id_5 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student5_id AND course_id = @course_id);
SET @enrollment_id_6 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student6_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 17.00),
(@enrollment_id_1, @assessment_id_2, 43.00),
(@enrollment_id_1, @assessment_id_3, 83.00),
(@enrollment_id_2, @assessment_id_1, 15.00),
(@enrollment_id_2, @assessment_id_2, 39.00),
(@enrollment_id_2, @assessment_id_3, 76.00),
(@enrollment_id_3, @assessment_id_1, 18.00),
(@enrollment_id_3, @assessment_id_2, 46.00),
(@enrollment_id_3, @assessment_id_3, 88.00),
(@enrollment_id_4, @assessment_id_1, 14.00),
(@enrollment_id_4, @assessment_id_2, 36.00),
(@enrollment_id_4, @assessment_id_3, 71.00),
(@enrollment_id_5, @assessment_id_1, 16.00),
(@enrollment_id_5, @assessment_id_2, 41.00),
(@enrollment_id_5, @assessment_id_3, 79.00),
(@enrollment_id_6, @assessment_id_1, 13.00),
(@enrollment_id_6, @assessment_id_2, 34.00),
(@enrollment_id_6, @assessment_id_3, 67.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 83.00, 'attained'),
(@enrollment_id_2, @clo_id_1, 75.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 87.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 70.00, 'attained'),
(@enrollment_id_5, @clo_id_1, 78.00, 'attained'),
(@enrollment_id_6, @clo_id_1, 66.00, 'partially_attained');

-- ============================================
-- Course: UMA004 - MATHEMATICS-II
-- ============================================

INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'UMA004', 'MATHEMATICS-II', 3.5, 'II');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty1_id, @course_id, '2025-01-10');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2025-01-15', 'active'), 
(@student2_id, @course_id, '2025-01-15', 'active'),
(@student3_id, @course_id, '2025-01-15', 'active'),
(@student4_id, @course_id, '2025-01-15', 'active'),
(@student5_id, @course_id, '2025-01-15', 'active'),
(@student6_id, @course_id, '2025-01-15', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'solve the differential equations of first and 2nd order and basic application problems described by these equations.', 'Apply'),
(@course_id, 'CLO2', 'find the Laplace transformations and inverse Laplace transformations for various functions. Using the concept of Laplace transform students will be able to solve the initial value and boundary value problems.', 'Apply'),
(@course_id, 'CLO3', 'find the Fourier series expansions of periodic functions and subsequently will be able to solve heat and wave equations.', 'Apply'),
(@course_id, 'CLO4', 'solve systems of linear equations by using elementary row operations.', 'Apply'),
(@course_id, 'CLO5', 'identify the vector spaces/subspaces and to compute their bases/orthonormal bases. Further, students will be able to express linear transformation in terms of matrix and find the eigenvalues and eigenvectors.', 'Apply');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1');
SET @clo_id_2 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo1_id, '3'),
(@clo_id_2, @plo1_id, '3');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Quiz 1', 'quiz', 20, 10.00, '2025-02-16'),
(@course_id, 'Quiz 2', 'quiz', 20, 10.00, '2025-03-14'),
(@course_id, 'Midterm Exam', 'midterm', 50, 30.00, '2025-03-26'),
(@course_id, 'Final Exam', 'final', 100, 50.00, '2025-05-19');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 2');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_4 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, @clo_id_1, 100.00),
(@assessment_id_2, @clo_id_2, 100.00),
(@assessment_id_3, @clo_id_1, 25.00),
(@assessment_id_3, @clo_id_2, 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3'), 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00),
(@assessment_id_4, @clo_id_1, 20.00),
(@assessment_id_4, @clo_id_2, 20.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3'), 20.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 20.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO5'), 20.00);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);
SET @enrollment_id_5 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student5_id AND course_id = @course_id);
SET @enrollment_id_6 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student6_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 18.00),
(@enrollment_id_1, @assessment_id_2, 17.00),
(@enrollment_id_1, @assessment_id_3, 45.00),
(@enrollment_id_1, @assessment_id_4, 86.00),
(@enrollment_id_2, @assessment_id_1, 16.00),
(@enrollment_id_2, @assessment_id_2, 15.00),
(@enrollment_id_2, @assessment_id_3, 41.00),
(@enrollment_id_2, @assessment_id_4, 78.00),
(@enrollment_id_3, @assessment_id_1, 19.00),
(@enrollment_id_3, @assessment_id_2, 18.00),
(@enrollment_id_3, @assessment_id_3, 48.00),
(@enrollment_id_3, @assessment_id_4, 91.00),
(@enrollment_id_4, @assessment_id_1, 15.00),
(@enrollment_id_4, @assessment_id_2, 14.00),
(@enrollment_id_4, @assessment_id_3, 38.00),
(@enrollment_id_4, @assessment_id_4, 73.00),
(@enrollment_id_5, @assessment_id_1, 17.00),
(@enrollment_id_5, @assessment_id_2, 16.00),
(@enrollment_id_5, @assessment_id_3, 43.00),
(@enrollment_id_5, @assessment_id_4, 82.00),
(@enrollment_id_6, @assessment_id_1, 14.00),
(@enrollment_id_6, @assessment_id_2, 13.00),
(@enrollment_id_6, @assessment_id_3, 36.00),
(@enrollment_id_6, @assessment_id_4, 69.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 85.00, 'highly_attained'),
(@enrollment_id_2, @clo_id_1, 77.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 90.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 72.00, 'attained'),
(@enrollment_id_5, @clo_id_1, 81.00, 'attained'),
(@enrollment_id_6, @clo_id_1, 68.00, 'partially_attained');

-- ============================================
-- SEMESTER III COURSES
-- ============================================

-- Course: UMA301 - DISCRETE MATHEMATICAL STRUCTURES
INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'UMA301', 'DISCRETE MATHEMATICAL STRUCTURES', 3.5, 'III');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty2_id, @course_id, '2024-08-01');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2024-08-05', 'active'), 
(@student2_id, @course_id, '2024-08-05', 'active'),
(@student3_id, @course_id, '2024-08-05', 'active'),
(@student4_id, @course_id, '2024-08-05', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'Perform operations on various discrete structures such as set, function, and relation.', 'Apply'),
(@course_id, 'CLO2', 'Apply basic concepts of asymptotic notation in the analysis of the algorithm.', 'Apply'),
(@course_id, 'CLO3', 'Illustrate the basic properties and algorithms of graphs and apply them in modelling and solving real-world problems.', 'Apply'),
(@course_id, 'CLO4', 'Comprehend formal logical arguments and translate statements from a natural language into their symbolic structures in logic.', 'Understand'),
(@course_id, 'CLO5', 'Identify and prove various properties of rings, fields, and groups.', 'Apply'),
(@course_id, 'CLO6', 'Illustrate and apply the division algorithm, mod function, and Congruence.', 'Apply');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2');
SET @clo_id_2 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo2_id, '2'),
(@clo_id_2, @plo1_id, '2');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Quiz 1', 'quiz', 20, 10.00, '2024-09-15'),
(@course_id, 'Assignment 1', 'assignment', 25, 15.00, '2024-10-05'),
(@course_id, 'Midterm Exam', 'midterm', 50, 30.00, '2024-10-20'),
(@course_id, 'Final Exam', 'final', 100, 45.00, '2024-12-15');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Assignment 1');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_4 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 50.00),
(@assessment_id_1, @clo_id_1, 50.00),
(@assessment_id_2, @clo_id_2, 60.00),
(@assessment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 40.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 25.00),
(@assessment_id_3, @clo_id_1, 25.00),
(@assessment_id_3, @clo_id_2, 25.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 20.00),
(@assessment_id_4, @clo_id_1, 20.00),
(@assessment_id_4, @clo_id_2, 20.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 15.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO5'), 15.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO6'), 10.00);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 18.00),
(@enrollment_id_1, @assessment_id_2, 22.00),
(@enrollment_id_1, @assessment_id_3, 44.00),
(@enrollment_id_1, @assessment_id_4, 84.00),
(@enrollment_id_2, @assessment_id_1, 16.00),
(@enrollment_id_2, @assessment_id_2, 20.00),
(@enrollment_id_2, @assessment_id_3, 40.00),
(@enrollment_id_2, @assessment_id_4, 77.00),
(@enrollment_id_3, @assessment_id_1, 19.00),
(@enrollment_id_3, @assessment_id_2, 23.00),
(@enrollment_id_3, @assessment_id_3, 47.00),
(@enrollment_id_3, @assessment_id_4, 88.00),
(@enrollment_id_4, @assessment_id_1, 15.00),
(@enrollment_id_4, @assessment_id_2, 19.00),
(@enrollment_id_4, @assessment_id_3, 37.00),
(@enrollment_id_4, @assessment_id_4, 72.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 83.00, 'attained'),
(@enrollment_id_2, @clo_id_1, 76.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 87.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 71.00, 'attained');

-- ============================================
-- Course: ULC301 - DATA STRUCTURES
-- ============================================

INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'ULC301', 'DATA STRUCTURES', 4.0, 'III');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty1_id, @course_id, '2024-08-01');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2024-08-05', 'active'), 
(@student2_id, @course_id, '2024-08-05', 'active'),
(@student3_id, @course_id, '2024-08-05', 'active'),
(@student4_id, @course_id, '2024-08-05', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'Understand the fundamental data structures, their implementation and some of their standard applications.', 'Understand'),
(@course_id, 'CLO2', 'Select and implement appropriate searching and sorting techniques for solving a problem based on their characteristics.', 'Apply'),
(@course_id, 'CLO3', 'Apply tree and graph data structures for specific applications.', 'Apply'),
(@course_id, 'CLO4', 'Design and analyse algorithms using appropriate data structures for real-world problems.', 'Create');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4');
SET @clo_id_2 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo3_id, '3'),
(@clo_id_2, @plo2_id, '2');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Assignment 1', 'assignment', 30, 15.00, '2024-09-10'),
(@course_id, 'Quiz 1', 'quiz', 20, 10.00, '2024-09-25'),
(@course_id, 'Midterm Exam', 'midterm', 50, 30.00, '2024-10-22'),
(@course_id, 'Project', 'project', 40, 20.00, '2024-11-20'),
(@course_id, 'Final Exam', 'final', 100, 25.00, '2024-12-16');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Assignment 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 1');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_4 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Project');
SET @assessment_id_5 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 50.00),
(@assessment_id_1, @clo_id_2, 50.00),
(@assessment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 100.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 33.33),
(@assessment_id_3, @clo_id_1, 33.33),
(@assessment_id_3, @clo_id_2, 33.34),
(@assessment_id_4, @clo_id_1, 60.00),
(@assessment_id_4, @clo_id_2, 40.00),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 25.00),
(@assessment_id_5, @clo_id_1, 25.00),
(@assessment_id_5, @clo_id_2, 25.00),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 27.00),
(@enrollment_id_1, @assessment_id_2, 18.00),
(@enrollment_id_1, @assessment_id_3, 45.00),
(@enrollment_id_1, @assessment_id_4, 44.00),
(@enrollment_id_1, @assessment_id_5, 86.00),
(@enrollment_id_2, @assessment_id_1, 25.00),
(@enrollment_id_2, @assessment_id_2, 16.00),
(@enrollment_id_2, @assessment_id_3, 41.00),
(@enrollment_id_2, @assessment_id_4, 40.00),
(@enrollment_id_2, @assessment_id_5, 79.00),
(@enrollment_id_3, @assessment_id_1, 28.00),
(@enrollment_id_3, @assessment_id_2, 19.00),
(@enrollment_id_3, @assessment_id_3, 48.00),
(@enrollment_id_3, @assessment_id_4, 46.00),
(@enrollment_id_3, @assessment_id_5, 91.00),
(@enrollment_id_4, @assessment_id_1, 24.00),
(@enrollment_id_4, @assessment_id_2, 15.00),
(@enrollment_id_4, @assessment_id_3, 38.00),
(@enrollment_id_4, @assessment_id_4, 37.00),
(@enrollment_id_4, @assessment_id_5, 74.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 86.00, 'highly_attained'),
(@enrollment_id_1, @clo_id_2, 84.00, 'attained'),
(@enrollment_id_2, @clo_id_1, 79.00, 'attained'),
(@enrollment_id_2, @clo_id_2, 77.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 90.00, 'highly_attained'),
(@enrollment_id_3, @clo_id_2, 88.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 74.00, 'attained'),
(@enrollment_id_4, @clo_id_2, 72.00, 'attained');

-- ============================================
-- SEMESTER VI COURSES
-- ============================================

-- Course: ULC601 - MACHINE LEARNING TECHNIQUES
INSERT INTO courses (program_id, course_code, course_name, credit_hours, semester) VALUES
(@program_id, 'ULC601', 'MACHINE LEARNING TECHNIQUES', 4.0, 'VI');
SET @course_id = LAST_INSERT_ID();

-- Faculty Assignment
INSERT INTO faculty_courses (faculty_id, course_id, assigned_date) VALUES
(@faculty2_id, @course_id, '2025-01-10');

-- Student Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES 
(@student1_id, @course_id, '2025-01-15', 'active'), 
(@student2_id, @course_id, '2025-01-15', 'active'),
(@student3_id, @course_id, '2025-01-15', 'active'),
(@student4_id, @course_id, '2025-01-15', 'active');

-- CLOs
INSERT INTO clos (course_id, clo_code, clo_description, bloom_level) VALUES
(@course_id, 'CLO1', 'Understand the basic concepts and principles of machine learning.', 'Understand'),
(@course_id, 'CLO2', 'Apply supervised learning algorithms to classification and regression problems.', 'Apply'),
(@course_id, 'CLO3', 'Apply unsupervised learning algorithms for clustering and dimensionality reduction.', 'Apply'),
(@course_id, 'CLO4', 'Evaluate the performance of machine learning models.', 'Evaluate');

-- CLO-PLO Mappings
SET @clo_id_1 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2');
SET @clo_id_2 = (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO3');

INSERT INTO clo_plo_mapping (clo_id, plo_id, correlation_strength) VALUES
(@clo_id_1, @plo4_id, '3'),
(@clo_id_2, @plo4_id, '3');

-- Assessment Tools
INSERT INTO assessment_tools (course_id, assessment_name, assessment_type, max_marks, weightage, assessment_date) VALUES
(@course_id, 'Assignment 1', 'assignment', 30, 15.00, '2025-02-14'),
(@course_id, 'Quiz 1', 'quiz', 20, 10.00, '2025-03-02'),
(@course_id, 'Midterm Exam', 'midterm', 50, 30.00, '2025-03-27'),
(@course_id, 'Project', 'project', 50, 25.00, '2025-04-25'),
(@course_id, 'Final Exam', 'final', 100, 20.00, '2025-05-21');

-- Assessment-CLO Mappings
SET @assessment_id_1 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Assignment 1');
SET @assessment_id_2 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Quiz 1');
SET @assessment_id_3 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Midterm Exam');
SET @assessment_id_4 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Project');
SET @assessment_id_5 = (SELECT assessment_id FROM assessment_tools WHERE course_id = @course_id AND assessment_name = 'Final Exam');

INSERT INTO assessment_clo_mapping (assessment_id, clo_id, weightage_percentage) VALUES
(@assessment_id_1, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 40.00),
(@assessment_id_1, @clo_id_1, 60.00),
(@assessment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 50.00),
(@assessment_id_2, @clo_id_1, 50.00),
(@assessment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 25.00),
(@assessment_id_3, @clo_id_1, 35.00),
(@assessment_id_3, @clo_id_2, 40.00),
(@assessment_id_4, @clo_id_1, 30.00),
(@assessment_id_4, @clo_id_2, 40.00),
(@assessment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 30.00),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO1'), 25.00),
(@assessment_id_5, @clo_id_1, 25.00),
(@assessment_id_5, @clo_id_2, 25.00),
(@assessment_id_5, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 25.00);

-- Student Scores
SET @enrollment_id_1 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student1_id AND course_id = @course_id);
SET @enrollment_id_2 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student2_id AND course_id = @course_id);
SET @enrollment_id_3 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student3_id AND course_id = @course_id);
SET @enrollment_id_4 = (SELECT enrollment_id FROM enrollments WHERE student_id = @student4_id AND course_id = @course_id);

INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 27.00),
(@enrollment_id_1, @assessment_id_2, 18.00),
(@enrollment_id_1, @assessment_id_3, 44.00),
(@enrollment_id_1, @assessment_id_4, 45.00),
(@enrollment_id_1, @assessment_id_5, 85.00),
(@enrollment_id_2, @assessment_id_1, 25.00),
(@enrollment_id_2, @assessment_id_2, 16.00),
(@enrollment_id_2, @assessment_id_3, 40.00),
(@enrollment_id_2, @assessment_id_4, 41.00),
(@enrollment_id_2, @assessment_id_5, 78.00),
(@enrollment_id_3, @assessment_id_1, 28.00),
(@enrollment_id_3, @assessment_id_2, 19.00),
(@enrollment_id_3, @assessment_id_3, 47.00),
(@enrollment_id_3, @assessment_id_4, 47.00),
(@enrollment_id_3, @assessment_id_5, 90.00),
(@enrollment_id_4, @assessment_id_1, 24.00),
(@enrollment_id_4, @assessment_id_2, 15.00),
(@enrollment_id_4, @assessment_id_3, 37.00),
(@enrollment_id_4, @assessment_id_4, 38.00),
(@enrollment_id_4, @assessment_id_5, 73.00);

-- CLO Attainment
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, @clo_id_1, 85.00, 'highly_attained'),
(@enrollment_id_1, @clo_id_2, 83.00, 'attained'),
(@enrollment_id_2, @clo_id_1, 78.00, 'attained'),
(@enrollment_id_2, @clo_id_2, 76.00, 'attained'),
(@enrollment_id_3, @clo_id_1, 89.00, 'highly_attained'),
(@enrollment_id_3, @clo_id_2, 87.00, 'highly_attained'),
(@enrollment_id_4, @clo_id_1, 73.00, 'attained'),
(@enrollment_id_4, @clo_id_2, 71.00, 'attained');

-- ============================================
-- COMMIT TRANSACTION
-- ============================================
-- [START OF REPLACEMENT BLOCK]
-- Replace the incomplete line  with all of this:

-- Student Scores (Completed for UHU003)
INSERT INTO student_scores (enrollment_id, assessment_id, marks_obtained) VALUES
(@enrollment_id_1, @assessment_id_1, 18.00),
(@enrollment_id_1, @assessment_id_2, 27.00),
(@enrollment_id_1, @assessment_id_3, 44.00),
(@enrollment_id_1, @assessment_id_4, 85.00),
(@enrollment_id_2, @assessment_id_1, 16.00),
(@enrollment_id_2, @assessment_id_2, 25.00),
(@enrollment_id_2, @assessment_id_3, 40.00),
(@enrollment_id_2, @assessment_id_4, 78.00),
(@enrollment_id_3, @assessment_id_1, 19.00),
(@enrollment_id_3, @assessment_id_2, 28.00),
(@enrollment_id_3, @assessment_id_3, 47.00),
(@enrollment_id_3, @assessment_id_4, 90.00),
(@enrollment_id_4, @assessment_id_1, 15.00),
(@enrollment_id_4, @assessment_id_2, 24.00),
(@enrollment_id_4, @assessment_id_3, 37.00),
(@enrollment_id_4, @assessment_id_4, 73.00);

-- CLO Attainment (New for UHU003)
INSERT INTO clo_attainment (enrollment_id, clo_id, attainment_score, attainment_level) VALUES
(@enrollment_id_1, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2'), 86.00, 'highly_attained'),
(@enrollment_id_1, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 85.00, 'highly_attained'),
(@enrollment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2'), 78.00, 'attained'),
(@enrollment_id_2, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 77.00, 'attained'),
(@enrollment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2'), 90.00, 'highly_attained'),
(@enrollment_id_3, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 89.00, 'highly_attained'),
(@enrollment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO2'), 72.00, 'attained'),
(@enrollment_id_4, (SELECT clo_id FROM clos WHERE course_id = @course_id AND clo_code = 'CLO4'), 71.00, 'attained');

-- ============================================
-- COMMIT TRANSACTION
-- ============================================

COMMIT;

-- ============================================
-- VERIFICATION QUERIES (Moved from middle to end)
-- ============================================

SELECT 'Database seeding completed successfully!' AS message;

-- Display summary statistics
SELECT 'Summary Statistics:' AS info;
SELECT COUNT(*) AS total_users FROM users;
SELECT COUNT(*) AS total_programs FROM programs;
SELECT COUNT(*) AS total_plos FROM plos;
SELECT COUNT(*) AS total_courses FROM courses;
SELECT COUNT(*) AS total_clos FROM clos;
SELECT COUNT(*) AS total_enrollments FROM enrollments;
SELECT COUNT(*) AS total_faculty_assignments FROM faculty_courses;
SELECT COUNT(*) AS total_assessments FROM assessment_tools;
SELECT COUNT(*) AS total_assessment_clo_mappings FROM assessment_clo_mapping;
SELECT COUNT(*) AS total_clo_plo_mappings FROM clo_plo_mapping;
SELECT COUNT(*) AS total_student_scores FROM student_scores;
SELECT COUNT(*) AS total_clo_attainments FROM clo_attainment;

-- Verify no table is empty
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM users) = 0 THEN 'WARNING: users table is empty'
        WHEN (SELECT COUNT(*) FROM programs) = 0 THEN 'WARNING: programs table is empty'
        WHEN (SELECT COUNT(*) FROM plos) = 0 THEN 'WARNING: plos table is empty'
        WHEN (SELECT COUNT(*) FROM courses) = 0 THEN 'WARNING: courses table is empty'
        WHEN (SELECT COUNT(*) FROM clos) = 0 THEN 'WARNING: clos table is empty'
        WHEN (SELECT COUNT(*) FROM enrollments) = 0 THEN 'WARNING: enrollments table is empty'
        WHEN (SELECT COUNT(*) FROM faculty_courses) = 0 THEN 'WARNING: faculty_courses table is empty'
        WHEN (SELECT COUNT(*) FROM assessment_tools) = 0 THEN 'WARNING: assessment_tools table is empty'
        WHEN (SELECT COUNT(*) FROM assessment_clo_mapping) = 0 THEN 'WARNING: assessment_clo_mapping table is empty'
        WHEN (SELECT COUNT(*) FROM clo_plo_mapping) = 0 THEN 'WARNING: clo_plo_mapping table is empty'
        WHEN (SELECT COUNT(*) FROM student_scores) = 0 THEN 'WARNING: student_scores table is empty'
        WHEN (SELECT COUNT(*) FROM clo_attainment) = 0 THEN 'WARNING: clo_attainment table is empty'
        ELSE 'SUCCESS: All tables have data!'
    END AS verification_status;

-- Show sample data from each table
SELECT '=== Sample Users ===' AS info;
SELECT user_id, username, email, role, full_name FROM users LIMIT 5;

SELECT '=== Sample Courses ===' AS info;
SELECT course_id, course_code, course_name, credit_hours, semester FROM courses LIMIT 5;

SELECT '=== Sample Assessments ===' AS info;
SELECT assessment_id, course_id, assessment_name, assessment_type, max_marks, weightage FROM assessment_tools LIMIT 5;

SELECT '=== Sample Student Scores ===' AS info;
SELECT ss.score_id, u.full_name AS student_name, c.course_code, at.assessment_name, ss.marks_obtained
FROM student_scores ss
JOIN enrollments e ON ss.enrollment_id = e.enrollment_id
JOIN users u ON e.student_id = u.user_id
JOIN assessment_tools at ON ss.assessment_id = at.assessment_id
JOIN courses c ON at.course_id = c.course_id
LIMIT 10;

SELECT '=== Database Reset and Seed Complete! ===' AS message;

-- [END OF REPLACEMENT BLOCK]

SELECT * FROM student_scores;