class StoresController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index, :search]

  def index
    @stores = Store.page(params[:page]).per(10)
  end

  def show
    @store = Store.find(params[:id])
    # タブ2用ページネーション
    @store_comments = @store.store_comments.page(params[:comments]).per(5)
    # タブ3用ページネーション(画像が無い場合非表示)
    store_images = @store.store_comments.
      filter { |store_comment| store_comment.product_image.present? }
    @store_images = Kaminari.paginate_array(store_images).page(params[:images]).per(12)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(store_params)
    if @store.save
      redirect_to @store, notice: "店舗情報を登録しました"
    else
      render :new
    end
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])
    if @store.update(store_params)
      redirect_to @store, notice: "店舗情報を編集しました"
    else
      render :edit
    end
  end

  def search
    @selection = params[:keyword]
    @genre = params[:genre]
    if @selection == 'new'
      if @genre == '総合'
        stores = Store.order(" created_at DESC ")
      else
        stores = Store.new_arrival(@genre)
      end
    else
      if @genre == '総合'
        stores = Store.store_ranking
      else
        stores = Store.ranking_by_genre(@genre)
      end
    end
    @stores = Kaminari.paginate_array(stores).page(params[:page]).per(10)
  end

  private

  def store_params
    params.require(:store).permit(:store_name, :menu, :postal_code, :latitude,
                                  :longitude, :address, :transportation,
                                  :business_day, :holiday, :business_status)
  end
end
