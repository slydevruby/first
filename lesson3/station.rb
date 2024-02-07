require_relative 'instance_counter'
require_relative 'validation'

# Станция, содержит поезда
class Station
  attr_reader :trains
  attr_accessor :name

  include InstanceCounter
  include Validation

  validate :name, type: String

  class << self
    attr_writer :stations

    def all
      @stations
    end

    def stations
      @stations ||= []
    end
  end

  def initialize(name)
    @name = name
    return unless validate!
    @trains = []
    self.class.stations << self
    register_instance
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def each_train(&block)
    trains.each(&block)
  end

  def get_trains_by_type(type)
    @trains.select { |train| train.type == type }.size
  end
end
