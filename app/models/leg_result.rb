class LegResult
  include Mongoid::Document

  field :secs, type: Float

  embedded_in :entrant, class_name: "Entrant"
  embeds_one :event, as: :parent

  validates_presence_of :event

  def calc_ave
		#subclasses will calc event-specific ave
	end
	after_initialize {|doc| doc.calc_ave}

	# after_initialize do |doc| 
	# 	doc.calc_ave
	# end

	def secs= value
		# рассчитанных после того, как он самостоятельно обновил self[:secs] 
		self[:secs] = value  # с предоставленным значением
    calc_ave # переопределить метод secs=, чтобы он вызывал calc_ave для обновления средних значений
	end
end
