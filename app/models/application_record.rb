class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.ranks
    joins(:store_comments).distinct.
    select { |status| status.business_status == "営業中" }.sort_by do |store|
      ranks = store.store_comments
      ranks.present? ? ranks.map(&:rate).sum / ranks.size : 0
    end.reverse
  end

end