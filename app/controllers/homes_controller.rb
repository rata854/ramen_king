class HomesController < ApplicationController
  
  def top
    # ranksで平均を計算
    @stores = Store.ranks
    # トップ3用
    @top_ranks = @stores.first(3)
    # トップ3以降のランキング
    @ranks = Kaminari.paginate_array(@stores).page(params[:page]).per(7).offset(3)
  end

  def about
  end
  
end
