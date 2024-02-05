load 'mroute.rb'
load 'mstation.rb'
load 'mtrain.rb'

def show(route)
  print '>>' * 7
  puts " Маршрут #{route.first.name} -- #{route.last.name} "
  route.stations.each(&:show_self)
  puts '<<' * 7
end

freig1 = Train.new('Сидор', :freight, 2)
pass1 = Train.new('Мария', :passenger, 3)

10.times { freig1.add_wagon }

10.times { freig1.accelerate }
freig1.add_wagon

station_mos = Station.new('Москва')
station_vlad = Station.new('Владивосток')
station_omsk = Station.new('Омск')
station_irk = Station.new('Иркутск')

route = Route.new(station_mos, station_vlad)

route << station_omsk
route << station_irk

pass1.set_route(route)
freig1.set_route(route)
show(route)

pass1.forward
pass1.forward
pass1.forward
pass1.backward

freig1.forward
show(route)

# route.remove_station(station_mos)
# route.remove_station(station_vlad)
# route.remove_station(station_irk)
route.remove_station(station_omsk)
show(route)
