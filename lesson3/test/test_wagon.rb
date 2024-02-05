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

  def test_pass_methods
    pass = PassengerWagon.new(10)
    assert_respond_to(pass, :producer)
    assert_respond_to(pass, :get_taken_places)
    assert_respond_to(pass, :get_free_places)
    assert_respond_to(pass, :take_place)
  end

  def test_pass
    pass = PassengerWagon.new(10)
    assert_equal(0, pass.get_taken_places)
    pass.take_place
    assert_equal(1, pass.get_taken_places)
    assert_equal(9, pass.get_free_places)
  end

  def test_pass_excep
    pass = PassengerWagon.new(10)
    10.times { pass.take_place }
    error = assert_raises(RuntimeError) do
      pass.take_place
    end
    assert_equal 'Все места заняты', error.message
  end

  def test_cargo
    cargo = CargoWagon.new(10)
    assert_equal(0, cargo.get_taken_volume)
    cargo.take_volume(2)
    assert_equal(2, cargo.get_taken_volume)
    assert_equal(8, cargo.get_free_volume)
  end

  def test_cargo_excep
    cargo = CargoWagon.new(10)
    error = assert_raises(RuntimeError) do
      cargo.take_volume(11)
    end
    assert_equal 'Весь объём занят', error.message
  end
end
