load 'station.rb'
load 'route.rb'
load 'train.rb'
load 'wagon.rb'

def input_loop(title, top)
  number = 0
  loop do
    puts "Выберите #{title} 0..#{top} по номеру"
    number = gets.chomp.to_i
    break if (0..top).include? number

    puts 'Такого номера нет. Повторим'
  end
  number
end

# Реализация текстового интерфейса для управления железной дорогой
class Main
  MENU = [
    { id: 1, title: 'Создать станцию', action: :create_station },
    { id: 2, title: '  Показать список поездов на станции', action: :trains_on_station },
    { id: 3, title: '  Показать список станций', action: :show_stations },

    { id: 4, title: 'Создать маршрут', action: :create_route },
    { id: 5, title: '  Добавить станцию к маршруту', action: :add_station_to_route },
    { id: 6, title: '  Удалить станцию из маршрута', action: :rem_station_from_route },
    { id: 7, title: '  Показать список маршрутов', action: :show_routes },

    { id: 8, title: 'Создать поезд', action: :create_train },
    { id: 9, title: '  Показать список поездов', action: :show_trains },
    { id: 10, title: '  Назначить маршрут', action: :assign_route },
    { id: 11, title: '  Прицепить вагон', action: :chain_wagon },
    { id: 12, title: '  Отцепить вагон', action: :unchain_wagon },
    { id: 13, title: '  Вперед по маршруту', action: :forward },
    { id: 14, title: '  Назад по маршруту', action: :backward },
    { id: 15, title: '  Занять место или объём в вагоне', action: :takeup_space_in_wagon }

  ].freeze

  HASH_TRAIN = { 0 => CargoTrain, 1 => PassengerTrain }.freeze

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def start
    loop do
      show_menu
      choice = gets.chomp.to_i
      break if choice.zero?

      process(choice)
    end
  end

  private

  def show_menu
    MENU.each do |item|
      puts "#{item[:id]}\t #{item[:title]}"
    end
    puts 'Введите номер команды, 0 для выхода'
  end

  def process(choice)
    puts "Вы выбрали #{choice}"
    sel = MENU.select { |item| item[:id] == choice }
    method(sel[0][:action]).call
  end

  def create_station
    print 'Введите имя станции: '
    name = gets.chomp
    station = Station.new(name)
    @stations << station
  end

  def show_stations
    puts "Всего станций: #{@stations.size}"
    @stations.each_with_index do |station, index|
      puts "  #{index}  Станция #{station.name}, поездов #{station.trains.size}"
    end
  end

  def show_routes
    puts "Всего маршрутов: #{@routes.size}"
    @routes.each_with_index do |route, index|
      puts "  #{index} Маршрут, Всего станции: #{route.stations.size}"
      route.stations.each { |st| puts "      Станция <#{st.name}>" } if route.stations.size.positive?
    end
  end

  def show_trains
    puts "Всего поездов: #{@trains.size}"
    @trains.each_with_index do |train, index|
      puts "  #{index} #{train.type} Поезд №#{train.number} <#{train.name}>, вагонов #{train.wagons.size}"
      puts "     находится на станции <#{train.current_station.name}>" if train.current_station
      train.each_wagon(&:show)
    end
  end

  def input_stations_for_route
    puts 'Выберите первую и последнюю станции по номеру, вводя их через пробел'
    first, second = gets.chomp.split(' ')
    first, second = [first, second].map(&:to_i)
    [first, second]
  end

  def create_route
    show_stations
    index = @stations.size
    if index < 2
      puts 'Маршрут создать нельзя, потому что станций нет или только одна.'
      return
    end
    indexes = input_stations_for_route

    @routes << Route.new(@stations[indexes.first], @stations[indexes.last])
  end

  def input_train_type
    type = 0
    loop do
      puts 'Введите тип поезда, 0 - грузовой, 1 - пассажирский'
      type = gets.chomp.to_i
      break if (0..1).include? type

      puts 'Неправильное число. Повторим'
    end
    type
  end

  def create_train
    puts 'Введите через пробел название поезда и номер поезда, формат XXX-YY, X - цифра или буква, дефис - необязателен'
    name, num = gets.chomp.split
    type = input_train_type
    train = HASH_TRAIN[type].new(name, num)
    puts "Создан поезд #{name}, с номером #{num}"
    @trains << train
  rescue StandardError
    puts 'Неправильный формат номера, повторим'
    retry
  end

  def select_obj(show_proc, object, title, plural_title)
    method(show_proc).call
    if object.size.positive?
      no = input_loop(title, object.size - 1)
      yield object[no]
    else
      puts "Нет #{plural_title}"
    end
  end

  def assign_route
    select_obj(:show_routes, @routes, 'маршрут', 'маршрутов') do |route|
      select_obj(:show_trains, @trains, 'поезд', 'поездов') do |train|
        train.assign_route(route)
      end
    end
  end

  def add_station_to_route
    select_obj(:show_routes, @routes, 'маршрут', 'маршрутов') do |route|
      select_obj(:show_stations, @stations, 'станция', 'станций') do |station|
        puts 'Добавляем станцию к маршруту'
        route << station
      end
    end
  end

  def rem_station_from_route
    select_obj(:show_routes, @routes, 'маршрут', 'маршрутов') do |route|
      if route.stations.size.positive?
        route.stations.each_with_index { |st, index| puts "#{index} #{st.name}" }
        puts 'Введите номер станции, которую нужно удалить'
        route.remove_station(route.stations[gets.chomp.to_i])
      end
    end
  end

  def trains_on_station
    select_obj(:show_stations, @stations, 'станция', 'станций') do |station|
      puts "На станции #{station.name} поездов: #{station.trains.size}"
      station.each_train { |tr| puts " Поезд №#{tr.number} тип #{tr.type}, вагонов: #{tr.wagons.size}" }
    end
  end

  def change_dir(direction)
    select_obj(:show_trains, @trains, 'поезд', 'поездов') do |train|
      if train.route
        train.method(direction).call
      else
        puts 'Машрут не присвоен'
      end
    end
  end

  def chain_wagon
    select_obj(:show_trains, @trains, 'поезд', 'поездов') do |train|
      if train.is_a? CargoTrain
        puts 'Введите общий объём вагона'
        train.add_wagon(CargoWagon.new(gets.chomp.to_i))
      else
        puts 'Введите общее количество мест'
        train.add_wagon(PassengerWagon.new(gets.chomp.to_i))
      end
    end
  end

  def unchain_wagon
    select_obj(:show_trains, @trains, 'поезд', 'поездов') do |train|
      if train.wagons.size.positive?
        show_wagons(train)
        wagon_no = input_loop('отцепляемый вагон', train.wagons.size - 1)
        train.wagons.delete_at(wagon_no)
      else
        puts 'Нет вагонов'
      end
    end
  end

  # занять место в вагоне №wagon_no поезда train
  def input_space(train, wagon_no)
    if train.is_a? CargoTrain
      puts 'Cколько объёма занять в этом вагоне?'
      train.wagons[wagon_no].occupy(gets.chomp.to_i)
    else
      train.wagons[wagon_no].occupy(1)
      puts 'Место занято'
    end
  rescue StandardError
    puts 'Слишком большое число, столько места нет, повторим'
    retry
  end

  # выбрать вагон в поезде train
  def takeup_space(train)
    train.each_wagon(&:show)
    wagon_no = input_loop('вагон', train.wagons.size - 1)
    if train.wagons[wagon_no].free.positive?
      input_space(train, wagon_no)
    else
      puts 'В этом вагоне всё занятo, попробуйте другой вагон'
    end
  end

  def takeup_space_in_wagon
    select_obj(:show_trains, @trains, 'поезд', 'поездов') do |train|
      if train.wagons.size.positive?
        takeup_space(train)
      else
        puts 'Нет вагонов'
      end
    end
  end

  def forward
    change_dir(:forward)
  end

  def backward
    change_dir(:backward)
  end
end

main = Main.new
main.start
