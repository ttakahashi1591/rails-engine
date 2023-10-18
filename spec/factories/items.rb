FactoryBot.define do
  factory :item do
    name { Faker::Dessert.variety }
    description { Faker::Dessert.flavor }
    unit_price { Faker::Number.between(from: 1, to: 10) }

    association :merchant, factory: :merchant
  end
end