class Skill
  include Mongoid::Document
  field :name, type: String
  validates_presence_of :name

  before_save :downcase

  has_and_belongs_to_many :users

	#This way is better, with the callback before_save
	def capitalize
		self.name.capitalize!
	end

	#Normalize the value of a string
	def downcase
		self.name.downcase!
	end

end
