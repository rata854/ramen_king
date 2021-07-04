class StoreComment < ApplicationRecord
  
  belongs_to :user
  belongs_to :store
  attachment :product_image
end
