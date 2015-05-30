class Similarity
  include Mongoid::Document
  field :company, type: String
  field :name, type: String

  validates_presence_of :company
  validates_presence_of :name

end
