# class Wagon
require_relative 'producer'

class Wagon
  include Producer
end

class CargoWagon < Wagon

  attr_reader :max_volume, :taken_volume

  def initialize(max_volume)
    @max_volume = max_volume
    @taken_volume = 0
  end

  def take_volume(qty)
    raise "Весь объём занят" if @taken_volume + qty > @max_volume
    @taken_volume += qty
  end

  def get_taken_volume
    @taken_volume
  end

  def get_free_volume
    @max_volume - @taken_volume
  end
end

class PassengerWagon < Wagon

  attr_reader :max_places, :taken_places

  def initialize(max_places)
    @max_places = max_places
    @taken_places = 0
  end

  def take_place
    raise "Все места заняты" if @taken_places + 1 > @max_places
    @taken_places += 1
  end

  def get_taken_places
    @taken_places
  end

  def get_free_places
    @max_places - @taken_places
  end

end