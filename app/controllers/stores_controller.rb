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
    @stores = Store.sort(selection)
    @genre = params[:genre]
    
    # if @genre == 'しょうゆ'
    # if params[:genre]
      # @soy_sauce_ranks = Store.left_joins(:store_comments).distinct.sort_by do |soy_sauce_rank|
      #                     ranks = soy_sauce_rank.store_comments.where(genre: 0)
      #                     if ranks.present?
      #                       ranks.map(&:rate).sum / ranks.size
      #                     else
      #                       0
      #                     end
      #                   end.reverse
    # elsif @genre == 'みそ'
      # @miso_ranks = Store.left_joins(:store_comments).distinct.sort_by do |miso_rank|
      #                     ranks = miso_rank.store_comments.where(genre: 1)
      #                     if ranks.present?
      #                       ranks.map(&:rate).sum / ranks.size
      #                     else
      #                       0
      #                     end
      #                   end.reverse
    # elsif @genre == 'とんこつ'
      # @tonkotsu_ranks = Store.left_joins(:store_comments).distinct.sort_by do |tonkotsu_rank|
      #                     ranks = tonkotsu_rank.store_comments.where(genre: 2)
      #                     if ranks.present?
      #                       ranks.map(&:rate).sum / ranks.size
      #                     else
      #                       0
      #                     end
      #                   end.reverse
    # elsif @genre == 'しお'
      # @salt_ranks = Store.left_joins(:store_comments).distinct.sort_by do |salt_rank|
      #                     ranks = salt_rank.store_comments.where(genre: 3)
      #                     if ranks.present?
      #                       ranks.map(&:rate).sum / ranks.size
      #                     else
      #                       0
      #                     end
      #                   end.reverse
    # else
    #   @stores = Store.all
    # end

  end

  private

  def store_params
    params.require(:store).permit(:store_name, :store_introduction, :postal_code,
                                  :address, :transportation, :business_day, :holiday)
  end

end
