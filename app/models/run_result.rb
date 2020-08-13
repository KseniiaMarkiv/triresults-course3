#Mongoid Inheritance
class RunResult < LegResult # define LegResult as a base class
  
  field :mmile, as: :minute_mile, type: Float 
#•  implement an instance method   
  def calc_ave
    if event && secs
      miles = event.miles
      self.mmile=miles.nil? ? nil: (secs/60)/miles
#рассчитать время, которое потребуется бегуну, чтобы проехать 1 милю 
#с учетом расстояния события и времени, которое потребовалось для его 
#завершения
    end
  end
end