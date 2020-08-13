# Mongoid Inheritance
class BikeResult < LegResult #• define LegResult as a base class
  
  field :mph, type: Float 
#•  implement an instance method   
  def calc_ave
    if event && secs
      miles = event.miles
      self.mph=miles.nil? ? nil: miles*3600/secs
    end
  end
end