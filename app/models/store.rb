class Store < ApplicationRecord
  
  belongs_to :user
  has_many :store_comments
  
end
