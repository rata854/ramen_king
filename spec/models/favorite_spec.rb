# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, "Favoriteモデルのテスト", type: :model do
  before do
    @favorite = create(:favorite)
  end

   describe '正常値と異常値の確認' do
    context 'favoriteモデルのバリデーション' do
      it "user_idとstore_comment_idがあれば保存できる" do
        expect(create(:favorite)).to be_valid
      end
      it "user_idがなければ無効な状態であること" do
        favorite = build(:favorite, user_id: nil)
        expect(favorite).not_to be_valid
      end
      it "store_comment_idがなければ無効な状態であること" do
        favorite = build(:favorite, store_comment_id: nil)
        expect(favorite).not_to be_valid
      end
      it "store_comment_idが同じでもuser_idが違うと保存できる" do
        expect(create(:favorite, store_comment_id: @favorite.store_comment_id)).to be_valid
      end
    end
  end
end