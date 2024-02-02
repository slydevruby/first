require 'minitest/autorun'

require_relative '../route'
require_relative '../station'
require_relative '../train'
require_relative '../wagon'

class TrainTest < Minitest::Test
  def setup
    @cargo = CargoTrain.new('cargo')

    @moscow = Station.new('Moscow')
    @vlad = Station.new('Vlad')
    @omsk = Station.new('Omsk')
    @irk = Station.new('Irkutsk')

    @route = Route.new(@moscow, @vlad)
    @cargo.assign_route(@route)

    @pass = PassengerTrain.new('1111')
    @pass.assign_route(@route)
  end

  def test_name
    assert_equal(@cargo.name, 'cargo')
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

  def test_producer
    assert_respond_to @pass, :producer
  end

  def test_number
    assert_respond_to @pass, :number
  end

  def test_train_find
    assert_respond_to Train, :find
    t1 = Train.new('999', 999)
    assert_equal t1, Train.find(999)
  end
end
