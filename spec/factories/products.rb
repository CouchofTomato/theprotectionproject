FactoryBot.define do
  factory :product do
    name { Faker::Company.name }
    customer_type { 'individual' }
    insurer
  end
end
