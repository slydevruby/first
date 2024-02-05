load 'station.rb'
load 'route.rb'
load 'train.rb'
load 'wagon.rb'

class Main
  MENU = [
    { id: 1, title: "Создать станцию", action: :create_station },
    { id: 2, title: "Показать список поездов на станции", action: :trains_on_station },
    { id: 3, title: "Показать список станций", action: :show_stations },

    { id: 4, title: "Создать маршрут", action: :create_route },
    { id: 5, title: "Добавить станцию к маршруту", action: :add_station_to_route },
    { id: 6, title: "Показать список маршрутов", action: :show_routes },

    { id: 7, title: "Создать поезд", action: :create_train },
    { id: 8, title: "Показать список поездов", action: :show_trains },
    { id: 9, title: "Назначить маршрут", action: :assign_route },
    { id: 10, title: "Прицепить вагон", action: :chain_wagon },
    { id: 11, title: "Отцепить вагон", action: :unchain_wagon },
    { id: 12, title: "Вперед по маршруту", action: :forward },
    { id: 13, title: "Назад по маршруту", action: :backward },
    { id: 14, title: "Занять место или объём в вагоне", action: :occupy_wagon }

    
  ]

  def initialize
    @stations = []
    @trains = []
    @routes = []

  end

  def start
    loop do 
      show_menu
      choice = get_choice
      break if choice.zero? 
      process(choice)
    end
  end

  private

  def show_menu
    MENU.each do |item|
      puts "#{item[:id]}\t #{item[:title]}"
    end
    puts "Введите номер команды, 0 для выхода"
  end

  def get_choice
    gets.chomp.to_i
  end

  def process(choice)
    puts "Вы выбрали #{choice}"
    item = MENU.select { |item| item[:id] == choice }
    method(item[0][:action]).call
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
      puts "  #{index} #{train.type} Поезд <#{train.name}>, вагонов #{train.wagons.size}"
      puts "     находится на станции <#{train.current_station.name}>" if train.current_station
      train.each_wagon do |wag| 
        print "     Вагон "
        if wag.is_a? CargoWagon
          puts "грузовой, общий объём #{wag.max_volume}, занято #{wag.taken_volume}"\
          " свободно #{wag.max_volume - wag.taken_volume}"
        else
          puts "пассажирский, общее количество мест #{wag.max_places}, занято #{wag.taken_places}"\
          " свободно #{wag.max_places - wag.taken_places}"
        end
      end
    end
  end

  def create_route
    show_stations
    index = @stations.size
    if index < 2
      puts 'Маршрут создать нельзя, потому что станций нет или только одна.'
      return
    end
    first = 0
    second = 1
    loop do
      puts "Выберите первую и последнюю станции 0..#{index - 1} по номеру, вводя их через пробел"
      first, second = gets.chomp.split(' ')
      first, second = [first, second].map(&:to_i)
      if first == second
        puts 'Станции должны быть разными. Повторим'
      elsif !(0..index - 1).include? first
        puts 'Такого номера станции нет. Повторим'
      elsif !(0..index - 1).include? second
        puts 'Такого номера станции нет. Повторим'
      else
        break
      end
    end
    @routes << Route.new(@stations[first], @stations[second])
  end

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

  def assign_route
    show_routes
    if @routes.size.positive?
      route_no = input_loop('маршрут', @routes.size - 1)
      show_trains
      if @trains.size.positive?
        train_no = input_loop('поезд', @trains.size - 1)
        @trains[train_no].assign_route(@routes[route_no])
      else
        puts 'Нет поездов'
      end
    else
      puts 'Нет маршрутов'
    end
  end

  def add_station_to_route
    show_routes
    if @routes.size.positive?
      route_number = input_loop('маршрут', @routes.size - 1)
      show_stations
      if @stations.size.positive?
        station_number = input_loop('станцию', @stations.size - 1)
        puts 'Добавляем станцию к маршруту'
        @routes[route_number] << @stations[station_number]
      else
        puts 'Нет станций'
      end
    else
      puts 'Нет маршрутов'
    end
  end

  def rem_station_from_route
    show_routes
    if @routes.size.positive?
      route_number = input_loop('маршрут', @routes.size - 1)

      route = @routes[route_number]
      list = []
      if route.stations.size.positive?
        route.stations.each_with_index do |st, index|
          puts "#{index} #{st.name}"
          list << index
        end
        no = 0
        loop do
          puts 'Введите номер станции, которую нужно удалить (первую и последнюю удалить нельзя)'
          no = gets.chomp.to_i
          break if list.include? no

          puts 'Такого номера нет. Повторим'
        end
        # route.stations.delete_at(no)
        route.remove_station(route.stations[no])
      else
        puts 'Нет станций'
      end
    else
      puts 'Нет маршрутов'
    end
  end

  def create_train
    puts 'Введите название поезда'
    name = gets.chomp
    type = 0
    loop do
      puts 'Введите тип поезда, 0 - грузовой, 1 - пассажирский'
      type = gets.chomp.to_i
      break if (0..1).include? type

      puts 'Неправильное число. Повторим'
    end
  
    begin
      puts 'Введите номер поезда, формат XXX-YY, X - цифра или буква, дефис - необязателен'            
      train = if type.zero?
              CargoTrain.new(name, gets.chomp)
            else
              PassengerTrain.new(name, gets.chomp)
            end        
      @trains << train
      puts "Создан поезд #{name}, с номером #{train.number}"
    rescue
      puts "Неправильный формат номера, повторим"
      retry
    end    
  end

  def trains_on_station
    show_stations
    if @stations.size.positive?
      no = input_loop('станцию', @stations.size - 1)
      puts "На станции #{@stations[no].name} поездов: #{@stations[no].trains.size}"
      @stations[no].each_train { |tr| puts " Поезд №#{tr.number} тип #{tr.type}, вагонов: #{tr.wagons.size}" }
    else
      puts 'Нет станций'
    end
  end

  def chain_wagon
    show_trains
    if @trains.size.positive?
      train_no = input_loop('поезд', @trains.size - 1)
      if @trains[train_no].is_a? CargoTrain
        puts "Введите общий объём вагона"
        max_vol = gets.chomp.to_i
        @trains[train_no].add_wagon(CargoWagon.new(max_vol))
      else
        puts "Введите количество мест"
        max_places = gets.chomp.to_i
        @trains[train_no].add_wagon(PassengerWagon.new(max_places))
      end
    else
      puts 'Нет поездов'
    end
  end

  def unchain_wagon
    show_trains
    if @trains.size.positive?
      train_no = input_loop('поезд', @trains.size - 1)
      train = @trains[train_no]
      if train.wagons.size.positive?
        index = 0
        train.each_wagon do |wagon| 
          puts "  Вагон #{index}" 
          index += 1
        end        
        wagon_no = input_loop('отцепляемый вагон', train.wagons.size - 1)        
        train.wagons.delete_at(wagon_no)
      else
        puts 'Нет вагонов'
      end
    else
      puts 'Нет поездов'
    end
  end

  def change_dir(direction)
    show_trains
    if @trains.size.positive?
      train_no = input_loop('поезд', @trains.size - 1)
      if @trains[train_no].route
        @trains[train_no].method(direction).call
      else
        puts 'Машрут не присвоен'
      end
    else
      puts 'Нет поездов'
    end
  end

  def take_volume(train)
    index = 0
    train.each_wagon do |wagon| 
      puts "  Вагон #{index}, свободно: #{wagon.get_free_volume}" 
      index += 1
    end
    wagon_no = input_loop('вагон', train.wagons.size - 1)
    if train.wagons[wagon_no].get_free_volume > 0
      begin
        puts "Cколько объёма занять в этом вагоне?"
        value = gets.chomp.to_i
        train.wagons[wagon_no].take_volume(value)    
      rescue
        puts "Слишком большое число, столько места нет, повторим"
        retry
      end  
    else
      puts "В этом вагоне всё занятo. Попробуйте другой вагон"
    end
  end

  def take_place(train)
    index = 0
    train.each_wagon do |wagon| 
      puts "  Вагон #{index}, свободно: #{wagon.get_free_places}" 
      index += 1
    end
    wagon_no = input_loop('вагон', train.wagons.size - 1)
    if train.wagons[wagon_no].get_free_places > 0 
      begin
        train.wagons[wagon_no].take_place
        puts "Место занято"
      rescue
        puts "Все места заняты, попробуйте другой вагон"
      end
    else 
      puts "В этом вагоне всё занятo, попробуйте другой вагон"
    end
  end  

  def occupy_wagon
    show_trains
    if @trains.size.positive?
      train_no = input_loop('поезд', @trains.size - 1)
      train = @trains[train_no]
      if train.wagons.size.positive?
        if train.is_a? CargoTrain
          take_volume(train)
        elsif train.is_a? PassengerTrain
          take_place(train)
        end
      else
        puts 'Нет вагонов'
      end
    else
      puts 'Нет поездов'
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
