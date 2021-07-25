class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    comments = []
    @user.store_comments.each do |store_comment|
      comments << store_comment
    end
    @user_comments = Kaminari.paginate_array(comments).page(params[:page]).per(5)
    
    # ユーザーのランキング機能
    @my_ranks = Store.left_joins(:store_comments).distinct.sort_by do |store|
      ranks = store.store_comments.select { |store| store.user_id == @user.id }
      if ranks.present?
        ranks.map(&:rate).sum / ranks.size
      else
        0
      end
    end.reverse
    @my_ranks = @my_ranks.first(3)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: "会員情報を更新しました"
    else
      render "edit"
    end
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
