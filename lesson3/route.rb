
class Route

  attr_reader :stations, :first, :last

	def initialize(first, last)
		@first = first
		@last  = last
		@stations = [@first, @last]
    puts "Создаем маршрут сообщением #{@first.name} -- #{@last.name}"
	end

	def add_station(station)
		@stations.insert(@stations.size - 1, station)
    puts "В маршрут добавлена станция #{station.name}"
	end

  def << (station)
    add_station(station)
  end

	def remove_station(station)
    if (station != @first) && (station != @last)
		  ind = @stations.index(station)
      if ind
        puts "amount of trains: #{station.trains.size}"
        if station.trains.size == 0
		      @stations.delete_at(ind) 
          puts "Удалена станция #{station.name}"
        else
          raise "Нельзя удалить станцию, на ней есть поезда"
        end
      end
    else
      raise "Нельзя удалить первую и последнюю станции маршрута"
    end
	end

  def get_next(station)
    ind = @stations.index(station)
    if ind == @stations.size - 1
      @stations[ind]
    else 
      @stations[ind+1]
    end
  end

  def get_prev(station)
    ind = @stations.index(station)
    if ind == 0
      @stations[ind]
    else 
      @stations[ind-1]
    end
  end


  def show_stations
    @stations.each { |station| puts station.name }
  end
end


