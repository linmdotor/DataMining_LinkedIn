class Index
  include Mongoid::Document
  field :company, type: String
  field :country, type: String
end
