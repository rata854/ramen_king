# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stores', type: :system do
  before do
    @store = FactoryBot.create!(:store)
  end
  
describe '投稿のテスト' do

  describe 'トップ画面(root_path)のテスト' do
    before do
      visit top_path
    end
    context '表示の確認' do
    #   it 'トップ画面(top_path)に「ここはTopページです」が表示されているか' do
    #     expect(page).to have_content 'ここはTopページです'
    #   end
    #   it 'top_pathが"/top"であるか' do
    #     expect(current_path).to eq('/top')
    #   end
    # end
  end
  
end