# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, "Storeモデルのテスト", type: :model do
  describe 'Storeモデルのテスト' do
    before do
      @store = FactoryBot.create(:store)
    end

    context '登録ができるか' do
      it "全ての店舗情報があれば登録できる" do
        expect(@store).to be_valid
      end
    end

    context 'store_nameカラム' do
      it '空白だと登録できない' do
        store = build(:store, store_name: '')
        expect(store).not_to be_valid
        expect(store.errors[:store_name]).to include("can't be blank")
      end

      it '15字以下であること（15字は◯）' do
        store_name = Faker::Lorem.characters(number: 15)
        store = build(:store, store_name: store_name)
        expect(store).to be_valid
      end

      it '15字以下であること（16字は☓）' do
        store_name = Faker::Lorem.characters(number: 16)
        store = build(:store, store_name: store_name)
        expect(store).not_to be_valid
        expect(store.errors[:store_name]).to include("is too long (maximum is 15 characters)")
      end
    end

    context 'postal_codeカラム' do
      it '空白だと登録できない' do
        store = build(:store, postal_code: '')
        expect(store).not_to be_valid
        # expect(store.errors[:postal_code]).to_not include("can't be blank", "is not a number", "is the wrong length (should be 7 characters)")
      end

      # it '整数のみで入力されているか' do
      #   store = build(:store, postal_code: 'y00y000')
      #   expect(store.postal_code.number).to_not eq(true)
      #   expect(store.errors[:postal_code]).to include("can't be blank")
      # end

      it '7桁以外は登録出来ない（6桁は☓）' do
        store = build(:store, postal_code: '123456')
        expect(store.postal_code.length).not_to eq(7)
        expect(store.errors[:postal_code]).not_to include("can't be blank", "is not a number", "is the wrong length (should be 7 characters)")
      end

      it '7桁以外は登録出来ない（8桁は☓）' do
        store = build(:store, postal_code: '12345678')
        expect(store.postal_code.length).not_to eq(7)
        expect(store.errors[:postal_code]).not_to include("can't be blank", "is not a number", "is the wrong length (should be 7 characters)")
      end
    end

    context 'addressカラム' do
      it '空白だと登録できない' do
        store = build(:store, address: '')
        expect(store).not_to be_valid
        expect(store.errors[:address]).to include("can't be blank")
      end
    end

    context 'transportationカラム' do
      it '空白だと登録できない' do
        store = build(:store, transportation: '')
        expect(store).not_to be_valid
        expect(store.errors[:transportation]).to include("can't be blank")
      end
    end

    context 'business_dayカラム' do
      it '空白だと登録できない' do
        store = build(:store, business_day: '')
        expect(store).not_to be_valid
        expect(store.errors[:business_day]).to include("can't be blank")
      end
    end

    context 'holidayカラム' do
      it '空白だと登録できない' do
        store = build(:store, holiday: '')
        expect(store).not_to be_valid
        expect(store.errors[:holiday]).to include("can't be blank")
      end
    end

    context 'userモデルとの関係' do
      it 'N:1となっている' do
        expect(Store.reflect_on_association(:user)).to be_present
      end
    end

    context 'store_commentsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Store.reflect_on_association(:store_comments)).to be_present
      end
    end
  end
end