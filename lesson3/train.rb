
class Train 
  
  attr_reader :number, :amount, :type, :route 
  attr_accessor :speed
  

  def initialize(number, type, amount)
  	@number = number
  	@type = type
  	@amount = amount
    @speed = 0
  end

  def add_wagon
    if @speed == 0
      @amount += 1 
    else
      puts 'Train cannot add a wagon because it is running'\
      '. Call train.brake to stop'
    end
  end

  def remove_wagon
    @amount -= 1 if (@amount > 0) && (@speed == 0) 
  end

  def accelerate
    @speed += 1
  end

  def brake
    @speed = 0
  end

  def set_route(route)
    @route = route
    @route.first.add_train(self)
  end

  def get_station(type_station)
    # seach current 
    for station in @route.stations
      break if station.trains.include? self
    end
    if type_station == :current_station
      station
    elsif type_station == :next_station
      @route.get_next(station)
    elsif type_station == :prev_station
      @route.get_prev(station)
    end
  end


  def forward
    cur = get_station(:current_station)
    nxt = @route.get_next(cur)
    cur.remove_train(self)
    nxt.add_train(self)
  end

  def backward
    cur = get_station(:current_station)
    prev = @route.get_prev(cur)
    cur.remove_train(self)
    prev.add_train(self)

  end

  def show_self
    "        Поезд: #{number} тип: #{type}, вагонов: #{amount}, скорость: #{speed}"
  end


end

  