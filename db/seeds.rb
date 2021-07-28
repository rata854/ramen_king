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
  "神田"]

10.times do |i|
  Store.create!(
    store_name: "#{stations[i]}商店",
    menu: 'しょうゆラーメン 750円''みそラーメン800円''塩ラーメン700円''とんこつラーメン750円',
    postal_code: '0000000',
    address: "#{address[i]}",
    transportation: "#{stations[i]}駅より徒歩5分",
    business_day: '[火〜土11:00~20:00][日]11：00~15:00',
    holiday: '月曜日'
  )
end

