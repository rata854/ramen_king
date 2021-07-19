FactoryBot.define do
  factory :store_comment do
    title { Faker::Lorem.characters(number: 20) }
    introduction { Faker::Lorem.characters(number: 1000) }
    rate { '3.5' }
    genre { 'みそ' }
  end
end