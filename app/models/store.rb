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

  # 各ユーザーのランキング
  def self.my_ranks(user)
    left_joins(:store_comments).distinct.sort_by do |store|
      ranks = store.store_comments.select { |store| store.user_id == user.id }
      if ranks.present?
        ranks.map(&:rate).sum / ranks.size
      else
        0
      end
    end.reverse
  end

  # ジャンル別の新着順
  def self.new_arrival(genre)
    left_joins(:store_comments).where(store_comments: { genre: genre }).distinct.order(created_at: :DESC)
  end

  # ジャンル別のランキング
  def self.by_genre_ranks(genre)
    left_joins(:store_comments).where(store_comments: { genre: genre }).distinct.
    select { |status| status.business_status == "営業中" }.sort_by do |store|
        ranks = store.store_comments
        if ranks.present?
          ranks.map(&:rate).sum / ranks.size
        else
          0
        end
      end.reverse
  end

  # 画像がnilの場合は表示しない
  def image_choose(store_images)
      store_comments.each do |store_comment|
        if store_comment.product_image.present?
          store_images << store_comment
        end
      end
  end
end
