FactoryBot.define do
  factory :product do
    name { Faker::Company.name }
    insurer
  end
end
