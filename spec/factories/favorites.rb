FactoryBot.define do
  factory :favorite do
    association :store_comment
    user { store_comment.user }
  end
end
