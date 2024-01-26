cart = {}

loop do 
	puts "Введите название продукта или 'стоп' для завершения"
  product = gets.chomp
  break if product == 'стоп'
  print "Введите через пробел цену за единицу и количество "
  unit_price, amount = gets.chomp.split(' ')
  cart[product] = { price: unit_price.to_f, amount: amount.to_i }
end

puts "Корзина #{cart}"
total = 0
cart.each_value { |val| total += val[:amount] * val[:price] }

puts "Полная цена корзины #{total}"