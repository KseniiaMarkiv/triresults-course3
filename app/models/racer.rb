class Racer
  include Mongoid::Document

  embeds_one :info, as: :parent, class_name: 'RacerInfo', autobuild: true 
  has_many :races, class_name: 'Entrant', :foreign_key => "racer.racer_id", dependent: :nullify, order: :"race.date".desc
 
# assign the local id primary key to the info.id property
  before_create {|racer| racer.info.id = racer.id}

# это мы устанавливаем сразу методы геттер и сеттер

# •	expose info.first_name as first_name
delegate :first_name, :first_name=, to: :info
# •	expose info.last_name as last_name
delegate :last_name, :last_name=, to: :info
# •	expose info.gender as gender
delegate :gender, :gender=, to: :info
# •	expose info.birth_year as birth_year
delegate :birth_year, :birth_year=, to: :info
# •	expose info.residence.city as city
delegate :city, :city=, to: :info
# •	expose info.residence.state as state
delegate :state, :state=, to: :info

# пример
# irb(main):015:0> racer.last_name
# => "two"
# irb(main):016:0> racer.last_name="three"
# => "three"
# irb(main):017:0> racer.last_name
# => "three"




end
