require_relative 'instance_counter'

class Route
  attr_reader :stations

  include InstanceCounter

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    return unless validate!

    register_instance
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  def add_station(station)
    raise 'Нельзя добавить пустую станцию' if station.nil?

    @stations.insert(@stations.size - 1, station)
  end

  def <<(station)
    add_station(station)
  end

  def remove_station(station)
    raise 'Нельзя удалить пустую станцию' if station.nil?
    raise 'Нельзя удалить начальную станцию' if station == @stations.first
    raise 'Нельзя удалить конечную станцию' if station == @stations.last

    @stations.delete(station)
  end

  protected

  def validate!
    raise 'Нельзя добавить пустую начальную станцию' if @stations.first.nil?
    raise 'Нельзя добавить пустую конечную станцию' if @stations.last.nil?
    raise 'Начальная и конечная станции должны быть разными' if @stations.first == @stations.last

    true
  end
end
