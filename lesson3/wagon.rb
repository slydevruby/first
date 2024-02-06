require_relative 'producer'

# class Wagon implements 'wagon' behaviour
class Wagon
  attr_reader :max, :occupied, :free

  include Producer

  def initialize(max, raise_text = 'Всё занято')
    @max = max
    @occupied = 0
    @free = max
    @raise_text = raise_text
  end

  def occupy(qty)
    raise @raise_text if @occupied + qty > @max

    @occupied += qty
    @free = @max - @occupied
  end

  def show
    raise 'Abstract method Wagon.show'
  end
end

# This is cargo wagon
class CargoWagon < Wagon
  def initalize(max)
    super(max, 'Весь объём занят')
  end

  def show
    puts "  грузовой вагон, общий объём #{@max}, занято #{@occupied}"\
      " свободно #{free}"
  end
end

# This is passenger wagon
class PassengerWagon < Wagon
  def initalize(max)
    super(max, 'Все места заняты')
  end

  def show
    puts "  пассажирский вагон, общее количество мест #{@max}, занято #{@occupied}"\
          " свободно #{free}"
  end
end
