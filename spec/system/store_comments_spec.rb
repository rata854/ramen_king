# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StoreComments', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @store = FactoryBot.create(:store)
    @store_comment = FactoryBot.create(:store_comment, user_id: @user.id, store_id: @store.id)
    @store_comment2 = FactoryBot.create(:store_comment, user_id: @user2.id, store_id: @store.id)
  end

  describe 'ログイン前' do
    it '新規口コミ作成画面員に行くとログインページに遷移する' do
      visit new_store_store_comment_path(@store)
      expect(current_path).to eq '/users/sign_in'
    end

    it '他人の口コミ編集画面に行くとログインページに遷移する' do
      visit edit_store_store_comment_path(@store_comment.store_id, @store_comment.id)
      expect(current_path).to eq '/users/sign_in'
    end
  end

  describe 'ログイン後' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      click_button 'ログイン'
    end

    describe '口コミ投稿画面のテスト' do
      before do
        visit new_store_store_comment_path(@store)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores/' + @store_comment.store_id.to_s + '/store_comments' + '/new'
        end
        it 'タイトルフォームが表示されている' do
          expect(page).to have_field 'store_comment[title]'
        end
        it '星評価フォームが表示されている' do
          expect(page).to have_css '#star'
        end
        it '本文フォームが表示されている' do
          expect(page).to have_field 'store_comment[introduction]'
        end
        it '画像フォームが表示されている' do
          expect(page).to have_field 'store_comment[product_image]'
        end
        it 'ジャンルフォームが表示されている' do
          expect(page).to have_field 'store_comment[genre]'
        end
        it 'Update Store commentボタンが表示されている' do
          expect(page).to have_button '登録する'
        end
      end

      context 'ログイン成功のテスト' do
        before do
          fill_in 'store_comment[title]', with: Faker::Lorem.characters(number: 5)
          fill_in find("#star"), with: '4.5'
          fill_in 'store_comment[introduction]', with: Faker::Lorem.characters(number: 5)
          fill_in 'store_comment[product_image]'
          fill_in 'store_comment[genre]', with: 'しょうゆ'
          click_button '登録する'
        end

        it 'ログイン後、ログインしたユーザー詳細画面に遷移している' do
          expect(current_path).to eq store_store_comment_path(@store_comment.store_id, @store_comment.id)
        end
      end

      context 'ログイン失敗時のテスト' do
        before do
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: ''
          click_button 'ログイン'
        end

        it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
          expect(current_path).to eq '/users/sign_in'
        end
      end
    end

    describe '口コミ詳細画面のテスト' do
      context '本人の口コミ詳細画面の場合' do
        before do
          visit store_store_comment_path(@store_comment.store_id, @store_comment.id)
        end

        it 'URLが正しい' do
          expect(current_path).to eq '/stores/' + @store_comment.store_id.to_s + '/store_comments/' + @store_comment.id.to_s
        end
        it '店舗名が店舗詳細画面へのリンクになっている' do
          expect(page).to have_link @store.store_name, href: store_path(@store)
        end
        it '投稿者名のリンクがユーザー詳細画面へのリンクになっている' do
          expect(page).to have_link @user.name, href: user_path(@user)
        end
        it '口コミのタイトルが本人のものになっている' do
          expect(page).to have_content @store_comment.title
        end
        it '投稿者の口コミなら口コミ編集ボタンが表示される' do
          expect(page).to have_link '口コミ編集', href: edit_store_store_comment_path(@store_comment.store_id, @store_comment.id)
        end
      end

      context '他人の口コミ詳細画面の場合' do
        before do
          visit store_store_comment_path(@store_comment2.store_id, @store_comment2.id)
        end

        it 'URLが正しい' do
          expect(current_path).to eq '/stores/' + @store_comment2.store_id.to_s + '/store_comments/' + @store_comment2.id.to_s
        end
        it '店舗名が店舗詳細画面へのリンクになっている' do
          expect(page).to have_link @store.store_name, href: store_path(@store)
        end
        it '投稿者名のリンクがユーザー詳細画面へのリンクになっている' do
          expect(page).to have_link @user2.name, href: user_path(@user2)
        end
        it '口コミのタイトルが本人のものになっている' do
          expect(page).to have_content @store_comment2.title
        end
        it '他人の口コミだと口コミ編集ボタンが表示さない' do
          expect(page).not_to have_link '口コミ編集', href: edit_store_store_comment_path(@store_comment2.store_id, @store_comment2.id)
        end
      end
    end

    describe '口コミ編集画面のテスト' do
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
        it '星評価フォームが表示されている' do
          expect(page).to have_css '#star'
        end
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
          expect(page).to have_button '更新する'
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
