require 'rails_helper'

RSpec.describe "Stores", type: :request do
  let!(:user) { create(:user) }

  describe 'stores#new' do
    context '未ログインユーザーが新規店舗登録しようとした場合' do
      it 'ログインページへ遷移する' do
        get new_store_path
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "stores#create" do
    subject { post stores_path, params: { store: store } }

    before do
      sign_in user
    end

    context "パラメーターが正常の場合" do
      let(:store) { attributes_for(:store) }

      it '店舗が登録される' do
        expect { subject }.to change(Store, :count).by(1)
      end
      it 'リクエストが正常' do
        is_expected.to eq 302
      end
      it 'リダイレクトが成功する' do
        expect(subject).to redirect_to store_path(Store.last)
      end
    end

    context "パラメーターが不正の場合" do
      let(:store) { attributes_for(:store, store_name: '') }

      it '店舗が登録出来ない' do
        expect { subject }.to change(Store, :count).by(0)
      end
      it 'リクエストが正常' do
        is_expected.to eq 200
      end
    end
  end

  describe 'stores#edit' do
    context '未ログインユーザーが店舗編集をしようとした場合' do
      let!(:store) { create(:store) }

      it 'ログインページへ遷移する' do
        get edit_store_path(store)
        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "stores#update" do
    context "パラメーターが正常の場合" do
      let!(:store) { create(:store, store_name: '麺匠') }

      before do
        sign_in user
        store_params = attributes_for(:store, store_name: '麺匠2')
        patch store_path(store), params: { store: store_params }
      end

      it '店舗情報を更新できる' do
        expect(store.reload.store_name).to eq '麺匠2'
      end
      it 'リクエストが正常' do
        expect(response).to have_http_status(302)
      end
      it 'リダイレクトが成功する' do
        expect(response).to redirect_to store_path(store)
      end
    end

    context "パラメーターが不正の場合" do
      let!(:store) { create(:store) }

      before do
        sign_in user
        store_params = attributes_for(:store, store_name: '')
        patch store_path(store), params: { store: store_params }
      end

      it '店舗情報を更新できない' do
        expect(store.reload.store_name).to eq store.store_name
      end
      it 'リクエストが正常' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
