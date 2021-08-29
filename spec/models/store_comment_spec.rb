# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoreComment, "StoreCommentモデルのテスト", type: :model do
    before do
      @store_comment = create(:store_comment)
    end

 describe 'バリデーションのテスト' do
    context '登録ができるか' do
      it "全ての情報があれば登録できる" do
        expect(@store_comment).to be_valid
      end
    end

    context 'titleカラム' do
      it '空白だと登録できない' do
        store_comment = build(:store_comment, title: '')
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:title]).to include("を入力してください")
      end
      it '50字以下であること（50字は◯）' do
        title = Faker::Lorem.characters(number: 50)
        store_comment = build(:store_comment, title: title)
        expect(store_comment).to be_valid
      end
      it '50字以下であること（51字は☓）' do
        title = Faker::Lorem.characters(number: 51)
        store_comment = build(:store_comment, title: title)
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:title]).to include("は50文字以内で入力してください")
      end
    end

    context 'introductionカラム' do
      it '空白だと登録できない' do
        store_comment = build(:store_comment, introduction: '')
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:introduction]).to include("を入力してください")
      end
      it '50字以下であること（2000字は◯）' do
        introduction = Faker::Lorem.characters(number: 2000)
        store_comment = build(:store_comment, introduction: introduction)
        expect(store_comment).to be_valid
      end
      it '50字以下であること（2001字は☓）' do
        introduction = Faker::Lorem.characters(number: 2001)
        store_comment = build(:store_comment, introduction: introduction)
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:introduction]).to include("は2000文字以内で入力してください")
      end
    end

    context 'rateカラム' do
      it 'rateの値がないと登録できない' do
        store_comment = build(:store_comment, rate: '')
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:rate]).to include("を入力してください")
      end
    end

    context 'genreカラム' do
      it 'genreの値がないと登録できない' do
        store_comment = build(:store_comment, genre: '')
        expect(store_comment).not_to be_valid
        expect(store_comment.errors[:genre]).to include("を入力してください")
      end
    end
  end

  describe 'アソシエーションのテスト' do
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

    context 'favoritesモデルとの関係' do
      it '1:Nとなっている' do
         expect(StoreComment.reflect_on_association(:favorites)).to be_present
      end
    end
  end

  describe 'メソッドのテスト' do
    context 'favorited_by?メソッド' do
    before do
      @current_user = create(:user)
      @current_comment = create(:store_comment, user_id: @current_user.id)
      current_favorite = create(:favorite, store_comment_id: @current_comment.id, user_id: @current_user.id)
      user = create(:user)
      @other_comment = create(:store_comment, user_id: user.id)
      other_favorite = create(:favorite, store_comment_id: @other_comment.id, user_id: user.id)
    end
      it 'コメントに紐付いたのfavoritesモデルに自分のuser_idが入っている場合はtrueを返す' do
        expect(@current_comment.favorited_by?(@current_user)).to be_truthy
      end
      it 'コメントに紐付いたのfavoritesモデルに自分のuser_idが入っていない場合はfalseを返す' do
        expect(@other_comment.favorited_by?(@current_user)).to be_falsey
      end
    end
  end
end
