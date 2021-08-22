class StoreComment < ApplicationRecord
  belongs_to :user
  belongs_to :store
  has_many :favorites, dependent: :destroy

  attachment :product_image
  enum genre: { 総合: 0, しょうゆ: 1, みそ: 2, とんこつ: 3, しお: 4 }

  validates :title, presence: true, length: { maximum: 50 }
  validates :introduction, presence: true, length: { maximum: 2000 }
  validates :rate, presence: true
  validates :genre, presence: true
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
end
