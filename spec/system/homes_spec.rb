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
        it 'ページ内に店舗一覧画面のリンクボタンが存在する'
        it 'ヘッダーにマイページのリンクが存在する' 
        it 'ヘッダーに店舗一覧のリンクが存在する'
        it 'ヘッダーに新規登録のリンクが存在する'
        it 'ヘッダーにログアウトのリンクが存在する'
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
