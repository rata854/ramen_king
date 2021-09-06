# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:store) { create(:store) }
  let!(:store_comment) { create(:store_comment, user_id: user.id, store_id: store.id) }
  let!(:other_store_comment) { create(:store_comment, user_id: other_user.id, store_id: store.id) }

  describe 'ログイン前のユーザーテスト' do
    describe '新規登録のテスト' do
      before do
        visit new_user_registration_path
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/sign_up'
        end
        it 'nameフォームが表示されている' do
          expect(page).to have_field 'user[name]'
        end
        it 'emailフォームが表示されている' do
          expect(page).to have_field 'user[email]'
        end
        it 'passwordが表示されている' do
          expect(page).to have_field 'user[password]'
        end
        it 'password_confirmationが表示されている' do
          expect(page).to have_field 'user[password_confirmation]'
        end
        it '新規登録ボタンが表示されている' do
          expect(page).to have_button '新規登録'
        end
      end

      context '新規登録のテスト' do
        before do
          fill_in 'user[name]', with: Faker::Lorem.characters(number: 5)
          fill_in 'user[email]', with: Faker::Internet.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
        end

        it '正しく新規登録される' do
          expect { click_button '新規登録' }.to change(User.all, :count).by(1)
        end
        it '新規登録後、ログインしたユーザー詳細画面に遷移するか' do
          click_button '新規登録'
          expect(current_path).to eq '/users/' + User.last.id.to_s
        end
      end
    end

    describe 'ログイン画面のテスト' do
      before do
        visit new_user_session_path
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/sign_in'
        end
        it 'emailフォームが表示される' do
          expect(page).to have_field 'user[email]'
        end
        it 'passwordフォームが表示される' do
          expect(page).to have_field 'user[password]'
        end
        it 'ログインボタンが表示される' do
          expect(page).to have_button 'ログイン'
        end
      end

      context 'ログイン成功のテスト' do
        before do
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
          click_button 'ログイン'
        end

        it 'ログイン後、ログインしたユーザー詳細画面に遷移している' do
          expect(current_path).to eq '/users/' + user.id.to_s
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

    describe 'ログアウトのテスト' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        click_link 'ログアウト'
      end

      context 'ログアウト機能のテスト' do
        it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
          expect(page).to have_link 'サイト紹介', href: '/about'
        end
        it 'ログアウト後のリダイレクト先がトップ画面になっている' do
          expect(current_path).to eq '/'
        end
      end
    end

    describe 'ユーザー詳細画面のテスト' do
      context '未ログインユーザーの場合' do

        before do
          visit user_path(user)
        end

        it 'ユーザー口コミのタイトルが口コミ詳細画面へのリンクになっている' do
          expect(page).to have_link store_comment.title,
                                    href: store_store_comment_path(
                                      store_comment.store_id, store_comment.id
                                    )
        end
        it 'ユーザー口コミの投稿者がユーザー詳細画面へのリンクになっている' do
          expect(page).to have_link user.name, href: user_path(user)
        end
        it 'ユーザー口コミの店舗名が店舗詳細画面へのリンクになっている' do
          expect(page).to have_link store.store_name, href: store_path(store)
        end
        it 'ユーザー編集画面へのリンクが存在しない' do
          expect(page).not_to have_link '', href: '/users/' + user.id.to_s + '/edit'
        end
      end
    end
  end

  describe 'ログイン後のユーザーテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe 'ユーザー詳細画面のテスト' do
      context '本人のユーザー詳細画面の場合' do
        before do
          visit user_path(user)
        end

        it '本人の口コミのタイトルが口コミ詳細画面へのリンクになっている' do
          expect(page).to have_link store_comment.title,
                                    href: store_store_comment_path(
                                      store_comment.store_id, store_comment.id
                                    )
        end
        it '本人の口コミの投稿者がユーザー詳細画面へのリンクになっている' do
          expect(page).to have_link user.name, href: user_path(user)
        end
        it '本人の口コミの店舗名が店舗詳細画面へのリンクになっている' do
          expect(page).to have_link store.store_name, href: store_path(store)
        end
        it '編集画面へのリンクが存在する' do
          expect(page).to have_link '', href: '/users/' + user.id.to_s + '/edit'
        end
      end

      context '他人のユーザー詳細画面の場合' do
        before do
          visit user_path(other_user)
        end

        it '他人の口コミのタイトルが口コミ詳細画面へのリンクになっている' do
          expect(page).to have_link other_store_comment.title,
                                    href: store_store_comment_path(
                                      other_store_comment.store_id, other_store_comment.id
                                    )
        end
        it '他人の口コミの投稿者がユーザー詳細画面へのリンクになっている' do
          expect(page).to have_link other_user.name, href: user_path(other_user)
        end
        it '他人の口コミの店舗名が店舗詳細画面へのリンクになっている' do
          expect(page).to have_link store.store_name, href: store_path(store)
        end
        it '編集画面へのリンクが存在しない' do
          expect(page).not_to have_link '', href: '/users/' + other_user.id.to_s + '/edit'
        end
      end
    end

    describe 'ユーザー編集画面のテスト' do
      before do
        visit edit_user_path(user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
        end
        it 'name編集フォームが表示されている' do
          expect(page).to have_field 'user[name]', with: user.name
        end
        it 'introduction編集フォームが表示されている' do
          expect(page).to have_field 'user[introduction]', with: user.introduction
        end
        it 'プロフィール画像編集フォームが表示されている' do
          expect(page).to have_field 'user[profile_image]'
        end
        it '更新する userボタンが表示されている' do
          expect(page).to have_button '更新する'
        end
      end

      context '編集成功のテスト' do
        before do
          fill_in 'user[name]', with: 'test@example.com'
          fill_in 'user[introduction]', with: 'test'
          click_button '更新する'
        end

        it '編集成功後マイページに遷移している' do
          expect(current_path).to eq '/users/' + user.id.to_s
        end
      end
    end
  end

  describe '管理者ユーザーの削除機能テスト' do
    let!(:admin_user) { create(:user, :admin) }

    describe 'ユーザー詳細画面のテスト' do
      context '管理者ユーザーの場合' do
        before do
          visit new_user_session_path
          fill_in 'user[email]', with: admin_user.email
          fill_in 'user[password]', with: admin_user.password
          click_button 'ログイン'
          visit user_path(other_user)
        end

        it 'ユーザー詳細画面に削除リンクが存在する' do
          expect(page).to have_link 'ユーザーの削除', href: user_path(other_user)
        end
      end

      context '通常ユーザーの場合' do
        before do
          visit new_user_session_path
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
          click_button 'ログイン'
          visit user_path(other_user)
        end

        it 'ユーザー詳細画面に削除リンクが存在しない' do
          expect(page).not_to have_link 'ユーザーの削除', href: user_path(other_user)
        end
      end
    end

    describe 'ユーザー削除機能のテスト' do
      context '管理者ユーザーの場合' do
        before do
          visit new_user_session_path
          fill_in 'user[email]', with: admin_user.email
          fill_in 'user[password]', with: admin_user.password
          click_button 'ログイン'
          visit user_path(other_user)
          click_link 'ユーザーの削除'
        end

        it 'ユーザーの削除ができる' do
          # expect { click_link '口コミ削除' }.to change(StoreComment.all, :count).by(-1)
          expect(User.where(id: other_user.id).count).to eq 0
        end
        it 'ユーザー編集画面へのリンクが存在しない' do
          expect(page).not_to have_link '', href: edit_user_path(other_user)
        end
        it 'ユーザー削除後Home画面に遷移しているか' do
          expect(current_path).to eq '/'
        end
      end
    end
  end
end
