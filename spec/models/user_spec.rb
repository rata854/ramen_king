# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, "Userモデルのテスト", type: :model do
  describe 'Userモデルのテスト' do
    before do
      @other_user = FactoryBot.create(:user)
    end

    context '登録ができるか' do
      it "名前、emailアドレス、パスワードがあれば登録できる" do
        expect(@other_user).to be_valid
      end
    end

    context 'nameカラム' do
      it '空白だと登録できない' do
        user = build(:user, name: '')
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end

      it '2文字以上であること（1文字は☓）' do
        name = Faker::Lorem.characters(number: 1)
        user = build(:user, name: name)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("is too short (minimum is 2 characters)")
      end

      it '2文字以上であること（2文字は◯）' do
        name = Faker::Lorem.characters(number: 2)
        user = build(:user, name: name)
        expect(user).to be_valid
      end

      it '15字以下であること（15字は◯）' do
        name = Faker::Lorem.characters(number: 15)
        user = build(:user, name: name)
        expect(user).to be_valid
      end

      it '15字以下であること（16字は☓）' do
        name = Faker::Lorem.characters(number: 16)
        user = build(:user, name: name)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("is too long (maximum is 15 characters)")
      end

      it '一意性があること' do
        user = build(:user)
        user.name = @other_user.name
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("has already been taken")
      end
    end

    context 'introductionカラム' do
      it '100字以下であること（100字は◯）' do
        introduction = Faker::Lorem.characters(number: 100)
        user = build(:user, introduction: introduction)
        expect(user).to be_valid
      end

      it '100字以下であること（101字は☓）' do
        introduction = Faker::Lorem.characters(number: 101)
        user = build(:user, introduction: introduction)
        expect(user).not_to be_valid
        expect(user.errors[:introduction]).to include("is too long (maximum is 100 characters)")
      end
    end

    context 'storesモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:stores)).to be_present
      end
    end

    context 'store_commentsモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:store_comments)).to be_present
      end
    end
  end
end
