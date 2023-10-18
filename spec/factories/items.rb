FactoryBot.define do
  factory :item do
    name { Faker::Dessert.variety }
    description { Faker::Dessert.flavor }
    unit_price { Faker::Number.between(from: 1, to: 10) }
    merchant_id { Faker::Number.between(from: 1, to: 1000).unique }
  end
end