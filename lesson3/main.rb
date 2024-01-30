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

def show_stations
  puts "Всего станций: #{$stations.size}"
  $stations.each_with_index do |station, index|
    puts "  #{index}  Станция #{station.name}"
  end
end

def show_routes
  puts "Всего маршрутов: #{$routes.size}"
  $routes.each_with_index do |route, index|
    print "  #{index} Маршрут сообщением"
    puts " #{route.stations.first.name} #{route.stations.last.name}"
  end
end

def show_trains
  puts "Всего поездов: #{$trains.size}"
  $trains.each_with_index do |train, index|
    puts "  #{index} Поезд #{train.name}, #{train.type}, вагонов: #{train.amount}"
  end
end

def create_route
  show_stations
  index = $stations.size
  
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

def input_loop(title, top)
  number = 0
  loop do
    puts "Выберите #{title} 0..#{top} по номеру"
    number = gets.chomp.to_i
    break if (0..top).include? number
    puts "Такого номера нет. Повторим"
  end
  number
end

def assign_route
  show_trains
  train_no = input_loop('поезд', $trains.size - 1)
  show_routes
  route_no = input_loop('маршрут', $routes.size - 1) 
  $trains[train_no].assign_route($routes[route_no])
end



def add_station_to_route
  show_routes
  route_number = input_loop('маршрут', $routes.size - 1)
  show_stations
  station_number = input_loop('станцию', $stations.size - 1)
  puts 'Добавляем станцию к маршруту'
  $routes[route_number].add_station($stations[station_number])  
end

def rem_station_from_route
  puts "rem_station_from_route"
end

def create_train
  puts "Введите название"
  name = gets.chomp
  train = Train.new(name, :cargo, 10)
  $trains << train
end

def trains_on_station
  show_stations
  no = input_loop('станцию', $stations.size - 1)
  puts "На станции #{$stations[no].name} поездов: #{$stations[no].trains.size}"
  $stations[no].trains.each { |tr|  puts "Train #{tr.name}"  }
end

def show_stations_on_route
  show_routes
  route_number = input_loop('маршрут', $routes.size - 1)
  $routes[route_number].stations.each { |station| puts "  Станция #{station.name}" }
end

def chain_wagon
  show_trains
end

def unchain_wagon
  show_trains
end

def forward
  show_trains
  train_no = input_loop('поезд', $trains.size - 1)
  $trains[train_no].forward
end

def backward
  show_trains
  train_no = input_loop('поезд', $trains.size - 1)
  $trains[train_no].backward
end

$menu = {Станция: [], Маршрут: [], Поезд: []}
$menu[:Станция] << {title: 'Создать станцию', meth: :create_station}
$menu[:Станция] << {title: 'Показать список поездов на станции', meth: :trains_on_station}
$menu[:Станция] << {title: 'Показать список станций', meth: :show_stations}

$menu[:Маршрут] << {title: 'Создать Маршрут', meth: :create_route}
$menu[:Маршрут] << {title: 'Добавить станцию к маршруту', meth: :add_station_to_route}
$menu[:Маршрут] << {title: 'Убрать станцию с маршрута', meth: :rem_station_from_route}
$menu[:Маршрут] << {title: 'Показать список станций на маршруте', meth: :show_stations_on_route}
$menu[:Маршрут] << {title: 'Список Маршрутов', meth: :show_routes}

$menu[:Поезд] << {title: 'Создать', meth: :create_train}
$menu[:Поезд] << {title: 'Присвоить маршрут', meth: :assign_route}
$menu[:Поезд] << {title: 'Добавить вагоны', meth: :chain_wagon}
$menu[:Поезд] << {title: 'Отцепить вагоны', meth: :unchain_wagon}
$menu[:Поезд] << {title: 'Вперед по маршруту', meth: :forward}
$menu[:Поезд] << {title: 'Назад по маршруту', meth: :backward}
$menu[:Поезд] << {title: 'Показать список', meth: :show_trains}


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
#show_menu

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
