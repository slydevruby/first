require 'minitest/autorun'

require_relative '../route'
require_relative '../station'
require_relative '../train'

class TrainTest < Minitest::Test
  def setup
    @amount = 12
    @cargo = Train.new('123', :cargo, @amount)
    @moscow = Station.new('Moscow')
    @vlad = Station.new('Vlad')
    @omsk = Station.new('Omsk')
    @irk = Station.new('Irkutsk')

    @route = Route.new(@moscow, @vlad)
    @cargo.assign_route(@route)


    @pass = Train.new('Passenger', :passenger, 10)
    @pass.assign_route(@route)
  end

  def test_amount
    assert_equal(@cargo.amount, 12)
  end

  def test_name
    assert_equal(@cargo.name, '123')
  end

  def test_route
    assert_equal(@route.stations.first, @moscow)
    assert_equal(@moscow.trains, [@cargo, @pass])
    assert_equal(@route.stations.last, @vlad)
    assert_equal(@cargo.current_station, @moscow)
    assert_equal(@cargo.next_station, @vlad)
  end

  def test_action
    @route << @omsk
    @cargo.forward
    assert_equal(@cargo.current_station, @omsk)
    assert_equal(@omsk.trains, [@cargo])
    assert_equal(@moscow.trains, [@pass])

    assert_equal(@cargo.previous_station, @moscow)
    assert_equal(@cargo.next_station, @vlad)

    @route << @irk
    assert_equal(@cargo.current_station, @omsk)
    @cargo.forward
    assert_equal(@cargo.current_station, @irk)
    assert_equal(@cargo.previous_station, @omsk)
    @cargo.backward
    assert_equal(@cargo.current_station, @omsk)
  end

  def test_wagon
    assert_equal(@cargo.amount, @amount)
    @cargo.add_wagon
    assert_equal(@cargo.amount, @amount + 1)
    @cargo.accelerate
    assert_equal(@cargo.speed, 1)
    old = @cargo.amount
    @cargo.add_wagon
    assert_equal(@cargo.amount, old)
    @cargo.brake
    old = @cargo.amount
    @cargo.add_wagon
    assert_equal(@cargo.amount, old+1)
  end
end
