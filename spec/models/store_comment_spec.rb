# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoreComment, "StoreCommentモデルのテスト", type: :model do
  describe 'StoreCommentモデルのテスト' do
    before do
      @user = FactoryBot.create(:user)
      @store = FactoryBot.create(:store)
      @store_comment = FactoryBot.create(:store_comment, user_id: @user.id, store_id: @store.id)
    end

    context '登録ができるか' do
      it "全ての情報があれば登録できる" do
        expect(@store_comment).to be_valid
      end
    end

    context 'titleカラム' do
      it '空白だと登録できない' do
        store_comment = build(:store_comment, title: '')
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:title]).to include("can't be blank")
      end

      it '50字以下であること（50字は◯）' do
        title = Faker::Lorem.characters(number: 50)
        store_comment = build(:store_comment, title: title)
        expect(store_comment).not_to be_valid
      end

      it '50字以下であること（51字は☓）' do
        title = Faker::Lorem.characters(number: 51)
        store_comment = build(:store_comment, title: title)
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:title]).to include("is too long (maximum is 50 characters)")
      end
    end

    context 'introductionカラム' do
      it '空白だと登録できない' do
        store_comment = build(:store_comment, introduction: '')
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:introduction]).to include("can't be blank")
      end

      it '50字以下であること（2000字は◯）' do
        introduction = Faker::Lorem.characters(number: 2000)
        store_comment = build(:store_comment, introduction: introduction)
        expect(store_comment).not_to be_valid
      end

      it '50字以下であること（2001字は☓）' do
        introduction = Faker::Lorem.characters(number: 2001)
        store_comment = build(:store_comment, introduction: introduction)
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:introduction]).to include("is too long (maximum is 2000 characters)")
      end
    end

    context 'rateカラム' do
      it 'rateの値がないと登録できない' do
        store_comment = build(:store_comment, rate: '')
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:rate]).to include("can't be blank")
      end
    end

    context 'userモデルとの関係' do
      it 'N:1となっている' do
        expect(StoreComment.reflect_on_association(:user)).to be_present
      end
    end

    context 'storeモデルとの関係' do
      it 'N:1となっている' do
        expect(StoreComment.reflect_on_association(:store)).to be_present
      end
    end
  end
end
