class Placing
  attr_accessor :name, :place

  def initialize(name, place)
    @name = name
    @place = Integer.demongoize(place)
  end

# point=Point.demongoize(:type=>"Point", :coordinates=>[-122.27,37.80])
# => #<Point:0x00000005696540 @longitude=-122.27, @latitude=37.8>

#{:name=>"(category name)" :place=>"(ordinal placing)"}

# 2.	Add an instance method  
  def mongoize
    { :name => @name, :place => @place }
  end
# 3.  Add a class method  
  def self.demongoize object 
    case object
    when nil then nil
	  when Placing then object.mongoize    	
    when Hash then
    # if object[:type] #in GeoJSON Point format 
      Placing.new(object[:name], object[:place]) #Integer.demongoize(object[:place])) #.mongoize - this is mistake
    # else
    #   Placing.new(object[:name], object[:state], object[nil]).mongoize #.mongoize - this is mistake
    # end
    else object
    end 
  end

# 4.  Add a class method 
  def self.mongoize object  
    case object
    when nil then nil
    when Placing then object.mongoize
    when Hash then 
      #if object[:type] #in GeoJSON Point format
      Placing.new(object[:name], object[:place]).mongoize
      #else       #in legacy format
      #    Point.new(object[:lng], object[:lat]).mongoize
      #end
    else object
    end
  end

# 5. Add a class method 
  def self.evolve object 
  	mongoize object
    # case object
    # when Placing then object.mongoize
    # else object
    # end 
  end 

end