# Julia code for "Control Flow and Strings"
using Statistics

# if()
x = -5
if x >= 0
  println(x)
else
  println(-x)
end

println(x >= 0 ? x : -x)

# nested if
if x^2 < 1
  println(x^2)
else
  if x >= 0
    println(2 * x - 1)
  else
    println(-2 * x - 1)
  end
end

# Combining Booleans
(0 > 0) && isapprox(42 % 6, 169 % 13)

# for()
table_of_logarithms = zeros(7)
for i in 1:length(table_of_logarithms)
  table_of_logarithms[i] = log(i)
end
println(table_of_logarithms)

# while()
x = 100
while maximum(x) - 1 > 1e-06
  global x = sqrt(x)
end

# ifelse()
x = -5:5
ifelse.(x.^2 .> 1, 2 .* abs.(x) .- 1, x.^2)

type_of_summary = "mean"
if type_of_summary == "mean"
    println(mean(rand(10)))
elseif type_of_summary == "median"
    println(median(rand(10)))
else
    println("I don't understand")
end


# Strings
length("Lincoln")
"Christmas Bonus"[8:12]
phrase = "Christmas Bonus"
phrase = phrase[1:12] * "g" * phrase[14:end]
println(phrase)

presidents = ["Fillmore", "Pierce", "Buchanan", "Davis", "Johnson"]
[p[1:2] for p in presidents]
[p[end-1:end] for p in presidents]

scarborough_fair = "parsley, sage, rosemary, thyme"
split(scarborough_fair, ", ")

["$p $i" for (p, i) in zip(presidents, 41:45)]
["$p($i)" for (p, i) in zip(presidents, 41:45)]
join(["$p($i)" for (p, i) in zip(presidents, 41:45)], "; ")
