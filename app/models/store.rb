class Store < ApplicationRecord

  belongs_to :user, optional: true
  has_many :store_comments

  validates :store_name, presence: true
  validates :menu, presence: true
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :transportation, presence: true
  validates :business_day, presence: true
  validates :holiday, presence: true
  # geocodeを適用するための記述
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

end