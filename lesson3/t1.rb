
class Train 
  
  attr_reader :amount

  def initialize(number, type, amount)
  	@number = number
  	@type = type
  	@amount = amount
    @speed = 0

  end

  def speed
    @speed
  end

  def add_wagon
    @amount += 1 if @speed = 0
  end

  def remove_wagon
    @amount -= 1 if (@amount > 0) && (@speed = 0) 
  end

  def accelerate
    @speed += 1
  end

  def brake
    @speed = 0
  end

end

train = Train.new("foo", :passenger, 10) 
puts train.inspect
train.accelerate
puts "speed #{train.speed}"
train.brake
puts "speed #{train.speed}"
puts "amount #{train.amount}"

train.add_wagon

puts train.inspect
  