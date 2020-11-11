FactoryBot.define do
  factory :product do
    name { Faker::Company.unique.name }
    customer_type { 'individual' }
    insurer
  end
end
