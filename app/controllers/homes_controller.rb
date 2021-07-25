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
    # トップ3用
    @top_ranks = @stores.first(3)
    # トップ3以降のランキング
    @ranks = Kaminari.paginate_array(@stores).page(params[:page]).per(7).offset(3)
  end

  def about
  end
  
end
