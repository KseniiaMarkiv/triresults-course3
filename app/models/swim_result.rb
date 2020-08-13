#Mongoid Inheritance
class SwimResult < LegResult #• define LegResult as a base class

  field :pace_100, type: Float 
#•  implement an instance method   
  def calc_ave
    if event && secs
      meters = event.meters
      self.pace_100=meters.nil? ? nil: secs/(meters/100)
    end
  end
end