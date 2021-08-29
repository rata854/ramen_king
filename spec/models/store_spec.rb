# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, "Storeモデルのテスト", type: :model do
  before do
    @store = create(:store)
  end

  describe 'バリデーションのテスト' do
    context '登録ができるか' do
      it "全ての店舗情報があれば登録できる" do
        expect(@store).to be_valid
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

  describe 'メソッドのテスト' do
    before do
      @user = create(:user)
      @other_user = create(:user)
      @miso = 'みそ'
      @soy_sauce = 'しょうゆ'
      store_comments = create_list(:store_comment, 5, user_id: @user.id, store_id: @store.id, genre: @miso, rate: 3.5)
      @middle_score_store = create(:store)
      middle_score_comments = create_list(:store_comment, 5, user_id: @user.id, store_id: @middle_score_store.id, genre: @miso, rate: 4.0)
      @high_score_store = create(:store)
      high_score_comments = create_list(:store_comment, 5, user_id: @user.id, store_id: @high_score_store.id, genre: @miso, rate: 4.5)
      @clised_store = create(:store, business_status: '閉店')
      clised_store_comments = create_list(:store_comment, 5, user_id: @user.id, store_id: @clised_store.id, genre: @miso, rate: 3.0)
      @shutdown_store = create(:store, business_status: '休業中')
      shutdown_store_comments = create_list(:store_comment, 5, user_id: @user.id, store_id: @shutdown_store.id, genre: @miso, rate: 3.0)
    end

    describe 'store_rankingメソッドのテスト' do
      context 'store_rankingの動作テスト' do
        before do
          @store_ranking = Store.store_ranking
        end
        it 'コメントの平均点数で昇順に入れ替えられている' do
          expect(@store_ranking).to eq [@high_score_store, @middle_score_store, @store]
        end
        it 'コメントの平均点数が計算できている' do
          # binding.pry
          # expect(@store.store_comments.pluck(:rate)).to eq [4.5, 4.0, 3.5]
          # expect(
          #   @store_ranking.each do |ranks|
          #       ranks.store_comments.average(:rate)
          #   end).to eq [4.5, 4.0, 3.5]
          # expect(@store_ranking).to eq [@high_score_store, @middle_score_store, @store, binding.pry]
        end
      end
      context 'store_rankingの制限に関するテスト' do
        before do
          @few_comment_store = create(:store)
          few_comments = create_list(:store_comment, 4, user_id: @user.id, store_id: @few_comment_store.id, genre: @miso, rate: 3.0)
        end

        it 'コメントの件数が5件以上でないとランクインされない（4件以下は☓）' do
          expect(@store_ranking).to eq [@high_score_store, @middle_score_store, @store]
        end
        it '店舗ステータスが営業中でないとランクインされない' do
          expect(@store_ranking).to eq [@high_score_store, @middle_score_store, @store]
        end
      end
    end

    describe 'ranking_by_genreメソッドのテスト' do
      context 'ranking_by_genreの動作テスト' do
        it 'コメントの平均点数で昇順に入れ替えられている' do
          expect(Store.ranking_by_genre(@miso)).to eq [@high_score_store, @middle_score_store, @store]
        end
        # it 'コメントの平均点数が計算できている' do
        # binding.pry
        #   expect(Store.ranking_by_genre).to eq [(@high_score_store.store_comments.rate 5.0),
        #   (@middle_score_store.store_comments.rate 4.0), (@store.store_comments.rate 3)]
        # end
      end
      context 'ranking_by_genreの制限に関するテスト' do
        before do
          @soy_sauce_store = create(:store)
          few_comments = create_list(:store_comment, 5, user_id: @user.id, store_id: @soy_sauce_store.id, genre: @soy_sauce, rate: 5.0)
        end
        it '指定したジャンル別にランキング結果が表示される（しょうゆ）' do
          expect(Store.ranking_by_genre(@soy_sauce)).to eq [@soy_sauce_store]
        end
        it '指定したジャンル別にランキング結果が表示される（みそ）' do
          expect(Store.ranking_by_genre(@miso)).to eq [@high_score_store, @middle_score_store, @store]
        end
        it '店舗ステータスが営業中でないとランクインされない' do
          expect(Store.ranking_by_genre(@miso)).to eq [@high_score_store, @middle_score_store, @store]
        end
      end
    end

    describe 'my_rankingメソッドのテスト' do
      context 'my_rankingの動作テスト' do
        it 'コメントの平均点数で昇順に入れ替えられている' do
          expect(Store.my_ranking(@user)).to eq [@high_score_store, @middle_score_store, @store]
        end
        # it 'コメントの平均点数が計算できている' do
        # # binding.pry
        #   expect(Store.my_ranking).to eq [(@high_score_store.store_comments.rate 5.0),
        #   (@middle_score_store.store_comments.rate 4.0), (@store.store_comments.rate 3)]
        # end
      end
      context 'my_rankingの制限に関するテスト' do
        before do
          @other_comment_store = create(:store)
          other_comments = create_list(:store_comment, 5, user_id: @other_user.id, store_id: @other_comment_store.id, genre: @miso, rate: 5.0)
        end
        it '自分の投稿のみランキング結果が表示される' do
          expect(Store.my_ranking(@user)).to eq [@high_score_store, @middle_score_store, @store]
        end
        it '他人の投稿のみランキング結果が表示される' do
          expect(Store.my_ranking(@other_user)).to eq [@other_comment_store]
        end
        it '店舗ステータスが営業中でないとランクインされない' do
          expect(Store.my_ranking(@user)).to eq [@high_score_store, @middle_score_store, @store]
        end
      end
    end
  end
end