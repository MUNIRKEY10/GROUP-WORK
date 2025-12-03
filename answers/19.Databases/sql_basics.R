# Database Operations with SQL in R
library(RSQLite)
library(DBI)

cat("=== SQL Database Operations ===\n\n")

# Create in-memory database
con <- dbConnect(RSQLite::SQLite(), ":memory:")

# Create tables
dbExecute(con, "
CREATE TABLE students (
  id INTEGER PRIMARY KEY,
  name TEXT,
  age INTEGER
)")

dbExecute(con, "
CREATE TABLE grades (
  student_id INTEGER,
  course TEXT,
  grade REAL,
  FOREIGN KEY (student_id) REFERENCES students(id)
)")

# Insert data
students.data <- data.frame(
  id = c(1, 2, 3),
  name = c('Alice', 'Bob', 'Charlie'),
  age = c(20, 21, 19)
)

grades.data <- data.frame(
  student_id = c(1, 1, 2, 2, 3),
  course = c('Math', 'Physics', 'Math', 'Physics', 'Math'),
  grade = c(95, 88, 78, 82, 92)
)

dbWriteTable(con, "students", students.data, append=TRUE)
dbWriteTable(con, "grades", grades.data, append=TRUE)

# Example 1: SELECT with WHERE
cat("--- SELECT with WHERE ---\n")
result <- dbGetQuery(con, "
SELECT name, age FROM students WHERE age >= 20
")
print(result)
cat("\n")

# Example 2: JOIN
cat("--- JOIN Tables ---\n")
result <- dbGetQuery(con, "
SELECT students.name, grades.course, grades.grade
FROM students
JOIN grades ON students.id = grades.student_id
WHERE grades.grade > 85
")
print(result)
cat("\n")

# Example 3: Aggregate
cat("--- Aggregation ---\n")
result <- dbGetQuery(con, "
SELECT students.name, AVG(grades.grade) as avg_grade
FROM students
JOIN grades ON students.id = grades.student_id
GROUP BY students.name
")
print(result)

dbDisconnect(con)
cat("\nDatabase operations completed!\n")
