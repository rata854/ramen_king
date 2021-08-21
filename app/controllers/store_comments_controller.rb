class StoreCommentsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_correct_user, except: [:show]

  def show
    @store = Store.find(params[:store_id])
    @store_comment = StoreComment.find(params[:id])
  end

  def new
    @store_comment = StoreComment.new
  end

  def create
    @store = Store.find(params[:store_id])
    @store_comment = StoreComment.new(store_comment_params)
    @store_comment.user_id = current_user.id
    @store_comment.store_id = @store.id
    if @store_comment.save
      redirect_to store_store_comment_path(id: @store_comment), notice: "口コミを投稿しました"
    else
      render :new
    end
  end

  def edit
    @store = Store.find(params[:store_id])
    @store_comment = StoreComment.find(params[:id])
  end

  def update
    @store_comment = StoreComment.find(params[:id])
    if @store_comment.update(store_comment_params)
      redirect_to store_store_comment_path(id: @store_comment), notice: "口コミを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @store = Store.find(params[:store_id])
    @store_comment = @store.store_comments.find(params[:id])
    @store_comment.destroy
    redirect_to user_path(current_user)
  end

  def ensure_correct_user
    @store_comment = StoreComment.find(params[:id])
    unless @store_comment.user_id == current_user.id
      redirect_to store_store_comment_path(current_user)
    end
  end

  private

  def store_comment_params
    params.require(:store_comment).permit(:title, :introduction, :product_image,
                                          :rate, :genre, :store_id)
  end

end
