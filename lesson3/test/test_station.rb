require 'minitest/autorun'
require_relative '../station'

class StationTest < Minitest::Test
  def setup
    @station = Station.new('Mosco')
  end

  def test_trains_size
    assert_equal(@station.trains.size, 0)
  end

  def test_name
    assert_equal(@station.name, 'Mosco')
    @station.name = 123
    assert_equal false, @station.valid?
    @station.name = 'Omsk'
    assert_equal true, @station.valid?
  end

  def test_station_all
    assert_respond_to(Station, :all)
  end
end
