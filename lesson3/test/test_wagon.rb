require 'minitest/autorun'

require_relative '../route'
require_relative '../station'
require_relative '../train'
require_relative '../wagon'

class TestWagon < Minitest::Test
  def setup
    @wagon = Wagon.new(10)
  end

  def test_producer
    assert_respond_to(@wagon, :producer)
  end

  def test_pass
    pass = PassengerWagon.new(10)
    assert_equal(0, pass.occupied)
    pass.occupy(1)
    assert_equal(1, pass.occupied)
    assert_equal(9, pass.free)
  end

  def test_pass_excep
    pass = PassengerWagon.new(10)
    10.times { pass.occupy(1) }
    error = assert_raises(RuntimeError) do
      pass.occupy(1)
    end
    assert_equal 'Всё занято', error.message
  end

  def test_cargo
    cargo = CargoWagon.new(10)
    assert_equal(0, cargo.occupied)
    cargo.occupy(2)
    assert_equal(2, cargo.occupied)
    assert_equal(8, cargo.free)
  end

  def test_cargo_excep
    cargo = CargoWagon.new(10)
    error = assert_raises(RuntimeError) do
      cargo.occupy(11)
    end
    assert_equal 'Всё занято', error.message
  end
end
