load 'station.rb'
load 'route.rb'
load 'train.rb'

$stations = []
$routes =[]
$trains = []

def create_station
  print "Введите имя станции: "
  name = gets.chomp
  station = Station.new(name)
  $stations << station
end

def stations_list
  index = 0
  puts "Список станций:"
  $stations.each do |station|
    puts "#{index} Станция #{station.name}"
    index += 1
  end
  index
end

def create_route
  index = stations_list
  
  first = 0
  second = 1
  loop do
    puts "Выберите первую и последнюю станции 0..#{index} по номеру, вводя их через пробел"
    first, second = gets.chomp.split(' ')
    first, second = [first, second].map(&:to_i)
    if first == second 
      puts 'Станции должны быть разными. Повторим'
    elsif !(0..index).include? first
      puts 'Такого номера станции нет. Повторим'
    elsif !(0..index).include? second
      puts 'Такого номера станции нет. Повторим'
    else
      break 
    end
  end
  $routes << Route.new($stations[first], $stations[second])
end

def add_station_to_route
  puts "add_station_to_route"
end

def rem_station_from_route
  puts "rem_station_from_route"
end



def create_train
  puts "Введите название"
  name = gets.chomp
  train = Train.new(name, :cargo, 10)
  $trains << train

  puts $trains
end

def trains_on_station
  puts 'list of train on station!'
end

def trains_list
  index = 0
  $trains.each do |train|
    puts "#{index} Поезд #{train.name}, #{train.type}, вагонов: #{train.amount}"
    index += 1
  end
end

def chain_wagon
  trains_list
end


def unchain_wagon
end

def routes_list
  $routes.each do |route|
    print 'Маршрут сообщением '
    puts "#{route.stations.first.name} #{route.stations.last.name}"
  end
end

$menu = {Станция: [], Маршрут: [], Поезд: []}
$menu[:Станция] << {title: 'Создать станцию', meth: :create_station}
$menu[:Станция] << {title: 'Показать список поездов на станции', meth: :trains_on_station}

$menu[:Маршрут] << {title: 'Создать Маршрут', meth: :create_route}
$menu[:Маршрут] << {title: 'Список Маршрутов', meth: :routes_list}
$menu[:Маршрут] << {title: 'Добавить станцию к маршруту', meth: :add_station_to_route}
$menu[:Маршрут] << {title: 'Убрать станцию с маршрута', meth: :rem_station_from_route}

$menu[:Поезд] << {title: 'Создать', meth: :create_train}
$menu[:Поезд] << {title: 'Показать список', meth: :trains_list}
$menu[:Поезд] << {title: 'Добавить вагоны', meth: :chain_wagon}
$menu[:Поезд] << {title: 'Отцепить вагоны', meth: :unchain_wagon}


#puts menu
def show_menu
  options = ('a'..'z').to_a
  puts "-" * 20
  index = 0
  $menu.each do |key, value|
    puts key
    value.each do |v|
      #puts " #{index}   #{v[:title]}"
      v[:char] = options[index]
      puts "   [#{v[:char]}] => #{v[:title]}"
      index += 1
    end
  end
  puts "-" * 20
  index
end
#puts $menu
show_menu

loop do
  index = show_menu
  print "Введите букву команды, q для выхода: "
  char = gets.chomp
  exit if char == 'q'
  $menu.each do |key, value|
    value.each do |val|
      begin
        if val[:char] == char
          puts "Выбрали пункт <#{val[:title]}>"
          method(val[:meth]).call
          puts "Команда завершена"
        end
      rescue
        puts "Команда выполнилась с ошибкой"
      end
    end
  end
end # loop 
