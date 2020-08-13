class Address
  attr_accessor :city, :state, :location

  def initialize(city=nil, state=nil, location=nil)
    @city = city
    @state = state
    # provide read/write access to a location field of type Point mapped to the document key of loc
    @location = location
  end

# point=Point.demongoize(:type=>"Point", :coordinates=>[-122.27,37.80])
# => #<Point:0x00000005696540 @longitude=-122.27, @latitude=37.8>

#{:city=>"(city)", :state=>"(state)", :loc=>(point)}

# 2.	Add an instance method 
  def mongoize
    {
      :city => @city, :state => @state, :loc => @location.mongoize 
      # {
      #   :type => 'Point', :coordinates => [
      #     @location.longitude, @location.latitude # :loc=>(point)
      #   ]
      # }
    }
  end
# 3.  Add a class method  
  def self.demongoize object 
    case object
    when nil then nil
	  when Address then object.mongoize    	
    when Hash then
    # if object[:type] #in GeoJSON Point format 
      Address.new(object[:city], object[:state], Point.demongoize(object[:loc]))#Point.demongoize(object[:loc])) #.mongoize - this is mistake
    # else
    #   Address.new(object[:city], object[:state], object[nil]).mongoize #.mongoize - this is mistake
    # end
    else object
    end 
  end

# 4.  Add a class method 
  def self.mongoize object  
    case object
    when nil then nil
    when Address then object.mongoize
    when Hash then 
      #if object[:type] #in GeoJSON Point format
      Address.new(object[:city], object[:state], object[:loc]).mongoize
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
    # when Address then object.mongoize
    # else object
    # end 
  end 

end