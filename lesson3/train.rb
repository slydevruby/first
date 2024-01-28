# Train class
class Train
  attr_reader :title, :amount, :type, :route
  attr_accessor :speed

  def initialize(title, type, amount)
    @title = title
    @type = type
    @amount = amount
    @speed = 0
  end

  def add_wagon
    @amount += 1 if @speed.zero?
  end

  def remove_wagon
    @amount -= 1 if @amount.positive? && @speed.zero?
  end

  def accelerate
    @speed += 1
  end

  def brake
    @speed = 0
  end

  def assign_route(route)
    @route = route
    @route.stations.first.accept_train(self)
    @current_index = 0
  end

  def forward
    @current_index += 1 if next_station
  end

  def backward
    @current_index -= 1 if previous_station
  end

  def current_station
    @route.stations[@current_index]
  end

  def next_station
    @route.stations[@current_index + 1]
  end


  def previous_station
    @route.stations[@current_index - 1]
  end


end
