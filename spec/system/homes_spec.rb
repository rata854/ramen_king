# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :system do
  let!(:user) { create(:user) }
  let!(:store) { create(:store) }
  let!(:store_comments) { create_list(:store_comment, 5, store_id: store.id, genre: 'しょうゆ') }

  describe 'ログイン前' do
    describe 'トップ画面のテスト' do
      before do
        visit root_path
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/'
        end
        it 'ジャンル別のランキングのリンクが存在する' do
          expect(page).to have_link 'ジャンル別のランキング', href: stores_path
        end
        it 'ランキングの店舗名がリンクになっている' do
          expect(page).to have_link store.store_name, href: store_path(store.id)
        end
      end

      context 'リンク内容の確認' do
        subject { current_path }

        it 'ジャンル別のランキングをクリックすると店舗一覧画面に遷移する' do
          click_link 'ジャンル別のランキング'
          is_expected.to eq '/stores'
        end
        it 'ランキングの店舗名をクリックすると店舗詳細画面に遷移する' do
          click_link store.store_name
          is_expected.to eq '/stores/' + user.id.to_s
        end
      end
    end

    describe 'ヘッダーのテスト' do
      before do
        visit root_path
      end

      context '表示内容の確認' do
        it 'ページ内に店舗一覧画面へのリンクボタンが存在する' do
          expect(page).to have_link '店舗一覧', href: stores_path
        end
        it 'ヘッダーにサイト紹介画面へのリンクが存在する' do
          expect(page).to have_link 'サイト紹介', href: about_path
        end
        it 'ヘッダーに新規登録画面へのリンクが存在する' do
          expect(page).to have_link '新規登録', href: new_user_registration_path
        end
        it 'ヘッダーにログイン画面へのリンクが存在する' do
          expect(page).to have_link 'ログイン', href: new_user_session_path
        end
      end

      context 'リンク内容の確認' do
        subject { current_path }

        it 'ページ内に店舗一覧画面へのリンクボタンが存在する' do
          click_link '店舗一覧'
          is_expected.to eq '/stores'
        end
        it 'ヘッダーにサイト紹介画面へのリンクが存在する' do
          click_link 'サイト紹介'
          is_expected.to eq '/about'
        end
        it 'ヘッダーに新規登録画面へのリンクが存在する' do
          click_link '新規登録'
          is_expected.to eq '/users/sign_up'
        end
        it 'ヘッダーにログイン画面へのリンクが存在する' do
          click_link 'ログイン'
          is_expected.to eq '/users/sign_in'
        end
      end
    end

    describe 'アバウト画面のテスト' do
      before do
        visit '/about'
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/about'
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe 'ヘッダーのテスト' do
      before do
        visit root_path
      end

      context '表示内容の確認' do
        it 'ヘッダーにマイページへのリンクが存在する' do
          expect(page).to have_link 'マイページ', href: user_path(user)
        end
        it 'ページ内に店舗一覧画面へのリンクボタンが存在する' do
          expect(page).to have_link '店舗一覧', href: stores_path
        end
        it 'ヘッダーにログアウトへのリンクが存在する' do
          expect(page).to have_link 'ログアウト', href: destroy_user_session_path
        end
      end

      context 'リンク内容の確認' do
        subject { current_path }

        it 'ヘッダーにマイページへのリンクが存在する' do
          click_link 'マイページ'
          is_expected.to eq '/users/' + user.id.to_s
        end
        it 'ページ内に店舗一覧画面へのリンクボタンが存在する' do
          click_link '店舗一覧'
          is_expected.to eq '/stores'
        end
        it 'ヘッダーにログアウトへのリンクが存在するる' do
          click_link 'ログアウト'
          is_expected.to eq '/'
        end
      end
    end
  end
end
