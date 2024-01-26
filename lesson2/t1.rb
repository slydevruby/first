h = {}

days = [31, 28, 31, 30, 31, 30, 
	31, 31, 30, 31, 30, 31]

days.each_with_index { |item, i| h[i+1] = item }

puts "Months with 30 days are: "
h.select { |key, value| puts key if value == 30 }
