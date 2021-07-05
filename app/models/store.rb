class Store < ApplicationRecord
  
  belongs_to :user, optional: true
  has_many :store_comments
  
end
