# Student Course Scheduler 

This mini-project is a Python + MySQL application that manages students, courses, and enrollments. It was built for my university database course and demonstrates how SQL integrates with a real program.

## Features
- Initialize the `student_course_schedule` database and tables
- Add new students with validation
- Add new courses (with time/day constraints)
- Prevent scheduling conflicts (duplicate times)
- Enroll students in courses
- List:
  - All students in a course
  - All courses for a student  
  - A student's schedule on a specific day
- All data persists between runs (MySQL backend)

## Files
- `init_db.sql` – Creates the `students`, `courses`, and `enrollments` tables  
- `sample_data.sql` – Optional: inserts example rows  
- `student_course_scheduler.py` – Python CLI application  
- `config.json.example` – Example configuration file for DB credentials

## How to Run
1. Create the database:
   ```bash
   mysql -u root -p < init_db.sql
