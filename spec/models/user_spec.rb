# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, "Userモデルのテスト", type: :model do
  describe 'userモデルのテスト' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end
  context 'nameカラム' do
    it 'naemが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか' do
      user = User.new(name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name].to include("can't be blank"))
    end
    it 'nameが2文字以上であること（1文字は☓）' 
    it 'nameが2文字以上であること（2文字は◯）' 
    it 'nameが15字以下であること（15字は◯）'
    it 'nameが15字以下であること（15字は☓）'
    it 'nameに一意性があること'
  end
end