class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.ranks
    left_joins(:store_comments).distinct.sort_by do |store|
      ranks = store.store_comments
      if ranks.present?
        ranks.map(&:rate).sum / ranks.size
      else
        0
      end
    end.reverse
  end

end
