require 'rails_helper'

RSpec.describe "Users", type: :request_spec do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user) 
      
    context 'showアクション' do
      it 'レスポンスコードが成功か' do
        # sign_in @user
        # get user_path(@user)
        # expect(response).to have_http_status(200)
      end
    end
    
    end
  
end