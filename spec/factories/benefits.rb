FactoryBot.define do
  factory :benefit do
    name { Faker::Commerce.product_name }
    category { 'inpatient' }
  end
end
