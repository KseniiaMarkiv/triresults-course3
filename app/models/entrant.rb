class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "results"

  embeds_many :results, class_name: 'LegResult', order: [:"event.o".asc], after_add: :update_total
  embeds_one :race, class_name: 'RaceRef', autobuild: true
  embeds_one :racer, as: :parent, class_name: 'RacerInfo', autobuild: true

  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing

  scope :upcoming, ->{ where(:"race.date".gte=>Date.current) }
  scope :past, ->{ where(:"race.date".lt=>Date.current) }


  def update_total(result)
    self.secs = results.reduce(0) do |total, result|
  		total + result.secs.to_i
  	end
  end
# define a custom getter
  def the_race
    race.race
  end

# •	expose racer.first_name as first_name
# •	expose racer.last_name as last_name
# •	expose racer.gender as racer_gender (Hint: note the prefix)
# •	expose racer.birth_year as birth_year
# •	expose racer.residence.city as city
# •	expose racer.residence.state as state
# •	expose race.name as race_name
# •	expose race.date as race_date
	delegate :first_name, :first_name=, to: :racer 
	delegate :last_name, :last_name=, to: :racer
	delegate :gender, :gender=, to: :racer, prefix: "racer" 
	delegate :birth_year, :birth_year=, to: :racer
	delegate :city, :city=, to: :racer 
	delegate :state, :state=, to: :racer
	delegate :name, :name=, to: :race, prefix: "race" 
	delegate :date, :date=, to: :race, prefix: "race"

# •	expose group.name as group_name and returning nil if group does not exist
# •	expose group.place as group_place and returning nil if group does not exist
# •	expose overall.place as overall_place and returning nil if overall does not exist
# •	expose gender.place as gender_place and returning nil if gender does not exist

# делегирование nil проверки пользовательским классам было бы проще всего реализовать 
# с помощью набора пользовательских методов доступа.
	def overall_place 
		overall.place if overall
	end
	def gender_place 
		gender.place if gender
	end
	def group_name 
		group.name if group
	end
	def group_place 
		group.place if group
	end

	RESULTS = {"swim"=>SwimResult,
						"t1"=>LegResult, "bike"=>BikeResult, 
						"t2"=>LegResult, "run"=>RunResult}

	RESULTS.keys.each do |name|
	#create_or_find result
		define_method("#{name}") do
			result=results.select {|result| name==result.event.name if result.event}.first
			if !result 
				result=RESULTS["#{name}"].new(:event=>{:name=>name}) 
				results << result
			end
			result
		end
	#assign event details to result присваивает детали события результату, ПОСЛЕ СОХРАНЕНИЯ или СОЗДАНИЯ (из предыдущего шага)
		define_method("#{name}=") do  |event| 
			event=self.send("#{name}").build_event(event.attributes)
		end
	#expose setter/getter for each property of each result представляем метод геттер/сеттер для каждого атрибута в результе
		RESULTS["#{name}"].attribute_names.reject {|r|/^_/===r}.each do |prop|
			define_method("#{name}_#{prop}") do
				event=self.send(name).send(prop)
			end
			define_method("#{name}_#{prop}=") do |value|
				event=self.send(name).send("#{prop}=",value)
				update_total nil if /secs/===prop
				end
			end
	end

end

