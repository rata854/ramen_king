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
  
  private
  
  def store_params
    params.require(:store).permit(:store_name, :store_introduction, :postal_code,
                                  :address, :transportation, :business_day, :holiday)
  end
  
end
