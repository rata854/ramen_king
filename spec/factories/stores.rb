FactoryBot.define do
  factory :store do
    store_name { '麺匠田端' }
    menu { 'しょうゆラーメン700円' }
    postal_code { '0000000' }
    address { '東京都渋谷区千駄ヶ谷駅' }
    transportation { 'password' }
    business_day { '[月〜土]10:00~20:00' }
    holiday { '日曜日' }
    latitude { 35.6812396 }
    longitude { 139.7116285 }
  end
end
