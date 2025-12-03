# Database Operations with SQL in Julia
using SQLite, DataFrames, DBInterface

println("=== SQL Database Operations ===\n")

# Create in-memory database
db = SQLite.DB()

# Create tables
DBInterface.execute(db, """
CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    age INTEGER
)
""")

DBInterface.execute(db, """
CREATE TABLE grades (
    student_id INTEGER,
    course TEXT,
    grade REAL,
    FOREIGN KEY (student_id) REFERENCES students(id)
)
""")

# Insert data
students_data = DataFrame(
    id = [1, 2, 3],
    name = ["Alice", "Bob", "Charlie"],
    age = [20, 21, 19]
)

grades_data = DataFrame(
    student_id = [1, 1, 2, 2, 3],
    course = ["Math", "Physics", "Math", "Physics", "Math"],
    grade = [95, 88, 78, 82, 92]
)

SQLite.load!(students_data, db, "students")
SQLite.load!(grades_data, db, "grades")

# Example 1: SELECT with WHERE
println("--- SELECT with WHERE ---")
result = DBInterface.execute(db, """
SELECT name, age FROM students WHERE age >= 20
""") |> DataFrame
println(result, "\n")

# Example 2: JOIN
println("--- JOIN Tables ---")
result = DBInterface.execute(db, """
SELECT students.name, grades.course, grades.grade
FROM students
JOIN grades ON students.id = grades.student_id
WHERE grades.grade > 85
""") |> DataFrame
println(result, "\n")

# Example 3: Aggregate
println("--- Aggregation ---")
result = DBInterface.execute(db, """
SELECT students.name, AVG(grades.grade) as avg_grade
FROM students
JOIN grades ON students.id = grades.student_id
GROUP BY students.name
""") |> DataFrame
println(result)

println("\nDatabase operations completed!")
