require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "devise#signup" do
    context "パラメーターが正常の場合" do
      let(:user) { attributes_for(:user) }
      it 'ユーザーが登録される' do
        expect do
          post user_registration_path, params: { user: user }
        end.to change(User, :count).by(1)
      end
      it 'リクエストが正常' do
        post user_registration_path, params: { user: user }
        expect(response).to have_http_status(302)
      end
      it 'リダイレクトが成功する' do
        post user_registration_path, params: { user: user }
        expect(response).to redirect_to user_path(User.last)
      end
    end
    context "パラメーターが不正の場合" do
      email = 'abc'
      let(:user) { attributes_for(:user, email: email) }
      it 'ユーザー登録がされない' do
        expect do
          post user_registration_path, params: { user: user }
        end.to change(User, :count).by(0)
      end
      it 'リクエストが正常' do
        post user_registration_path, params: { user: user }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'users#edit' do
  before do
    @user = create(:user)
    @other_user = create(:user)
  end
    context '別ユーザーの編集を参照しようとした場合' do
      it 'マイページへ遷移する' do
        sign_in @user
        get edit_user_path(@other_user)
        expect(response).to redirect_to user_path(@user)
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "users#update" do
    context "パラメーターが正常の場合" do
    before do
      @user = create(:user, name: "test")
      sign_in @user
      user_params = attributes_for(:user, name: 'test2')
      patch user_path(@user), params: { user: user_params }
    end
      it 'ユーザー情報を更新出来る' do
        expect(@user.reload.name).to eq 'test2'
      end
      it 'リクエストが正常' do
        expect(response).to have_http_status(302)
      end
      it 'リダイレクトが成功する' do
        expect(response).to redirect_to user_path(@user)
      end
    end
    context 'パラメーターが不正の場合' do
      before do
        @user = create(:user)
        sign_in @user
        user_params = attributes_for(:user, name: '')
        patch user_path(@user), params: { user: user_params }
      end
      it 'ユーザー情報更新に失敗する' do
        expect(@user.reload.name).to eq @user.name
      end
      it 'リクエストが正常' do
        expect(response).to have_http_status(200)
      end
    end
    context '他人のプロフィール' do
      before do
        @user = create(:user)
        @other_user = create(:user, name: "other")
        sign_in @user
        user_params = attributes_for(:user, name: 'test2')
        patch user_path(@other_user), params: { user: user_params }
      end
      it '他人の投稿は編集出来ない' do
        expect(@other_user.reload.name).to eq 'other'
      end
      it 'リクエストが正常' do
        expect(response).to have_http_status(302)
      end
      it 'マイページに遷移する' do
        expect(response).to redirect_to user_path(@user)
      end
    end
  end
end