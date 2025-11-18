-- Sample data for the Student Course Scheduler

INSERT INTO students (id, name) VALUES
(1, 'Tim Johnson'),
(2, 'Ben Saliba'),
(3, 'Nick Jackson'),
(4, 'Ben Smith'),
(5, 'Tim Johnson ');

INSERT INTO courses (id, name, time, day) VALUES
(1, 'PSYCH 202', '10:00 AM', 'Tuesday'),
(2, 'MATH 101', '9:00 AM', 'Monday'),
(3, 'SWE 242', '7:00 AM', 'Friday'),
(4, 'MATH 202', '12:00 PM', 'Thursday');

INSERT INTO enrollments (id, student_id, course_id) VALUES
(1, 1, 2),
(2, 3, 2),
(3, 2, 1),
(5, 1, 1),
(6, 5, 4);
