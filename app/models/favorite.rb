class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :store_comment
end
