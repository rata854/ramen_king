class StoresController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def index
    @stores = Store.all
  end

  def show
    @store = Store.find(params[:id])
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
    selection = params[:keyword]
    @genre = params[:genre]
    if selection == 'new'
      @stores = Store.left_joins(:store_comments).where(store_comments:{ genre: params[:genre] }).distinct.order(created_at: :DESC)
    else
      @stores = Store.left_joins(:store_comments).where(store_comments:{ genre: params[:genre] }).distinct.sort_by do |store|
                ranks = store.store_comments.where(store_comments:{ genre: params[:genre] })
                    if ranks.present?
                      ranks.map(&:rate).sum / ranks.size
                    else
                      0
                    end
              end.reverse
    end

  end

  private

  def store_params
    params.require(:store).permit(:store_name, :menu, :postal_code, :latitude, :longitude,
                                  :address, :transportation, :business_day, :holiday)
  end

end
