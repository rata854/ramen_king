class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :stores
  has_many :store_comments, dependent: :destroy
  attachment :profile_image

  validates :name, presence: true, length: { maximum: 15, minimum: 2 }, uniqueness: true
  validates :introduction, length: { maximum: 100 }

  # def self.my_ranks(user)
  #   left_joins(:store_comments).distinct.sort_by do |store|
  #     ranks = store.store_comments.select { |store| store.user_id == user.id }
  #     if ranks.present?
  #       ranks.map(&:rate).sum / ranks.size
  #     else
  #       0
  #     end
  #   end.reverse
  # end

end