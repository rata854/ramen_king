# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :system do
  describe 'ログイン前' do
    describe 'トップ画面のテスト'do
      before do
        visit root_path
      end
  
      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/'
        end
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
end