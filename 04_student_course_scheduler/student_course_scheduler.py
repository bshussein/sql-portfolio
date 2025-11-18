"""
Student Course Scheduler

Mini-project for my database course.

Features:
- Uses a MySQL database `student_course_schedule`
- Creates tables if they do not exist
- Adds students and courses (with basic validation)
- Enrolls students in courses
- Lists which students are in a course
- Lists which courses a student is in
- Shows a student's schedule for a specific day
- Prevents duplicate enrollments and time conflicts
"""

import json
from datetime import datetime

import mysql.connector

# Load database configuration from a config file
# config.json format:
# {
#   "host": "localhost",
#   "user": "root",
#   "password": "yourpassword",
#   "database": "student_course_schedule"
# }
try:
    with open("config.json") as config_file:
        DB_CONFIG = json.load(config_file)
except FileNotFoundError:
    print("Error: 'config.json' file not found.")
    print("""
Please create a 'config.json' file in this folder with content like:

{
    "host": "localhost",
    "user": "root",
    "password": "yourpassword",
    "database": "student_course_schedule"
}
""")
    raise SystemExit(1)


def connect_to_database():
    """Return a MySQL connection or None on error."""
    try:
        return mysql.connector.connect(**DB_CONFIG)
    except mysql.connector.Error as err:
        print(f"Database connection error: {err}")
        return None


def initialize_database():
    """Create the tables if they do not exist."""
    connect = connect_to_database()
    if not connect:
        return

    cursor = connect.cursor()
    try:
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS students (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255) NOT NULL UNIQUE
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS courses (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255) NOT NULL UNIQUE,
                time VARCHAR(255) NOT NULL,
                day VARCHAR(50) NOT NULL
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS enrollments (
                id INT AUTO_INCREMENT PRIMARY KEY,
                student_id INT,
                course_id INT,
                UNIQUE KEY (student_id, course_id),
                FOREIGN KEY (student_id) REFERENCES students(id),
                FOREIGN KEY (course_id) REFERENCES courses(id)
            )
        """)

        connect.commit()
        print("Database tables are ready.")
    except mysql.connector.Error as err:
        print(f"Error initializing database: {err}")
    finally:
        cursor.close()
        connect.close()


def add_student(name: str):
    """Add a new student by name."""
    if len(name.split()) < 2:
        print("Please enter both first and last name.")
        return

    connect = connect_to_database()
    if not connect:
        return

    cursor = connect.cursor()
    try:
        cursor.execute(
            "INSERT INTO students (name) VALUES (%s)",
            (name.strip(),)
        )
        connect.commit()
        print(f"Student '{name}' added successfully.")
    except mysql.connector.Error as err:
        print(f"Error adding student: {err}")
    finally:
        cursor.close()
        connect.close()


def add_course(name: str, time: str, day: str):
    """Add a new course with name, time, and day."""
    if not is_valid_time(time):
        print(f"Invalid time format: {time}. Use 'HH:MM AM/PM'.")
        return

    if not is_valid_day(day):
        print(f"Invalid day: {day}. Please enter a valid weekday.")
        return

    if day in ["Saturday", "Sunday"]:
        print(f"Classes cannot be scheduled on weekends ({day}).")
        return

    connect = connect_to_database()
    if not connect:
        return

    cursor = connect.cursor()
    try:
        # Check if a course already exists at the same time and day
        cursor.execute(
            "SELECT id, name FROM courses WHERE time = %s AND day = %s",
            (time, day)
        )
        conflict = cursor.fetchone()
        if conflict:
            print(
                f"Time conflict: '{conflict[1]}' is already at {time} on {day}."
            )
            return

        # Check if the course already exists by name, time, and day
        cursor.execute(
            "SELECT id FROM courses WHERE name = %s AND time = %s AND day = %s",
            (name, time, day)
        )
        if cursor.fetchone():
            print(f"Course '{name}' at {time} on {day} already exists.")
            return

        cursor.execute(
            "INSERT INTO courses (name, time, day) VALUES (%s, %s, %s)",
            (name.strip(), time.strip(), day)
        )
        connect.commit()
        print(f"Course '{name}' added successfully.")
    except mysql.connector.Error as err:
        print(f"Error adding course: {err}")
    finally:
        cursor.close()
        connect.close()


def enroll_student(student_id: int, course_id: int):
    """Enroll a student in a course."""
    connect = connect_to_database()
    if not connect:
        return

    cursor = connect.cursor()
    try:
        # Check that student exists
        cursor.execute("SELECT name FROM students WHERE id = %s", (student_id,))
        student = cursor.fetchone()
        if not student:
            print(f"Student ID {student_id} does not exist.")
            return

        # Check that course exists
        cursor.execute("SELECT name FROM courses WHERE id = %s", (course_id,))
        course = cursor.fetchone()
        if not course:
            print(f"Course ID {course_id} does not exist.")
            return

        # Check for existing enrollment
        cursor.execute(
            """
            SELECT id FROM enrollments
            WHERE student_id = %s AND course_id = %s
            """,
            (student_id, course_id)
        )
        if cursor.fetchone():
            print(
                f"Student '{student[0]}' is already enrolled in '{course[0]}'."
            )
            return

        cursor.execute(
            "INSERT INTO enrollments (student_id, course_id) VALUES (%s, %s)",
            (student_id, course_id)
        )
        connect.commit()
        print(
            f"Enrolled '{student[0]}' in course '{course[0]}' successfully."
        )
    except mysql.connector.Error as err:
        print(f"Error enrolling student: {err}")
    finally:
        cursor.close()
        connect.close()


def list_all_students():
    """Print all students."""
    connect = connect_to_database()
    if not connect:
        return

    cursor = connect.cursor()
    try:
        cursor.execute("SELECT id, name FROM students ORDER BY id")
        rows = cursor.fetchall()
        if not rows:
            print("No students found.")
            return
        for row in rows:
            print(f"ID: {row[0]}, Name: {row[1]}")
    except mysql.connector.Error as err:
        print(f"Error listing students: {err}")
    finally:
        cursor.close()
        connect.close()


def list_all_courses():
    """Print all courses."""
    connect = connect_to_database()
    if not connect:
        return

    cursor = connect.cursor()
    try:
        cursor.execute("SELECT id, name, time, day FROM courses ORDER BY id")
        rows = cursor.fetchall()
        if not rows:
            print("No courses found.")
            return
        for row in rows:
            print(f"ID: {row[0]}, Name: {row[1]}, Time: {row[2]}, Day: {row[3]}")
    except mysql.connector.Error as err:
        print(f"Error listing courses: {err}")
    finally:
        cursor.close()
        connect.close()


def list_students_in_course(course_id: int):
    """Print all students enrolled in a specific course."""
    connect = connect_to_database()
    if not connect:
        return

    cursor = connect.cursor()
    try:
        cursor.execute("SELECT name FROM courses WHERE id = %s", (course_id,))
        course = cursor.fetchone()
        if not course:
            print(f"Course ID {course_id} does not exist.")
            return

        cursor.execute(
            """
            SELECT s.name
            FROM enrollments e
            JOIN students s ON e.student_id = s.id
            WHERE e.course_id = %s
            ORDER BY s.name
            """,
            (course_id,)
        )
        rows = cursor.fetchall()
        if not rows:
            print(f"No students enrolled in '{course[0]}'.")
            return

        print(f"Students enrolled in '{course[0]}':")
        for row in rows:
            print(f"- {row[0]}")
    except mysql.connector.Error as err:
        print(f"Error listing students in course: {err}")
    finally:
        cursor.close()
        connect.close()


def list_courses_for_student(student_id: int):
    """Print all courses for a given student."""
    connect = connect_to_database()
    if not connect:
        return

    cursor = connect.cursor()
    try:
        cursor.execute("SELECT name FROM students WHERE id = %s", (student_id,))
        student = cursor.fetchone()
        if not student:
            print(f"Student ID {student_id} does not exist.")
            return

        cursor.execute(
            """
            SELECT c.name, c.time, c.day
            FROM enrollments e
            JOIN courses c ON e.course_id = c.id
            WHERE e.student_id = %s
            ORDER BY c.day, c.time
            """,
            (student_id,)
        )
        rows = cursor.fetchall()
        if not rows:
            print(f"No courses found for '{student[0]}'.")
            return

        print(f"Courses for '{student[0]}':")
        for row in rows:
            print(f"- {row[0]} at {row[1]} on {row[2]}")
    except mysql.connector.Error as err:
        print(f"Error listing courses for student: {err}")
    finally:
        cursor.close()
        connect.close()


def student_schedule(student_id: int, day: str):
    """Print a student's schedule for a given day."""
    if not is_valid_day(day):
        print(f"Invalid day: {day}.")
        return

    connect = connect_to_database()
    if not connect:
        return

    cursor = connect.cursor()
    try:
        cursor.execute("SELECT name FROM students WHERE id = %s", (student_id,))
        student = cursor.fetchone()
        if not student:
            print(f"Student ID {student_id} does not exist.")
            return

        cursor.execute(
            """
            SELECT c.name, c.time
            FROM enrollments e
            JOIN courses c ON e.course_id = c.id
            WHERE e.student_id = %s AND c.day = %s
            ORDER BY c.time
            """,
            (student_id, day)
        )
        rows = cursor.fetchall()
        if not rows:
            print(f"No courses scheduled for '{student[0]}' on {day}.")
            return

        print(f"Schedule for '{student[0]}' on {day}:")
        for row in rows:
            print(f"- {row[0]} at {row[1]}")
    except mysql.connector.Error as err:
        print(f"Error retrieving schedule: {err}")
    finally:
        cursor.close()
        connect.close()


def is_valid_day(day: str) -> bool:
    """Return True if day is a valid weekday or weekend name."""
    valid_days = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
    ]
    return day in valid_days


def is_valid_time(time_str: str) -> bool:
    """Validate time format as 'HH:MM AM/PM'."""
    try:
        datetime.strptime(time_str, "%I:%M %p")
        return True
    except ValueError:
        return False


def main():
    """Main text-based menu for the application."""
    while True:
        print("\nStudent Course Scheduler")
        print("1. Add Student")
        print("2. Add Course")
        print("3. Enroll Student in Course")
        print("4. List Students in a Course")
        print("5. View Courses for a Student")
        print("6. View a Student's Schedule for a Specific Day")
        print("7. List All Students and Courses")
        print("8. Exit")

        choice = input("Enter your choice: ").strip()

        if choice == "1":
            name = input("Enter student name (e.g., 'Jim Tim'): ").strip()
            add_student(name)

        elif choice == "2":
            name = input("Enter course name (e.g., 'Math 101'): ").strip()
            time = input("Enter course time (e.g., '9:00 AM'): ").strip()
            day = input("Enter course day (e.g., 'Monday'): ").strip().capitalize()
            add_course(name, time, day)

        elif choice == "3":
            print("\nCurrent students:")
            list_all_students()
            print("\nCurrent courses:")
            list_all_courses()
            try:
                student_id = int(input("\nEnter student ID: ").strip())
                course_id = int(input("Enter course ID: ").strip())
                enroll_student(student_id, course_id)
            except ValueError:
                print("Please enter numeric IDs.")

        elif choice == "4":
            try:
                course_id = int(input("Enter course ID: ").strip())
                list_students_in_course(course_id)
            except ValueError:
                print("Please enter a numeric course ID.")

        elif choice == "5":
            try:
                student_id = int(input("Enter student ID: ").strip())
                list_courses_for_student(student_id)
            except ValueError:
                print("Please enter a numeric student ID.")

        elif choice == "6":
            try:
                student_id = int(input("Enter student ID: ").strip())
                day = input("Enter the day (e.g., 'Monday'): ").strip().capitalize()
                student_schedule(student_id, day)
            except ValueError:
                print("Please enter a numeric student ID.")

        elif choice == "7":
            print("\nAll students:")
            list_all_students()
            print("\nAll courses:")
            list_all_courses()

        elif choice == "8":
            print("Exiting the program. Goodbye!")
            break

        else:
            print("Invalid option. Please try again.")


if __name__ == "__main__":
    initialize_database()
    main()
