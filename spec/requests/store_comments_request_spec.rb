require 'rails_helper'

RSpec.describe "StoreComments", type: :request do
  let!(:user) { create(:user) }
  let!(:store) { create(:store) }

  describe 'store_comments#new' do
    context '未ログインユーザーが口コミ登録しようとした場合' do
      it 'ログインページへ遷移する' do
        get new_store_store_comment_path(store)
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "store_commnets#create" do
    subject do
      post store_store_comments_path(store.id, store_comment),
           params: { store_comment: store_comment }
    end

    before do
      sign_in user
    end

    context "パラメーターが正常の場合" do
      let(:store_comment) { attributes_for(:store_comment) }

      it '口コミが登録される' do
        expect { subject }.to change(StoreComment, :count).by(1)
      end
      it 'リクエストが正常' do
        is_expected.to eq 302
      end
      it 'リダイレクトが成功する' do
        expect(subject).to redirect_to store_store_comment_path(id: StoreComment.last)
      end
    end

    context "パラメーターが不正の場合" do
      let(:store_comment) { attributes_for(:store_comment, title: '') }

      it '口コミが登録出来ない' do
        expect { subject }.to change(StoreComment, :count).by(0)
      end
      it 'リクエストが正常' do
        is_expected.to eq 200
      end
    end
  end

  describe 'store_comments#edit' do
    context '未ログインユーザーが口コミ編集をしようとした場合' do
      let!(:store_comment) { create(:store_comment) }

      it 'ログインページへ遷移する' do
        get edit_store_store_comment_path(store, store_comment)
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "store_comments#update" do
    let!(:store_comment) do
      create(:store_comment,
             user_id: user.id, store_id: store.id,
             title: '美味しいしょうゆのお店')
    end

    before do
      sign_in user
    end

    context "パラメーターが正常の場合" do
      before do
        store_comment_params =
          attributes_for(:store_comment,
                         user_id: user.id, store_id: store.id,
                         title: '美味しいみそのお店')
        patch store_store_comment_path(store, store_comment),
              params: { store_comment: store_comment_params }
      end

      it '口コミ情報を更新できる' do
        expect(store_comment.reload.title).to eq '美味しいみそのお店'
      end
      it 'リクエストが正常' do
        expect(response).to have_http_status(302)
      end
      it 'リダイレクトが成功する' do
        expect(response).to redirect_to store_store_comment_path(id: store_comment)
      end
    end

    context "パラメーターが不正の場合" do
      let!(:store_comment) do
        create(:store_comment,
               user_id: user.id, store_id: store.id, title: '')
      end

      before do
        store_comment_params =
          attributes_for(:store_comment,
                         user_id: user.id, store_id: store.id, title: '')
        patch store_store_comment_path(store, store_comment),
              params: { store_comment: store_comment_params }
      end

      it '口コミ情報を更新できない' do
        expect(store_comment.reload.title).to eq store_comment.title
      end
      it 'リクエストが正常' do
        expect(response).to have_http_status(200)
      end
    end

    context '他人の口コミ' do
      let!(:other_user) { create(:user) }
      let!(:store_comment) do
        create(:store_comment,
               user_id: other_user.id, store_id: store.id,
               title: '美味しいとんこつのお店')
      end

      before do
        store_comment_params =
          attributes_for(:store_comment,
                         user_id: user.id, store_id: store.id,
                         title: '美味しいしおのお店')
        patch store_store_comment_path(store, store_comment),
              params: { store_comment: store_comment_params }
      end

      it '他人の口コミは編集できない' do
        expect(store_comment.reload.title).to eq '美味しいとんこつのお店'
      end
      it 'リクエストが正常' do
        expect(response).to have_http_status(302)
      end
      it '自分のコメント詳細ページに遷移する' do
        expect(response).to redirect_to store_store_comment_path(user)
      end
    end
  end

  describe "store_comments#destroy" do
    subject { delete store_store_comment_path(store, store_comment) }

    before do
      sign_in user
    end

    context "本人の口コミの場合" do
      let!(:store_comment) { create(:store_comment, user_id: user.id, store_id: store.id) }

      it '口コミが削除される' do
        expect { subject }.to change(StoreComment, :count).by(-1)
      end
      it 'リクエストが正常' do
        is_expected.to eq 302
      end
      it 'リダイレクトが成功する' do
        expect(subject).to redirect_to(user_path(user))
      end
    end

    context "他人の口コミの場合" do
      let!(:other_user) { create(:user) }
      let!(:store_comment) { create(:store_comment, user_id: other_user.id, store_id: store.id) }

      it '口コミは削除できない' do
        expect { subject }.to change(StoreComment, :count).by(0)
      end
      it 'リクエストが正常' do
        is_expected.to eq 302
      end
      it 'リダイレクトが成功する' do
        expect(subject).to redirect_to(store_store_comment_path(user))
      end
    end
  end
end
