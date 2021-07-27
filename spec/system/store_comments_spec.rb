# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StoreComments', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @store_comment = FactoryBot.create(:store_comment, user_id: @user.id)
  end
  
  describe '未ログイン状態' do
    it '新規口コミを投稿できない'
  end

  describe '他人の口コミ' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: @user2.email
      fill_in 'user[password]', with: @user2.password
      click_button 'Log in'
    end
    
    describe '口コミ詳細画面のテスト' do
    before do
      visit store_store_comment_path(@store_comment.store_id, @store_comment.id)
    end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores/' + @store_comment.store_id.to_s + '/store_comments/' + @store_comment.id.to_s
        end
        it '投稿者以外は口コミの編集ボタンが表示されない' do
          expect(page).to_not have_link '口コミ編集'
        end
        it '投稿者以外は口コミの削除ボタンが表示されない' do
          expect(page).to_not have_link '口コミ削除'
        end
      end
    end
  
    describe '口コミ編集画面' do
      before do
        visit estore_store_comment_path(@store_comment.store_id, @store_comment.id)
      end
  
      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores/' + @store.id.to_s
        end
        it 'ログインしてないと店舗編集画面へのリンクが存在しない' do
          expect(page).to_not have_link '店舗情報編集'
        end
        it 'ログインしてないと口コミ投稿画面へのリンクが存在しない' do
          expect(page).to_not have_link '新規口コミ作成'
        end
      end
    end
  end

  describe '自分の口コミ' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      click_button 'Log in'
    end

    describe '口コミ詳細画面のテスト' do
    before do
      visit store_store_comment_path(@store_comment.store_id, @store_comment.id)
    end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores/' + @store_comment.store_id.to_s + '/store_comments/' + @store_comment.id.to_s
        end
        it '投稿者なら口コミの編集ボタンが表示される' do
          expect(page).to have_link '口コミ編集', href: edit_store_store_comment_path(@store_comment.store_id, @store_comment.id)
        end
        it '投稿者なら口コミの削除ボタンが表示される' do
          expect(page).to have_link '口コミ削除', href: store_store_comment_path(@store_comment.store_id, @store_comment.id)
        end
      end

    end
  end

end