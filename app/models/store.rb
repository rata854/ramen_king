class Store < ApplicationRecord

  belongs_to :user, optional: true
  has_many :store_comments

  validates :store_name, presence: true, length: { maximum: 15 }
  validates :menu, presence: true
  validates :postal_code, presence: true, numericality: { only_integer: true }, length: { is: 7 }
  validates :address, presence: true
  validates :transportation, presence: true
  validates :business_day, presence: true
  validates :holiday, presence: true
  # geocodeを適用するための記述
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

end