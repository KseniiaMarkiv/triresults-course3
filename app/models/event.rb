class Event
  include Mongoid::Document
  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String  # единицы для обозначения м, км, ярд, миля

  embedded_in :parent, polymorphic: true, touch: true  
  
# have an instance method 
  def meters
    if self.u == 'meters'  # meter in meter
      self.distance
# 1 mile = 1609.344 meters
    elsif self.u == 'miles'  # meter in mile
      self.distance * 1609.34
# 1 kilometer = 1000 meters 
    elsif self.u == 'kilometers'  # meter in kilometer
      self.distance * 1000
# 1 yard = 0.9144 meters
    elsif self.u == 'yards'  # meter in yard
      self.distance * 0.9144
    end
  end
# have an instance method 
  def miles
# 1 meter = 0.000621371 miles
    if self.u == 'meters'
      self.distance * 0.000621371
    elsif self.u == 'miles'  # mile in mile
      self.distance
# 1 kilometer = 0.621371 miles
    elsif self.u == 'kilometers'
      self.distance * 0.621371
# 1 yard = 0.000568182 miles
    elsif self.u == 'yards'
      self.distance * 0.000568182
    end
  end

  validates_presence_of :order
  validates_presence_of :name # validates :name, presence: true
end
