# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  
  describe 'ユーザログイン前のテスト' do
    describe 'トップ画面のテスト'
      before do
        visit root_path
      end
      
      context '表示内容の確認'
        it 'URLが正しい' do
          expect(current_path).to eq '/'
        end
        
    describe 'アバウト画面のテスト' do
      before do
        visit '/about'
      end
      context '表示内容の確認'
        it 'URLが正しい' do
          expect(current_path).to eq '/about'
        end
    end
    
        
  end
end