FactoryBot.define do
  factory :insurer do
    name { Faker::Company.name }
  end
end
