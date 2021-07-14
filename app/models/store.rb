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
  
  def self.sort(selection)
    case selection
    when 'new'
      return all.order(created_at: :DESC)
    when 'ranking'
      return  Store.left_joins(:store_comments).distinct.sort_by do |store|
                ranks = store.store_comments
                    if ranks.present?
                      ranks.map(&:rate).sum / ranks.size
                    else
                      0
                    end
              end.reverse
    end
  end
  
end