class Store < ApplicationRecord
  belongs_to :user, optional: true
  has_many :store_comments

  enum business_status: { 営業中: 0, 休業中: 1, 閉店: 2 }
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

  # 総合ランキング(5件以上のコメントでランクイン)
  def self.store_ranking
    find(StoreComment.group(:store_id).order('avg(rate) desc').pluck(:store_id)).
    select { |store| store.business_status == "営業中" && store.store_comments.count >= 5 }
  end

  # ジャンル別ランキング
  def self.ranking_by_genre(genre)
    find(StoreComment.where(store_comments: { genre: genre }).group(:store_id).order('avg(rate) desc').pluck(:store_id)).
    select { |store| store.business_status == "営業中" }
  end

  # ユーザー別ランキング
  def self.my_ranks(user)
    find(StoreComment.where(store_comments: { user_id: user.id }).group(:store_id).order('avg(rate) desc').pluck(:store_id)).
    select { |store| store.business_status == "営業中" }
  end

  # ジャンル別の新着順
  def self.new_arrival(genre)
    left_joins(:store_comments).where(store_comments: { genre: genre }).distinct.order(created_at: :DESC)
  end

end
