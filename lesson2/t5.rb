def leap?(year)
	((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)
end

days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

puts "Input day, month, year "
day, month, year = gets.chomp.split
day = day.to_i
month = month.to_i
year = year.to_i

days[1] = 29 if leap? year

total = 0
(0...month-1).each { |x| total += days[x] }

puts "Ordinal date #{total + day}"
