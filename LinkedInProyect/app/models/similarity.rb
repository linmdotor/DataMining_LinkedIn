class Similarity
  include Mongoid::Document
  field :company, type: String
  field :url, type: String

  validates_presence_of :company
  validates_presence_of :url

end
