FactoryBot.define do
  factory :product_module do
    name { 'Gold' }
    category { 'core' }
    sum_assured { 'USD 3,000,000 | EUR 3,200,000 | GBP 2,500,000' }
    product { nil }
  end
end
