require 'minitest/autorun'
require_relative '../station'
require_relative '../route'

class RouteTest < Minitest::Test
  def setup
    @station1 = Station.new('Moscow')
    @station2 = Station.new('Vlad')

    @st3 = Station.new('Omsk')
    @route = Route.new(@station1, @station2)
  end

  def test_first
    assert_equal(@route.stations.first, @station1)
  end

  def test_last
    assert_equal(@route.stations.last, @station2)
  end

  def test_add
    @route << @st3
    assert_equal(@route.stations.size, 3)
  end

  def test_rem
    @route.remove_station(@st3)
    assert_equal(@route.stations.size, 2)
  end

  def test_rem_mos
    @route.remove_station(@station1)
    assert_equal(@route.stations.first, @station1)
  end

  def test_rem_vlad
    @route.remove_station(@station2)
    assert_equal(@route.stations.last, @station2)
  end
end
