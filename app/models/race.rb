class Race
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :n, as: :name, type: String
  field :date, as: :date, type: Date
  field :loc, as: :location, type: Address
  field :next_bib, type: Integer, default: ->{ 0 } # assign a default value at document creation time and not instance creation time 

  embeds_many :events,  as: :parent, class_name: "Event", order: [:order.asc] # define the embeds_many with a default ASCENDING sort order based on the order field
  has_many :entrants, :foreign_key => "race._id", dependent: :delete, order: [:secs.asc, :bib.asc]

  scope :upcoming, ->{ where(:date.gte=>Date.current) }
  scope :past, ->{ where(:date.lt=>Date.current) }

# •	have properties called swim_order, swim_distance, and swim_units that default to 0, 1, and “miles”
DEFAULT_EVENTS = {"swim"=>{:order=>0, :name=>"swim", :distance=>1.0, :units=>"miles"}, 
# •	have a property called t1_order that defaults to 1
									"t1"=>	{:order=>1, :name=>"t1"},
# •	have properties called bike_order, bike_distance, and bike_units that default to 2, 25, and “miles”
									"bike"=>{:order=>2, :name=>"bike", :distance=>25.0, :units=>"miles"}, 
# •	have a property called t2_order that defaults to 3
									"t2"=>	{:order=>3, :name=>"t2"},
# •	have properties called run_order, run_distance, and run_units that default to 4, 10, and “kilometers”
									"run"=> {:order=>4, :name=>"run", :distance=>10.0, :units=>"kilometers"}}


# •	have the ability to get and set each of the above event properties

	DEFAULT_EVENTS.keys.each do |name|
		define_method("#{name}") do
			event=events.select {|event| name==event.name}.first
			event||=events.build(DEFAULT_EVENTS["#{name}"])
		end
		["order","distance","units"].each do |prop|
			if DEFAULT_EVENTS["#{name}"][prop.to_sym]
				define_method("#{name}_#{prop}") do
					event=self.send("#{name}").send("#{prop}")
			end
				define_method("#{name}_#{prop}=") do |value|
					event=self.send("#{name}").send("#{prop}=", value)
				end
			end
		end
	end

# Hint: Your solution might use explicit methods written using brute force for each event and property.
# 	def swim
# 		event=events.select {|event| "swim"==event.name}.first
# 		event||=events.build(DEFAULT_EVENTS["swim"])
# 	end
# 	def swim_order
# 		swim.order
# 	end
# 	def swim_distance
# 		swim.distance
# 	end
# 	def swim_units
# 		swim.units
# 	end

# •	have a class method called default that returns a default instance of Race with the above properties
	def self.default
		Race.new do |race|
			DEFAULT_EVENTS.keys.each {|leg|race.send("#{leg}")}
		end
	end

	["city", "state"].each do |action| 
		define_method("#{action}") do
			self.location ? self.location.send("#{action}") : nil
	end
		define_method("#{action}=") do |name| 
			object=self.location ||= Address.new 
			object.send("#{action}=", name) 
			self.location=object
	end
	end
	# # •	expose location.city as city
	# delegate :city, :city=, to: :location - НЕ ПОДХОДИТ!!!
	# # •	expose location.state as state 
	# delegate :state, :state=, to: :location  - НЕ ПОДХОДИТ!!!
	
	# def city= name   ЭТО НАХОДИТЬСЯ В class RacerInfo https://www.coursera.org/learn/ruby-on-rails-web-services-mongodb/programming/XFOOW/mongoid-and-rails-scaffold/discussions/threads/kz_xFdYQEeW01g7o8S6alw
	#     object=self.residence ||= Address.new  #obtain current state
	#     object.city=name                       #update the state
	#     self.residence=object                  #set entire object
	# end
	
	# def next_bib
	# 	[:key].inc(:next_bib, 1)
	# end

	def next_bib  # override the getter for next_bib
		self.inc(next_bib: 1) # atomic increment
    self[:next_bib] # return the result of next_bib
# use [:key] to access the current value of the attribute to avoid an infinite loop within next_bib.
  end
# Implement an instance method 
# они разделили возраст на 10, чтобы получить результат от 0 до 9
	def get_group racer
		if racer && racer.birth_year && racer.gender # определить возраст гонщика на 01 января года гонки
# поместите гонщика в группу, округленную до ближайших 10 и округленную до ближайших 9
			quotient=(date.year-racer.birth_year)/10 
			min_age=quotient*10 
			max_age=((quotient+1)*10)-1 
			gender=racer.gender
			name=min_age >= 60 ? "masters #{gender}" : "#{min_age} to #{max_age} (#{gender})"
			Placing.demongoize(:name=>name)
		end
	end

# Implement instance method 

		# Entrant.new
		# race.attributes.symbolize_keys.slice(:_id, :n, :date)
		# racer.info.attributes
		# get_group(racer)
		# entrant.send("#{event.name}=", event)
		# entrant.validate
		# next_bib
		# return the Entrant

	def create_entrant racer 
    	Entrant.new do |entrant|
# build_race from this - rspec spec/race_results_spec.rb -e rq02
      entrant.build_race(attributes.symbolize_keys.slice(:_id, :n, :date))
# build_racer from this - rspec spec/racer_results_spec.rb -e rq01
      entrant.build_racer(racer.info.attributes)
# 101	def get_group racer 
      entrant.group = get_group(racer)
      events.each { |event| entrant.send("#{event.name}=", event) }

      if entrant.validate
        entrant.bib = next_bib
        entrant.save
      end
    end
  end

# 5.	Implement class method •	be a class method in Race
	def self.upcoming_available_to racer
		registered_race_ids = racer.races.upcoming.pluck("race._id").map { |race| race[:_id] }
    	self.upcoming.nin(id: registered_race_ids)
	end


end
