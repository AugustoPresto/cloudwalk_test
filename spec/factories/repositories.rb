FactoryBot.define do
  factory :repository do
    name { Faker::App.name }
    stars { Faker::Number.number(digits: 3) }
    association :user
  end
end
