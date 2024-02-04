# class Wagon
require_relative 'producer'

class Wagon
  include Producer
end

class CargoWagon < Wagon
end

class PassengerWagon < Wagon
end