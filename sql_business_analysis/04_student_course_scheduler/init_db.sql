-- Initialize database schema for the Student Course Scheduler

CREATE TABLE students (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY name (name)
);

CREATE TABLE courses (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  time VARCHAR(255) NOT NULL,
  day VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY name (name)
);

CREATE TABLE enrollments (
  id INT NOT NULL AUTO_INCREMENT,
  student_id INT DEFAULT NULL,
  course_id INT DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY student_course_unique (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (course_id) REFERENCES courses(id)
);
