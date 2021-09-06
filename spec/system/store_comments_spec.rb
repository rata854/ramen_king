# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StoreComments', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:store) { create(:store) }
  let!(:store_comment) { create(:store_comment, user_id: user.id, store_id: store.id) }
  let!(:other_store_comment) { create(:store_comment, user_id: other_user.id, store_id: store.id) }

  describe 'ログイン前' do
    it '新規口コミ作成画面員に行くとログインページに遷移する' do
      visit new_store_store_comment_path(store)
      expect(current_path).to eq '/users/sign_in'
    end

    it '他人の口コミ編集画面に行くとログインページに遷移する' do
      visit edit_store_store_comment_path(store_comment.store_id, store_comment.id)
      expect(current_path).to eq '/users/sign_in'
    end
  end

  describe 'ログイン後' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe '口コミ投稿画面のテスト' do
      before do
        visit new_store_store_comment_path(store)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq
          '/stores/' + store_comment.store_id.to_s + '/store_comments' + '/new'
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

      context '口コミ投稿成功の場合' do
        before do
          fill_in 'store_comment[title]', with: Faker::Lorem.characters(number: 5)
          find('#review_star', visible: false).set(4)
          fill_in 'store_comment[introduction]', with: Faker::Lorem.characters(number: 500)
          attach_file "store_comment_product_image", "app/assets/images/no_image.jpg"
          select 'しょうゆ', from: 'store_comment[genre]'
        end

        it '正しく新規登録される' do
          expect { click_button '登録する' }.to change(StoreComment.all, :count).by(1)
        end
        it '口コミ投稿後、投稿した口コミ詳細画面に遷移していか' do
          click_button '登録する'
          expect(current_path).to eq
          '/stores/' + store_comment.store_id.to_s + '/store_comments/' + StoreComment.last.id.to_s
        end
      end

      context '口コミ投稿失敗の場合' do
        before do
          fill_in 'store_comment[title]', with: ''
          fill_in 'store_comment[introduction]', with: ''
          attach_file "store_comment_product_image", "app/assets/images/no_image.jpg"
          click_button '登録する'
        end

        it '新規口コミ投稿画面に遷移する' do
          expect(current_path).to eq '/stores/' + store_comment.store_id.to_s + '/store_comments'
        end
        it 'エラーメッセージが表示される' do
          expect(page).to have_selector('.alert-danger',
                                        text: 'タイトルを入力してください 本文を入力してください
                                               星評価を入力してください ジャンルを入力してください')
        end
      end
    end

    describe '口コミ詳細画面のテスト' do
      context '本人の場合' do
        before do
          visit store_store_comment_path(store_comment.store_id, store_comment.id)
        end

        it 'URLが正しい' do
          expect(current_path).to eq
          '/stores/' + store_comment.store_id.to_s + '/store_comments/' + store_comment.id.to_s
        end
        it '店舗名が店舗詳細画面へのリンクになっている' do
          expect(page).to have_link store.store_name, href: store_path(store)
        end
        it '投稿者名のリンクがユーザー詳細画面へのリンクになっている' do
          expect(page).to have_link user.name, href: user_path(user)
        end
        it '口コミのタイトルが本人のものになっている' do
          expect(page).to have_content store_comment.title
        end
        it '投稿者の口コミなら口コミ編集ボタンが表示される' do
          expect(page).to have_link '口コミ編集',
                                    href: edit_store_store_comment_path(
                                      store_comment.store_id, store_comment.id
                                    )
        end
      end

      context '他人の場合' do
        before do
          visit store_store_comment_path(other_store_comment.store_id, other_store_comment.id)
        end

        it 'URLが正しい' do
          expect(current_path).to eq
          '/stores/' + other_store_comment.store_id.to_s +
          '/store_comments/' + other_store_comment.id.to_s
        end
        it '店舗名が店舗詳細画面へのリンクになっている' do
          expect(page).to have_link store.store_name, href: store_path(store)
        end
        it '投稿者名のリンクがユーザー詳細画面へのリンクになっている' do
          expect(page).to have_link other_user.name, href: user_path(other_user)
        end
        it '口コミのタイトルが他人のものになっている' do
          expect(page).to have_content other_store_comment.title
        end
        it '他人の口コミだと口コミ編集ボタンが表示さない' do
          expect(page).not_to have_link '口コミ編集',
                                        href: edit_store_store_comment_path(
                                          other_store_comment.store_id, other_store_comment.id
                                        )
        end
      end
    end

    describe '口コミ編集画面のテスト' do
      before do
        visit edit_store_store_comment_path(store_comment.store_id, store_comment.id)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq
          '/stores/' + store_comment.store_id.to_s +
          '/store_comments/' + store_comment.id.to_s + '/edit'
        end
        it 'タイトルフォームが表示されている' do
          expect(page).to have_field 'store_comment[title]', with: store_comment.title
        end
        it '星評価フォームが表示されている' do
          expect(page).to have_css '#star'
        end
        it '本文フォームが表示されている' do
          expect(page).to have_field 'store_comment[introduction]', with: store_comment.introduction
        end
        it '画像フォームが表示されている' do
          expect(page).to have_field 'store_comment[product_image]'
        end
        it 'ジャンルフォームが表示されている' do
          expect(page).to have_field 'store_comment[genre]'
        end
        it 'Update Store commentボタンが表示されている' do
          expect(page).to have_button '更新する'
        end
      end

      context '口コミ編集成功の場合' do
        before do
          fill_in 'store_comment[title]', with: Faker::Lorem.characters(number: 5)
          find('#review_star', visible: false).set(4)
          fill_in 'store_comment[introduction]', with: Faker::Lorem.characters(number: 500)
          attach_file "store_comment_product_image", "app/assets/images/no_image.jpg"
          select 'しょうゆ', from: 'store_comment[genre]'
          click_button '更新する'
        end

        it '口コミ編集後、編集した口コミの詳細画面に遷移しているか' do
          expect(current_path).to eq
          '/stores/' + store_comment.store_id.to_s + '/store_comments/' + store_comment.id.to_s
        end
      end

      context '口コミ編集失敗の場合' do
        before do
          fill_in 'store_comment[title]', with: ''
          fill_in 'store_comment[introduction]', with: ''
          attach_file "store_comment_product_image", "app/assets/images/no_image.jpg"
          click_button '更新する'
        end

        it '口コミ編集画面に遷移する' do
          expect(current_path).to eq
          '/stores/' + store_comment.store_id.to_s + '/store_comments/' + store_comment.id.to_s
        end
        it 'エラーメッセージが表示される' do
          expect(page).to have_selector('.alert-danger',
                                        text: 'タイトルを入力してください 本文を入力してください')
        end
      end
    end

    describe '口コミ削除機能のテスト' do
      context '本人の口コミの場合' do
        before do
          visit edit_store_store_comment_path(store_comment.store_id, store_comment.id)
        end

        it '口コミ削除ボタンが存在する' do
          expect(page).to have_link '口コミ削除', href: store_store_comment_path(store, store_comment)
        end
        it '口コミを削除することが出来る' do
          expect { click_link '口コミ削除' }.to change(StoreComment.all, :count).by(-1)
        end
        it 'ユーザー詳細画面へ遷移する' do
          redirect_to user_path(user)
        end
      end
    end
  end
end
