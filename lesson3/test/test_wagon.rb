require 'minitest/autorun'

require_relative '../route'
require_relative '../station'
require_relative '../train'
require_relative '../wagon'

class TestWagon < Minitest::Test
  def setup
    @wagon = Wagon.new
  end

  def test_producer
    assert_respond_to(@wagon, :producer)
  end
end
