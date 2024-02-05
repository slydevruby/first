require_relative 'instance_counter'
class Station
  @@stations = []
  attr_reader :name, :trains

  include InstanceCounter

  def self.all
    @@stations
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  def initialize(name)
    @name = name
    return unless validate!

    @trains = []
    @@stations << self
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

  protected

  def validate!
    raise 'Неправильное имя' if name.nil?
    raise 'Пустая строка' if name.empty?
    raise 'Название должно быть строкой' unless name.is_a? String

    true
  end
end
