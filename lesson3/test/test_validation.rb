require 'minitest/autorun'
require_relative '../validation'
require_relative '../accessors'

class Foo
  attr_writer :name, :number, :foo

  include Validation
  extend Accessors

  attr_accessor_with_history :car
  strong_accessor :superman, Integer

  validate :name, presence: true
  validate :name, type: String, length: 2, format: /^[a-z]{2}$/
  validate :number, type: Integer

  def initialize(name, number)
    @name = name
    @number = number
    validate!
  end
end

# Проверяем счетчик количества экземпляров
class FooTest < Minitest::Test
  def setup
    @foo = Foo.new('ab', 123)
  end

  def test_name
    @foo.name = 'aa'
    assert_equal true, @foo.valid?
  end

  def test_len
    @foo.name = 'bbb'
    assert_equal false, @foo.valid?
  end

  def test_format
    @foo.name = '1b'
    assert_equal false, @foo.valid?
    @foo.name = 'xb'
    assert_equal true, @foo.valid?
  end

  def test_type
    @foo.name = 123
    assert_equal false, @foo.valid?
  end

  def test_number
    @foo.number = 'aa'
    assert_equal false, @foo.valid?
    @foo.number = 1
    assert_equal true, @foo.valid?
  end

  def test_history
    assert_nil @foo.car
    @foo.car = 'honda'
    assert_includes @foo.car_history, 'honda'
    @foo.car = 'ford'
    assert_includes @foo.car_history, 'ford'
  end

  def test_strong
    error = assert_raises(RuntimeError) do
      @foo.superman = 'aa'
    end
    assert_equal 'Invalid type, must be Integer', error.message
  end
end
