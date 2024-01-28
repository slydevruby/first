require 'minitest/autorun'

require_relative '../route'
require_relative '../station'
require_relative '../train'

class TrainTest < Minitest::Test
  def setup
    @amount = 12
    @train = Train.new('123', :cargo, @amount)
    @mos = Station.new('Moscow')
    @vlad = Station.new('Vlad')
    @oms = Station.new('Omsk')
    @irk = Station.new('Irkutsk')

    @route = Route.new(@mos, @vlad)
    @train.assign_route(@route)
  end

  def test_amount
    assert_equal(@train.amount, 12)
  end

  def test_title
    assert_equal(@train.title, '123')
  end

  def test_route
    assert_equal(@route.stations.first, @mos)
    assert_equal(@route.stations.last, @vlad)
    assert_equal(@train.current_station, @mos)
    assert_equal(@train.next_station, @vlad)
  end

  def test_action
    @route << @oms
    @train.forward
    assert_equal(@train.current_station, @oms)
    assert_equal(@train.previous_station, @mos)
    assert_equal(@train.next_station, @vlad)

    @route << @irk
    assert_equal(@train.current_station, @oms)
    @train.forward
    assert_equal(@train.current_station, @irk)
    assert_equal(@train.previous_station, @oms)
    @train.backward
    assert_equal(@train.current_station, @oms)
  end

  def test_wagon
    assert_equal(@train.amount, @amount)
    @train.add_wagon
    assert_equal(@train.amount, @amount + 1)
    @train.accelerate
    assert_equal(@train.speed, 1)
    old = @train.amount
    @train.add_wagon
    assert_equal(@train.amount, old)
    @train.brake
    old = @train.amount
    @train.add_wagon
    assert_equal(@train.amount, old+1)
  end
end
