# Площадь треугольника. Площадь треугольника можно вычислить, 
# зная его основание (a) и высоту (h) по формуле: 1/2*a*h. 
# Программа должна запрашивать основание и высоту треугольника и возвращать его площадь.


puts "Эта программа рассчитывает площадь треугольника"
print "Введите основание и высоту через пробел "
base, height = gets.chomp.split(' ')
square = 0.5 * base.to_i * height.to_i
puts "Площадь треугольника равна #{square}"


