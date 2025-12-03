# R code for "Control Flow and Strings"

# if()
x <- -5
if (x >= 0) {
  x
} else {
  -x
}

if (x >= 0) x else -x

# nested if
if (x^2 < 1) {
  x^2
} else {
  if (x >= 0) {
    2 * x - 1
  } else {
    -2 * x - 1
  }
}

# Combining Booleans
(0 > 0) && (all.equal(42 %% 6, 169 %% 13))

# for()
table.of.logarithms <- vector(length = 7, mode = "numeric")
for (i in 1:length(table.of.logarithms)) {
  table.of.logarithms[i] <- log(i)
}
table.of.logarithms

# while()
x <- 100
while (max(x) - 1 > 1e-06) {
  x <- sqrt(x)
}

# ifelse()
x <- -5:5
ifelse(x^2 > 1, 2 * abs(x) - 1, x^2)

# switch()
type.of.summary <- "mean"
switch(type.of.summary,
  mean = mean(state.x77[, "Murder"]),
  median = median(state.x77[, "Murder"]),
  histogram = hist(state.x77[, "Murder"]),
  "I don't understand"
)

# Strings
nchar("Lincoln")
substr("Christmas Bonus", start = 8, stop = 12)
phrase <- "Christmas Bonus"
substr(phrase, 13, 13) <- "g"
phrase

presidents <- c("Fillmore", "Pierce", "Buchanan", "Davis", "Johnson")
substr(presidents, 1, 2)
substr(presidents, nchar(presidents) - 1, nchar(presidents))

scarborough.fair <- "parsley, sage, rosemary, thyme"
strsplit(scarborough.fair, ", ")

paste(presidents, 41:45)
paste(presidents, " (", 41:45, ")", sep = "")
paste(presidents, " (", 41:45, ")", sep = "", collapse = "; ")
