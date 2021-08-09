class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.ranks
    joins(:store_comments).distinct.
    select { |status| status.business_status == "営業中" }..sort_by do |store|
      ranks = store.store_comments
      # 三項演算子
      if ranks.present?
        ranks.map(&:rate).sum / ranks.size
      else
        0
      end
    end.reverse
  end

end