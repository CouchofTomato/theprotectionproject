FactoryBot.define do
  factory :product_module_benefit do
    product_module
    benefit
    benefit_status { 'paid in full' }
    benefit_limit { 'USD 1,000,000 | EUR 1,000,000 | GBP 850,000' }
    explanation_of_benefit { 'Within overall limit' }
  end
end
