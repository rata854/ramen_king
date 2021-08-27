# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StoreComments', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @store = FactoryBot.create(:store)
    @store_comment = FactoryBot.create(:store_comment, user_id: @user.id)
  end

  describe '未ログイン状態' do
    it '新規口コミを投稿できない' do
      visit new_store_store_comment_path(@store)
      expect(current_path).to eq '/users/sign_in'
    end
  end

  describe '他人の口コミ' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: @user2.email
      fill_in 'user[password]', with: @user2.password
      click_button 'ログイン'
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
        visit edit_store_store_comment_path(@store_comment.store_id, @store_comment.id)
      end

      it '他人の投稿編集画面には遷移出来ず、投稿詳細画面に遷移する' do
        expect(current_path).to eq '/stores/' + @store_comment.store_id.to_s + '/store_comments/' + @store_comment.id.to_s
      end

    end

  end

  describe '自分の口コミ' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      click_button 'ログイン'
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

    describe '口コミ編集画面' do
      before do
        visit edit_store_store_comment_path(@store_comment.store_id, @store_comment.id)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores/' + @store_comment.store_id.to_s + '/store_comments/' + @store_comment.id.to_s + '/edit'
        end
        it 'タイトルフォームが表示されている' do
          expect(page).to have_field 'store_comment[title]', with: @store_comment.title
        end
        # it '星評価フォームが表示されている' do
        #   expect(page).to have_field 'store_comment[rate]'
        # end
        it '本文フォームが表示されている' do
          expect(page).to have_field 'store_comment[introduction]', with: @store_comment.introduction
        end
        it '画像フォームが表示されている' do
          expect(page).to have_field 'store_comment[product_image]'
        end
        it 'ジャンルフォームが表示されている' do
          expect(page).to have_field 'store_comment[genre]', with: 'みそ'
        end
        it 'Update Store commentボタンが表示されている' do
          expect(page).to have_button 'Update Store comment'
        end
      end

      context '投稿編集のテスト' do
      #   before do
      #     fill_in 'store_comment[title]', with: Faker::Lorem.characters(number: 5)
      #     # fill_in 'store_comment[rate]', with: find('#star').find("img[alt='2']").click
      #     fill_in 'store_comment[introduction]', with: Faker::Lorem.characters(number: 500)
      #     # fill_in 'store_comment[product_image]'
      #     # fill_in 'store_comment[genre]', with: 'しょうゆ'
      #   end

      #   it '投稿編集後、編集した店舗詳細画面へ遷移してる' do
      #     click_button 'Create Store'
      #     expect(current_path).to eq  expect(current_path).to eq '/stores/' + @store_comment.store_id.to_s + '/store_comments/' + @store_comment.id.to_s
      #   end
      end

    end

  end

end
