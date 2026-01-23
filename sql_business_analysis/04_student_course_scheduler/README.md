# Student Course Scheduler (Python + MySQL)

This mini-project is a Python + MySQL application that manages students, courses,
and enrollments. It was built as part of a university database course and demonstrates
how SQL integrates with a real program rather than being used in isolation.

The focus of the project is on relational design, SQL operations, and enforcing
constraints through application logic.

## Features
- Initialize the `student_course_schedule` database and tables
- Add new students with basic validation
- Add new courses with time and day constraints
- Prevent scheduling conflicts (duplicate course times)
- Enroll students in courses
- Query:
  - All students enrolled in a course
  - All courses for a student
  - A student’s schedule for a specific day
- Persistent data storage using a MySQL backend

## Database Design
- Relational schema with primary and foreign keys
- Many-to-many relationship between students and courses
- Constraints enforced through both SQL and application logic

## Files
- `init_db.sql` – Creates the database schema and tables
- `sample_data.sql` – Optional script to insert example data
- `student_course_scheduler.py` – Python CLI application
- `config.json.example` – Example configuration file for database credentials

## How to Run
1. Create the database and tables:
   ```bash
   mysql -u root -p < init_db.sql
   ```

2. (Optional) Load sample data:
   ```bash
   mysql -u root -p student_course_schedule < sample_data.sql
   ```

3. Copy the configuration template and update credentials:
   ```bash
   cp config.json.example config.json
   ```

4. Run the application:
   ```bash
   python student_course_scheduler.py
   ```

## Technologies
- Python
- MySQL
- SQL (DDL and DML)

## Notes
This project is intentionally lightweight and command-line based. It is designed
to demonstrate SQL usage within an application context rather than full-scale
software architecture or frontend development.
