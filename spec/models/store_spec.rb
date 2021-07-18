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
        expect(store).to_not be_valid
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
        expect(store).to_not be_valid
        expect(store.errors[:store_name]).to include(("is too long (maximum is 15 characters)"))
      end
    end

    context 'postal_codeカラム' do
      it '空白だと登録できない' do
        store = build(:store, postal_code: '')
        expect(store).to_not be_valid
        expect(store.errors[:postal_code]).to include("can't be blank")
      end
      
      it '整数のみで入力されているか' do
        store = build(:store, postal_code: 'y00y000')
        expect(store.postal_code.integer?).to eq(true)
        expect(store.errors[:postal_code]).to include("can't be blank")
      end
      
      it '7桁で入力されているか' do
        expect(@store.postal_code.length).to eq(7)
      end
    end
    
    context 'addressカラム' do
      it '空白だと登録できない' do
        store = build(:store, address: '')
        expect(store).to_not be_valid
        expect(store.errors[:address]).to include("can't be blank")
      end
    end
    
    context 'transportationカラム' do
      it '空白だと登録できない' do
        store = build(:store, transportation: '')
        expect(store).to_not be_valid
        expect(store.errors[:transportation]).to include("can't be blank")
      end
    end
    
    context 'business_dayカラム' do
      it '空白だと登録できない' do
        store = build(:store, business_day: '')
        expect(store).to_not be_valid
        expect(store.errors[:business_day]).to include("can't be blank")
      end
    end
    
    context 'holidayカラム' do
      it '空白だと登録できない' do
        store = build(:store, holiday: '')
        expect(store).to_not be_valid
        expect(store.errors[:holiday]).to include("can't be blank")
      end
    end

  end
end