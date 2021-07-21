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
    # @stores = @stores.page(params[:page]).per(10)
  end

  def about
  end
  
end
