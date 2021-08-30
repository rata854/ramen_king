# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, "Storeモデルのテスト", type: :model do

  describe 'バリデーションのテスト' do
    let!(:store) { create(:store) }
    context '登録ができるか' do
      it "全ての店舗情報があれば登録できる" do
        expect(store).to be_valid
      end
    end

    context 'store_nameカラム' do
      it '空白だと登録できない' do
        store = build(:store, store_name: '')
        expect(store).not_to be_valid
        expect(store.errors[:store_name]).to include("を入力してください")
      end
      it '50字以下であること（50字は◯）' do
        store_name = Faker::Lorem.characters(number: 50)
        store = build(:store, store_name: store_name)
        expect(store).to be_valid
      end
      it '50字以下であること（51字は☓）' do
        store_name = Faker::Lorem.characters(number: 51)
        store = build(:store, store_name: store_name)
        expect(store).not_to be_valid
        expect(store.errors[:store_name]).to include("は50文字以内で入力してください")
      end
    end

    context 'menuカラム' do
      it '空白だと登録できない' do
        store = build(:store, menu: '')
        expect(store).not_to be_valid
        expect(store.errors[:menu]).to include("を入力してください")
      end
      it '100字以下であること（100字は◯）' do
        menu = Faker::Lorem.characters(number: 100)
        store = build(:store, menu: menu)
        expect(store).to be_valid
      end
      it '100字以下であること（101字は☓）' do
        menu = Faker::Lorem.characters(number: 101)
        store = build(:store, menu: menu)
        expect(store).not_to be_valid
        expect(store.errors[:menu]).to include("は100文字以内で入力してください")
      end
    end

    context 'postal_codeカラム' do
      it '空白だと登録できない' do
        store = build(:store, postal_code: '')
        expect(store).not_to be_valid
        expect(store.errors[:postal_code]).to include("を入力してください", "は数値で入力してください", "は7文字で入力してください")
      end
      it '整数のみで入力されているか' do
        store = build(:store, postal_code: 'y00y000')
        expect(store).not_to be_valid
        expect(store.errors[:postal_code]).to include("は数値で入力してください")
      end
      it '7桁以外は登録出来ない（6桁は☓）' do
        store = build(:store, postal_code: 123456)
        expect(store).not_to be_valid
        expect(store.errors[:postal_code]).to include("は7文字で入力してください")
      end
      it '7桁以外は登録出来ない（7桁は○）' do
        store = build(:store, postal_code: 1234567)
        expect(store).to be_valid
      end
      it '7桁以外は登録出来ない（8桁は☓）' do
        store = build(:store, postal_code: 12345678)
        expect(store).not_to be_valid
        expect(store.errors[:postal_code]).to include("は7文字で入力してください")
      end
    end

    context 'addressカラム' do
      it '空白だと登録できない' do
        store = build(:store, address: '')
        expect(store).not_to be_valid
        expect(store.errors[:address]).to include("を入力してください")
      end
      it '50字以下であること（50字は◯）' do
        address = Faker::Lorem.characters(number: 50)
        store = build(:store, address: address)
        expect(store).to be_valid
      end
      it '50字以下であること（51字は☓）' do
        address = Faker::Lorem.characters(number: 51)
        store = build(:store, address: address)
        expect(store).not_to be_valid
        expect(store.errors[:address]).to include("は50文字以内で入力してください")
      end
    end

    context 'transportationカラム' do
      it '空白だと登録できない' do
        store = build(:store, transportation: '')
        expect(store).not_to be_valid
        expect(store.errors[:transportation]).to include("を入力してください")
      end
      it '50字以下であること（50字は◯）' do
        transportation = Faker::Lorem.characters(number: 50)
        store = build(:store, transportation: transportation)
        expect(store).to be_valid
      end
      it '50字以下であること（51字は☓）' do
        transportation = Faker::Lorem.characters(number: 51)
        store = build(:store, transportation: transportation)
        expect(store).not_to be_valid
        expect(store.errors[:transportation]).to include("は50文字以内で入力してください")
      end
    end

    context 'business_dayカラム' do
      it '空白だと登録できない' do
        store = build(:store, business_day: '')
        expect(store).not_to be_valid
        expect(store.errors[:business_day]).to include("を入力してください")
      end
      it '50字以下であること（50字は◯）' do
        business_day = Faker::Lorem.characters(number: 50)
        store = build(:store, business_day: business_day)
        expect(store).to be_valid
      end
      it '50字以下であること（51字は☓）' do
        business_day = Faker::Lorem.characters(number: 51)
        store = build(:store, business_day: business_day)
        expect(store).not_to be_valid
        expect(store.errors[:business_day]).to include("は50文字以内で入力してください")
      end
    end

    context 'holidayカラム' do
      it '空白だと登録できない' do
        store = build(:store, holiday: '')
        expect(store).not_to be_valid
        expect(store.errors[:holiday]).to include("を入力してください")
      end
      it '10字以下であること（10字は◯）' do
        holiday = Faker::Lorem.characters(number: 10)
        store = build(:store, holiday: holiday)
        expect(store).to be_valid
      end
      it '10字以下であること（11字は☓）' do
        holiday = Faker::Lorem.characters(number: 11)
        store = build(:store, holiday: holiday)
        expect(store).not_to be_valid
        expect(store.errors[:holiday]).to include("は10文字以内で入力してください")
      end
    end
  end

  describe 'アソシエーションのテスト' do
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

  describe 'ランキングメソッドのテスト' do
    let!(:user) { create(:user) }
    before do
      @miso = 'みそ'
    end
    let!(:low_score_store) { create(:store) }
    let!(:low_score_comments) { create_list(:store_comment, 5, user_id: user.id, store_id: low_score_store.id, genre: @miso, rate: 2.0 ) }
    let!(:middle_score_store) { create(:store) }
    let!(:middle_score_comments) { create_list(:store_comment, 5, user_id: user.id, store_id: middle_score_store.id, genre: @miso, rate: 3.0 ) }
    let!(:high_score_store) { create(:store) }
    let!(:high_score_comments) { create_list(:store_comment, 5, user_id: user.id, store_id: high_score_store.id, genre: @miso, rate: 4.0 ) }

    describe 'メソッドの動作に関するテスト' do
      context '昇順入れ替えのテスト' do
        it '平均点が高い順に入れ替えられている(store_ranking)' do
          expect(Store.store_ranking).to eq [high_score_store, middle_score_store, low_score_store]
        end
        it '平均点が高い順に入れ替えられている(ranking_by_genre)' do
          expect(Store.ranking_by_genre(@miso)).to eq [high_score_store, middle_score_store, low_score_store]
        end
        it '平均点が高い順に入れ替えられている(my_ranking)' do
          expect(Store.my_ranking(user)).to eq [high_score_store, middle_score_store, low_score_store]
        end
      end
      context'計算方法のテスト' do
        let!(:many_comments_store) { create(:store) }
        let!(:many_comments) { create_list(:store_comment, 25, user_id: user.id, store_id: many_comments_store.id, genre: @miso, rate: 1.0 ) }

        it '合計点ではなく平均点で計算されている(store_ranking)' do
          expect(Store.store_ranking).to eq [high_score_store, middle_score_store, low_score_store, many_comments_store]
        end
        it '合計点ではなく平均点で計算されている(ranking_by_genre)' do
          expect(Store.ranking_by_genre(@miso)).to eq [high_score_store, middle_score_store, low_score_store, many_comments_store]
        end
        it '合計点ではなく平均点で計算されている(my_ranking)' do
          expect(Store.my_ranking(user)).to eq [high_score_store, middle_score_store, low_score_store, many_comments_store]
        end
      end
    end

    describe 'メソッドの制限に関するテスト' do
      context '共通の制限に関するテスト' do
        let!(:clised_store) { create(:store, business_status: '閉店') }
        let!(:clised_comments) { create_list(:store_comment, 5, user_id: user.id, store_id: clised_store.id, genre: @miso, rate: 3.0 ) }
        let!(:shutdown_store) { create(:store, business_status: '休業中') }
        let!(:shutdown_comments) { create_list(:store_comment, 5, user_id: user.id, store_id: shutdown_store.id, genre: @miso, rate: 3.0 ) }

        it '店舗ステータスが営業中でないとランクインされない(store_ranking)' do
          expect(Store.store_ranking).to eq [high_score_store, middle_score_store, low_score_store]
        end
        it '店舗ステータスが営業中でないとランクインされない(ranking_by_genre)' do
          expect(Store.ranking_by_genre(@miso)).to eq [high_score_store, middle_score_store, low_score_store]
        end
        it '店舗ステータスが営業中でないとランクインされない(my_ranking)' do
          expect(Store.my_ranking(user)).to eq [high_score_store, middle_score_store, low_score_store]
        end
      end
      context 'store_rankingの制限に関するテスト' do
        let!(:few_comments_store) { create(:store) }
        let!(:few_comments) { create_list(:store_comment, 4, store_id: few_comments_store.id, genre: @miso, rate: 3.0 ) }

        it 'コメントの件数が5件以上でないとランクインされない（4件以下は☓）' do
          expect(Store.store_ranking).to eq [high_score_store, middle_score_store, low_score_store]
        end
      end
      context 'ranking_by_genreの制限に関するテスト' do
        before do
          @soy_sauce = 'しょうゆ'
        end
        let!(:soy_sauce_store) { create(:store) }
        let!(:soy_sauce_comments) { create_list(:store_comment, 3, store_id: soy_sauce_store.id, genre: @soy_sauce, rate: 3.0 ) }

        it '指定したジャンル別にランキング結果が表示される（しょうゆ）' do
          expect(Store.ranking_by_genre(@soy_sauce)).to eq [soy_sauce_store]
        end
        it '指定したジャンル別にランキング結果が表示される（みそ）' do
          expect(Store.ranking_by_genre(@miso)).to eq [high_score_store, middle_score_store, low_score_store]
        end
      end
      context 'my_rankingの制限に関するテスト' do
        let!(:other_user) { create(:user) }
        let!(:other_comments_store) { create(:store) }
        let!(:other_comments) { create_list(:store_comment, 3, user_id: other_user.id, store_id: other_comments_store.id, genre: @miso, rate: 3.0 ) }

        it 'userの投稿のみランキング結果が表示される' do
          expect(Store.my_ranking(user)).to eq [high_score_store, middle_score_store, low_score_store]
        end
        it 'other_userの投稿のみランキング結果が表示される' do
          expect(Store.my_ranking(other_user)).to eq [other_comments_store]
        end
      end
    end
  end
end