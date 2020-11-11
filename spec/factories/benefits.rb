FactoryBot.define do
  factory :benefit do
    name { Faker::Commerce.unique.product_name }
    category { 'inpatient' }
  end
end
