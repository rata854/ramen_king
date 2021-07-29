# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

address = [
  "東京都千代田区鍛冶町2丁目",
  "東京都渋谷区恵比寿南1丁目",
  "東京都渋谷区道玄坂2丁目",
  "東京都渋谷区神宮前1丁目",
  "東京都渋谷区代々木1丁目",
  "東京都新宿区新宿3丁目",
  "東京都豊島区南池袋1丁目",
  "東京都荒川区西日暮里2丁目",
  "東京都千代田区外神田1丁目",
  ]

stations = [
  "新橋",
  "恵比寿",
  "渋谷",
  "原宿",
  "代々木",
  "新宿",
  "池袋",
  "日暮里",
  "秋葉原",
  "神田",
  "大阪",
  "名古屋",
  "博多",
  "札幌",
  "仙台"
  ]
  
  address = [
  "東京都港区新橋2丁目",
  "東京都渋谷区恵比寿南1丁目",
  "東京都渋谷区道玄坂1丁目",
  "東京都渋谷区神宮前1丁目",
  "東京都渋谷区代々木1丁目",
  "東京都新宿区新宿3丁目",
  "東京都豊島区南池袋1丁目",
  "東京都荒川区西日暮里2丁目",
  "東京都千代田区外神田1丁目",
  "東京都千代田区鍛治町2丁目",
  "大阪府大阪市北区梅田3丁目",
  "愛知県名古屋市中村区名駅１丁目",
  "福岡県福岡市博多区博多駅中央街",
  "北海道札幌市北区北６条西４丁目",
  "宮城県仙台市青葉区中央１丁目"
  ]

15.times do |i|
  Store.create!(
    store_name: "#{stations[i]}商店",
    menu: 'しょうゆラーメン 750円''みそラーメン 800円''塩ラーメン 700円''とんこつラーメン 750円''ライス 100円',
    postal_code: '0000000',
    address: "#{address[i]}",
    transportation: "#{stations[i]}駅より徒歩5分",
    business_day: '[火〜土11:00~20:00][日]11：00~15:00',
    holiday: '月曜日'
  )
end

