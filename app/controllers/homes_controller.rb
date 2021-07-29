class HomesController < ApplicationController
  
  def top
    # ranksで平均を計算
    stores = Store.ranks
    # トップ3用ランキング
    @top_ranks = stores.first(3)
    # 4位から10位までのランキング
    @ranks = Kaminari.paginate_array(stores).page(params[:page]).per(7).offset(3)
  end

  def about
  end
  
end
