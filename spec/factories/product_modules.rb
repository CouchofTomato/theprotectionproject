FactoryBot.define do
  factory :product_module do
    name { Faker::Commerce.product_name }
    category { 'core' }
    sum_assured { 'USD 3,000,000 | EUR 3,200,000 | GBP 2,500,000' }
    product
  end
end
