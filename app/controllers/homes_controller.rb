class HomesController < ApplicationController

  def top
      @stores = Store.left_joins(:store_comments).distinct.sort_by do |store|
                    ranks = store.store_comments
                    if ranks.present?
                      ranks.map(&:rate).sum / ranks.size
                    else
                      0
                    end
                end.reverse
      @stores = @stores.first(3)

      @tonkotsu_ranks = Store.left_joins(:store_comments).distinct.sort_by do |tonkotsu_rank|
                    ranks = tonkotsu_rank.store_comments.where(genre: 2)
                    if ranks.present?
                      ranks.map(&:rate).sum / ranks.size
                      # ranks.select{ |store| store.genre == 2 }
                    else
                      0
                    end
                end.reverse
      @tonkotsu_ranks = @tonkotsu_ranks.first(3)
  end

  def about
  end

end
