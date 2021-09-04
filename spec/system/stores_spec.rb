# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stores', type: :system do
  let!(:user) { create(:user) }
  let!(:store) { create(:store) }

  describe 'ログイン前' do
    describe '店舗一覧画面のテスト' do
      before do
        visit stores_path
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores'
        end
        it 'ログインしてないと店舗詳細画面へのリンクは存在しない' do
          expect(page).not_to have_link '新規店舗登録'
        end
      end
    end

    describe '店舗詳細画面' do
      before do
        visit store_path(store)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores/' + store.id.to_s
        end
        it 'ログインしてないと店舗編集画面へのリンクが存在しない' do
          expect(page).not_to have_link '店舗情報編集'
        end
        it 'ログインしてないと口コミ投稿画面へのリンクが存在しない' do
          expect(page).not_to have_link '新規口コミ作成'
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe '店舗一覧画面のテスト' do
      before do
        visit stores_path
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores'
        end
        it 'ログインしてると店舗詳細画面へのリンクが存在する' do
          expect(page).to have_link '新規店舗登録'
        end
      end
    end

    describe '店舗詳細画面' do
      before do
        visit store_path(store)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores/' + store.id.to_s
        end
        it 'ログインしてると店舗編集画面へのリンクが存在する' do
          expect(page).to have_link '店舗情報編集'
        end
        it 'ログインしてると口コミ投稿画面へのリンクが存在する' do
          expect(page).to have_link '新規口コミ作成'
        end
      end
    end

    describe '店舗登録編集画面のテスト' do
      before do
        visit new_store_path
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores/new'
        end
        it '店舗名フォームが表示されている' do
          expect(page).to have_field 'store[store_name]'
        end
        it '郵便番号フォームが表示されている' do
          expect(page).to have_field 'store[postal_code]'
        end
        it '店舗住所フォームが表示されている' do
          expect(page).to have_field 'store[address]'
        end
        it '交通手段フォームが表示されている' do
          expect(page).to have_field 'store[transportation]'
        end
        it 'メニューフォームが表示されている' do
          expect(page).to have_field 'store[menu]'
        end
        it '営業日フォームが表示されている' do
          expect(page).to have_field 'store[business_day]'
        end
        it '定休日フォームが表示されている' do
          expect(page).to have_field 'store[holiday]'
        end
        it 'Create Storeボタンが表示されている' do
          expect(page).to have_button 'Create Store'
        end
      end

      context '店舗登録のテスト' do
        before do
          fill_in 'store[store_name]', with: Faker::Lorem.characters(number: 5)
          fill_in 'store[postal_code]', with: '7654321'
          fill_in 'store[address]', with: '北海道札幌市中央'
          fill_in 'store[menu]', with: 'みそラーメン750円'
          fill_in 'store[transportation]', with: '大通り駅より徒歩5分'
          fill_in 'store[business_day]', with: '[月〜土 10:00~20:00]'
          fill_in 'store[holiday]', with: '日曜日'
        end

        it '正しく登録される' do
          expect { click_button 'Create Store' }.to change(Store.all, :count).by(1)
        end
        it '店舗登録後、登録した店舗詳細画面へ遷移してる' do
          click_button 'Create Store'
          expect(current_path).to eq '/stores/' + Store.last.id.to_s
        end
      end
    end

    describe '新規店舗登録画面のテスト' do
      before do
        visit edit_store_path(store)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/stores/' + store.id.to_s + '/edit'
        end
        it '店舗名編集フォームが表示されている' do
          expect(page).to have_field 'store[store_name]', with: store.store_name
        end
        it '郵便番号編集フォームが表示されている' do
          expect(page).to have_field 'store[postal_code]', with: store.postal_code
        end
        it '店舗住所編集フォームが表示されている' do
          expect(page).to have_field 'store[address]', with: store.address
        end
        it '交通手段編集フォームが表示されている' do
          expect(page).to have_field 'store[transportation]', with: store.transportation
        end
        it 'メニュー編集フォームが表示されている' do
          expect(page).to have_field 'store[menu]', with: store.menu
        end
        it '営業日編集フォームが表示されている' do
          expect(page).to have_field 'store[business_day]', with: store.business_day
        end
        it '定休日編集フォームが表示されている' do
          expect(page).to have_field 'store[holiday]', with: store.holiday
        end
        it 'Update Storeボタンが表示されている' do
          expect(page).to have_button 'Update Store'
        end
      end

      context '店舗登録編集のテスト' do
        before do
          fill_in 'store[store_name]', with: Faker::Lorem.characters(number: 5)
          fill_in 'store[postal_code]', with: '1234567'
          fill_in 'store[address]', with: '東京都渋谷区千駄ヶ谷'
          fill_in 'store[menu]', with: 'しょうゆラーメン700円'
          fill_in 'store[transportation]', with: '千駄ヶ谷駅より徒歩5分'
          fill_in 'store[business_day]', with: '[火〜日 11:00~21:00]'
          fill_in 'store[holiday]', with: '月曜日'
        end

        it '店舗編集登録後、登録した店舗詳細画面へ遷移してる' do
          click_button 'Update Store'
          expect(current_path).to eq '/stores/' + store.id.to_s
        end
      end
    end
  end

  describe '店舗検索画面のテスト' do
    context '表示の確認' do
      before do
        visit search_path
      end

      it 'URLが正しい' do
        expect(current_path).to eq '/search'
      end
    end

    context '検索機能の確認' do
      let!(:miso_store) { create(:store) }
      let!(:miso_comments) { :store_comment }

      before do
        visit stores_path
      end

      it '検索ワードを選択すると、選択したワードのページに遷移する' do
        select '評価順', from: 'keyword'
        select 'みそ', from: 'genre'
        click_button '検索'
        expect(current_path).to eq '/search'
        expect(page).to eq miso_store.store_name
      end
    end
  end
end
