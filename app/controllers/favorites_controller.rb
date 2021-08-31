class FavoritesController < ApplicationController
  def create
    @store_comment = StoreComment.find(params[:store_comment_id])
    favorite = current_user.favorites.new(store_comment_id: @store_comment.id)
    favorite.save
  end

  def destroy
    @store_comment = StoreComment.find(params[:store_comment_id])
    favorite = current_user.favorites.find_by(store_comment_id: @store_comment.id)
    favorite.destroy
  end
end
