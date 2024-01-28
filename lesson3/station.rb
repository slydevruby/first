# class Station
class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
    puts "Поезд <#{train.number}> прибыл на станцию <#{@name}>"
  end

  def remove_train(train)
    ind = @trains.index(train)
    if ind
      puts "Поезд <#{train.number}> отходит от станции <#{@name}>"
      @trains.delete_at(ind) 
    else
      raise "#{name} remove_train: not found train #{train.number}"
    end
  end

  def get_trains_count_by_type(type)
    total = 0
    @trains.each { |tr| total += 1 if tr.type == type }
    total
  end

  def show_self
    fcount = get_trains_count_by_type(:freight)
    pcount = get_trains_count_by_type(:passenger)
    
    if fcount + pcount != 0 
      puts "#{name}: Грузовых поездов: #{fcount}  Пассажирских поездов: #{pcount}"
      trains.each { |tr|   puts tr.show_self }
    else
      puts "#{name}: поездов нет"
    end
  end

end
