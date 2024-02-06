# Train class

require_relative 'producer'
require_relative 'instance_counter'

# Поезд
class Train
  attr_reader :name, :wagons, :route, :number

  # /^...-?..$/i
  TRAIN_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i.freeze

  include Producer
  include InstanceCounter

  class << self
    attr_writer :trains

    def find(number)
      @trains.find { |train| train.number == number }
    end

    def trains
      @trains ||= []
    end
  end

  def initialize(name, number = nil)
    @name = name
    @number = number
    return unless validate!

    @speed = 0
    @wagons = []
    self.class.trains << self
    register_instance
  end

  def each_wagon(&block)
    wagons.each(&block)
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed.zero?
  end

  def valid?
    validate!
  rescue StandardError
    false
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
    return unless next_station

    current_station.send_train(self)
    @current_index += 1
    current_station.accept_train(self)
  end

  def backward
    return unless previous_station

    current_station.send_train(self)
    @current_index -= 1
    current_station.accept_train(self)
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

  def validate!
    raise 'Неправильное имя' if name.nil?
    raise 'Номер должен быть строкой' if !number.nil? && !(number.is_a? String)
    raise 'Неправильный формат номера' if !number.nil? && number !~ TRAIN_FORMAT

    true
  end
end

# Passenger train
class PassengerTrain < Train
  def add_wagon(wagon)
    @wagons << wagon if wagon.is_a?(PassengerWagon) && @speed.zero?
  end

  def type
    'Пассажирский'
  end
end

# Passenger train
class CargoTrain < Train
  def add_wagon(wagon)
    @wagons << wagon if wagon.is_a?(CargoWagon) && @speed.zero?
  end

  def type
    'Грузовой'
  end
end
