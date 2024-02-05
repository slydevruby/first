require 'minitest/autorun'

require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'wagon'

class CounterTest < Minitest::Test
  def test_trains
    assert_equal 0, Train.instances
    10.times { Train.new 1000 }
    assert_equal 10, Train.instances
  end

  def test_station_routes
    assert_equal 0, Station.instances
    s1 = Station.new 'S1'
    s2 = Station.new 'S2'
    assert_equal 2,  Station.instances
    assert_equal 0, Route.instances
    13.times { Route.new(s1, s2) }
    assert_equal 13, Route.instances
  end
end
