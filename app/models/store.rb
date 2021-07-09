class Store < ApplicationRecord
  
  belongs_to :user, optional: true
  has_many :store_comments
  
  validates :store_name, presence: true
  validates :store_introduction, presence: true
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :transportation, presence: true
  validates :business_day, presence: true
  validates :holiday, presence: true
  
end
