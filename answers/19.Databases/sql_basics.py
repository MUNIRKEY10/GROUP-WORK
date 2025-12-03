"""
Database Operations with SQL
Basic SELECT, WHERE, and JOIN operations using sqlite3
"""
import sqlite3
import pandas as pd

print("=== SQL Database Operations ===\n")

# Create in-memory database
conn = sqlite3.connect(':memory:')
cursor = conn.cursor()

# Create tables
cursor.execute('''
CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    age INTEGER
)
''')

cursor.execute('''
CREATE TABLE grades (
    student_id INTEGER,
    course TEXT,
    grade REAL,
    FOREIGN KEY (student_id) REFERENCES students(id)
)
''')

# Insert data
students_data = [
    (1, 'Alice', 20),
    (2, 'Bob', 21),
    (3, 'Charlie', 19)
]

grades_data = [
    (1, 'Math', 95),
    (1, 'Physics', 88),
    (2, 'Math', 78),
    (2, 'Physics', 82),
    (3, 'Math', 92)
]

cursor.executemany('INSERT INTO students VALUES (?, ?, ?)', students_data)
cursor.executemany('INSERT INTO grades VALUES (?, ?, ?)', grades_data)
conn.commit()

# Example 1: SELECT with WHERE
print("--- SELECT with WHERE ---")
query = "SELECT name, age FROM students WHERE age >= 20"
result = pd.read_sql_query(query, conn)
print(result, "\n")

# Example 2: JOIN
print("--- JOIN Tables ---")
query = '''
SELECT students.name, grades.course, grades.grade
FROM students
JOIN grades ON students.id = grades.student_id
WHERE grades.grade > 85
'''
result = pd.read_sql_query(query, conn)
print(result, "\n")

# Example 3: Aggregate
print("--- Aggregation ---")
query = '''
SELECT students.name, AVG(grades.grade) as avg_grade
FROM students
JOIN grades ON students.id = grades.student_id
GROUP BY students.name
'''
result = pd.read_sql_query(query, conn)
print(result)

conn.close()
print("\nDatabase operations completed!")
