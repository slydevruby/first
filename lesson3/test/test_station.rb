require 'minitest/autorun'
require_relative '../station'

class StationTest < Minitest::Test
  def setup
    @station = Station.new('Moscow')
  end

  def test_trains_size
    assert_equal(@station.trains.size, 0)
  end

  def test_name
    assert_equal(@station.name, 'Moscow')
  end
end
