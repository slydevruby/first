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
    puts "  #{index} Маршрут, Всего станции: #{route.stations.size}"
    if route.stations.size.positive? 
      route.stations.each { |st| puts "      Станция <#{st.name}>" }
    end
  end
end

def show_trains
  puts "Всего поездов: #{$trains.size}"
  $trains.each_with_index do |train, index|
    puts "  #{index} #{train.type} Поезд <#{train.name}>, вагонов #{train.wagons.size}"
    if train.current_station
      puts "     находится на станции <#{train.current_station.name}>" 
    end
  end
end

def create_route
  show_stations
  index = $stations.size
  if index < 2 
    puts "Маршрут создать нельзя, потому что станций нет или только одна."
    return
  end
  first = 0
  second = 1
  loop do
    puts "Выберите первую и последнюю станции 0..#{index-1} по номеру, вводя их через пробел"
    first, second = gets.chomp.split(' ')
    first, second = [first, second].map(&:to_i)
    if first == second 
      puts 'Станции должны быть разными. Повторим'
    elsif !(0..index-1).include? first
      puts 'Такого номера станции нет. Повторим'
    elsif !(0..index-1).include? second
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
  show_routes
  if $routes.size.positive?
    route_no = input_loop('маршрут', $routes.size - 1) 
    show_trains
    if $trains.size.positive?
      train_no = input_loop('поезд', $trains.size - 1)
      $trains[train_no].assign_route($routes[route_no])
    else
      puts "Нет поездов"
    end
  else
    puts "Нет маршрутов"
  end
end

def add_station_to_route
  show_routes
  if $routes.size.positive?
    route_number = input_loop('маршрут', $routes.size - 1)
    show_stations
    if $stations.size.positive?
      station_number = input_loop('станцию', $stations.size - 1)
      puts 'Добавляем станцию к маршруту'
      $routes[route_number] << $stations[station_number]
    else
      puts "Нет станций"
    end
  else
    puts "Нет маршрутов"
  end
end

def rem_station_from_route
  show_routes
  if $routes.size.positive?
    route_number = input_loop('маршрут', $routes.size - 1)
    
    route = $routes[route_number]
    list = []
    if route.stations.size.positive?
      route.stations.each_with_index do |st, index|
        puts "#{index} #{st.name}"
        list << index
      end
      no = 0
      loop do
        puts "Введите номер станции, которую нужно удалить (первую и последнюю удалить нельзя)"
        no = gets.chomp.to_i
        break if list.include? no
        puts "Такого номера нет. Повторим"          
      end
      #route.stations.delete_at(no)
      route.remove_station(route.stations[no])
    else
      puts "Нет станций"
    end
  else
    puts "Нет маршрутов"
  end  
end

def create_train
  puts "Введите название поезда"
  name = gets.chomp
  type = 0
  loop do
    puts "Введите тип поезда, 0 - грузовой, 1 - пассажирский"
    type = gets.chomp.to_i
    break if (0..1).include? type 
    puts "Неправильное число. Повторим" 
  end
  if type == 0 
    train = CargoTrain.new(name)
  else 
    train = PassengerTrain.new(name)
  end
  $trains << train
end

def trains_on_station
  show_stations
  if $stations.size.positive? 
    no = input_loop('станцию', $stations.size - 1)
    puts "На станции #{$stations[no].name} поездов: #{$stations[no].trains.size}"
    $stations[no].trains.each { |tr|  puts "  #{tr.type} Поезд #{tr.name}"  }
  else
    puts "Нет станций"
  end
end

#def show_stations_on_route
#  show_routes
#  if $routes.size.positive? 
#    route_number = input_loop('маршрут', $routes.size - 1)
#    $routes[route_number].stations.each { |station| puts "  Станция #{station.name}" }
#  else
#    puts "Нет маршрутов"
#  end
#end

def chain_wagon
  show_trains
  if $trains.size.positive? 
    train_no = input_loop('поезд', $trains.size - 1)  
    if $trains[train_no].is_a? CargoTrain
      $trains[train_no].add_wagon(CargoWagon.new)
    else
      $trains[train_no].add_wagon(PassengerWagon.new)
    end
  else
    puts "Нет поездов"
  end
end

def unchain_wagon
  show_trains
  if $trains.size.positive?
    train_no = input_loop('поезд', $trains.size - 1)
    if $trains[train_no].wagons.size.positive?
      $trains[train_no].wagons.delete($trains[train_no].wagons.last)
    else
      puts "Нет вагонов"
    end
  else
    puts "Нет поездов"
  end
end

def change_dir(direction)
  show_trains
  if $trains.size.positive?
    train_no = input_loop('поезд', $trains.size - 1)
    if $trains[train_no].route
      $trains[train_no].method(direction).call
    else
      puts "Машрут не присвоен"
    end  
  else
    puts "Нет поездов"
  end
end

def forward
  change_dir(:forward)
end

def backward
  change_dir(:backward)
end

$menu = {Станция: [], Маршрут: [], Поезд: []}
$menu[:Станция] << {title: 'Создать станцию', meth: :create_station}
$menu[:Станция] << {title: 'Показать список поездов на станции', meth: :trains_on_station}
$menu[:Станция] << {title: 'Показать список всех станций', meth: :show_stations}

$menu[:Маршрут] << {title: 'Создать Маршрут', meth: :create_route}
$menu[:Маршрут] << {title: 'Добавить станцию к маршруту', meth: :add_station_to_route}
$menu[:Маршрут] << {title: 'Убрать станцию с маршрута', meth: :rem_station_from_route}
#$menu[:Маршрут] << {title: 'Показать список станций на маршруте', meth: :show_stations_on_route}
$menu[:Маршрут] << {title: 'Список Маршрутов', meth: :show_routes}

$menu[:Поезд] << {title: 'Создать поезд', meth: :create_train}
$menu[:Поезд] << {title: 'Присвоить маршрут', meth: :assign_route}
$menu[:Поезд] << {title: 'Добавить вагоны', meth: :chain_wagon}
$menu[:Поезд] << {title: 'Отцепить вагоны', meth: :unchain_wagon}
$menu[:Поезд] << {title: 'Вперед по маршруту', meth: :forward}
$menu[:Поезд] << {title: 'Назад по маршруту', meth: :backward}
$menu[:Поезд] << {title: 'Показать список всех поездов', meth: :show_trains}


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