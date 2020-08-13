class RacerInfo
  include Mongoid::Document

  field :racer_id, as: :_id
  field :_id, default: -> { racer_id }

  field :fn, as: :first_name, type: String
  field :ln, as: :last_name, type: String
  field :g, as: :gender, type: String
  field :yr, as: :birth_year, type: Integer
  field :res, as: :residence, type: Address

  embedded_in :parent, polymorphic: true

  validates_presence_of :first_name
	validates_presence_of :last_name
#	validates gender_name is present and has values M or F
	validates :gender, inclusion: { in: [ 'M', 'F' ], message: 'must be M or F' }, presence: true
# validates birth_year is present and has value in the past
	validates :birth_year, numericality: { less_than: Time.now.year, message: 'must be in the past'}, presence: true

      # def city # Getter обрабатывает случай (case), когда residence равно nil
      #   self.residence ? self.residence.city : nil
      # end
      # # setter обязательно выполняет массовое назначение, 
      # # используя экземпляр, инициализированный с текущими значениями (Address.new)
      # def city= name
      #   object=self.residence ||= Address.new 
      #   object.city=name 
      #   self.residence=object
      # end
# define_method объявляет блок кода, который определяет конкретный метод, 
# и этот метод может опционально принять параметры (например, do | action |)
  ["city", "state"].each do |action| 
    define_method("#{action}") do
      self.residence ? self.residence.send("#{action}") : nil
    end
    define_method("#{action}=") do |name| 
      object=self.residence ||= Address.new 
      object.send("#{action}=", name) 
      self.residence=object
    end 
  end

# object.send («m», 123) вызывает метод («m») для объекта и 
# может при желании передавать параметры этому методу (например, 123)
  # - так же, как name and name=(param) являются геттерами и сеттерами для 
  # name – object.send("name") and object.send("name=", value) также являются методами геттерами и сеттерами, 
  # которые могут динамически обращаться к объектным методам без знания типа заранее.

  


end
