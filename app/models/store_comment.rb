class StoreComment < ApplicationRecord
  
  belongs_to :user
  belongs_to :store, optional: true
  attachment :product_image
  enum genre: {しょうゆ: 0, みそ: 1, とんこつ: 2, しお: 3}
end
