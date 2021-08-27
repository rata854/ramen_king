require 'rails_helper'

RSpec.describe "Favorite", type: :system do
  before do
    @user = create(:user)
    @store_comment = FactoryBot.create(:store_comment, user_id: @user.id)
  end

  describe 'いいね機能のテスト' do
        before do
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      click_button 'ログイン'
    end

    context '未ログインユーザー' do
      it 'いいねが出来ない' do
        visit store_path(@user)
        find_all('#favorite-btn').click
        expect(page).to have_selector '#favorite-btn'
        expect(@store_comment.favorites.count).to eq(1)
      end
    end
  end

end