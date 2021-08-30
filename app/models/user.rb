class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :stores
  has_many :store_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  attachment :profile_image

  validates :name, presence: true, length: { maximum: 15, minimum: 2 }, uniqueness: true
  validates :email, presence: true, length: { maximum: 255 }
  validates :introduction, length: { maximum: 100 }

end