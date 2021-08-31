require 'rails_helper'

RSpec.describe "Favorite", type: :request do
  let(:user) { create(:user) }
  let(:store_comment) { create(:store_comment) }
  let(:favorite) { create(:favorite, user_id: user.id, store_comment_id: store_comment.id) }

  describe "favorite#create" do
    subject do
      post store_store_comment_favorites_path(
        store_comment_id: store_comment.id, store_id: store_comment.store_id
      ), xhr: true
    end

    before do
      sign_in user
    end

    it "store_commentに自分のuser_idがないといいねができる" do
      expect { subject }.to change(Favorite, :count).by(1)
    end
    it 'リクエストが正常' do
      is_expected.to eq 200
    end
  end

  describe "favorite#destroy" do
    subject do
      delete store_store_comment_favorites_path(
        store_comment_id: store_comment.id, store_id: store_comment.store_id
      ), xhr: true
    end

    before do
      sign_in user
      post store_store_comment_favorites_path(
        store_comment_id: store_comment.id, store_id: store_comment.store_id
      ), xhr: true
    end

    it "store_commentに自分のuser_idがあるといいねを解除できる" do
      expect { subject }.to change(Favorite, :count).by(-1)
    end
    it 'リクエストが正常' do
      is_expected.to eq 200
    end
  end
end
