class Skill
  include Mongoid::Document
  field :name, type: String
  validates_presence_of :name

  has_and_belongs_to_many :users
end
