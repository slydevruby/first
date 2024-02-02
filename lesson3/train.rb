# Train class

require_relative 'producer'
require_relative 'instance_counter'

class Train
  @@trains = []

  attr_reader :name, :wagons, :route, :number

  include Producer
  include InstanceCounter

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end


  def initialize(name, number = nil)
    @name = name
    @speed = 0
    @number = number
    @wagons = []
    @@trains << self
    register_instance
  end

  def add_wagon(wagon)
     @wagons << wagon if @speed.zero?
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon) if @speed.zero?
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
    if next_station 
      current_station.send_train(self)
      @current_index += 1 
      current_station.accept_train(self)
    end
  end

  def backward
    if previous_station
      current_station.send_train(self)
      @current_index -= 1
      current_station.accept_train(self)
    end
  end

  def current_station
    @route.stations[@current_index] if @route
  end

  def next_station
    @route.stations[@current_index + 1] if @route
  end

  def previous_station
    @route.stations[@current_index - 1] if @route
  end

  protected
  attr_accessor :speed # извне этот метод не нужен


end

class PassengerTrain < Train
  def add_wagon(wagon)
     @wagons << wagon if wagon.is_a? PassengerWagon and @speed.zero?
  end

  def type
    'Пассажирский'
  end

end

class CargoTrain < Train
  def add_wagon(wagon)
    @wagons << wagon if wagon.is_a? CargoWagon and @speed.zero?
  end
  def type
    'Грузовой'
  end

end

