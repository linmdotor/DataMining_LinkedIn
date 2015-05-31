class Index
  include Mongoid::Document
  field :company, type: String
  field :country, type: String
  field :url, type: String
end
