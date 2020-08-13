class Point
  attr_accessor :longitude, :latitude

  def initialize(lng, lat)
    @longitude = lng
    @latitude = lat
  end

# 2.  Add an instance method 
  def mongoize
    {:type=>'Point', :coordinates=>[@longitude,@latitude]}
  end

# 3.  Add a class method    
  def self.demongoize(object)
    case object
    when nil then nil
	  when Point then object.mongoize
    when Hash then 
		 	if object[:type] #in GeoJSON Point format
	      Point.new(object[:coordinates][0], object[:coordinates][1])#.mongoize  - problem is here
	    else       #in legacy format
		  	Point.new(object[:lng], object[:lat]).mongoize
		 	end
	  else object
    end
  end

# 4.  Add a class method 
  def self.mongoize(object) 
    case object
    when nil then nil
    when Point then object.mongoize
    when Hash then 
      if object[:type] #in GeoJSON Point format
          Point.new(object[:coordinates][0], object[:coordinates][1]).mongoize
      else       #in legacy format
          Point.new(object[:lng], object[:lat]).mongoize
      end
    else object
    end
  end

# 5. Add a class method 
  def self.evolve(object)
    case object
    when Point then object.mongoize
    else object
    end
  end

end