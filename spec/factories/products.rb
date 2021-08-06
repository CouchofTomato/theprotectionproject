FactoryBot.define do
  factory :product do
    name { Faker::Company.unique.name }
    customer_type { 'individual' }
    minimum_applicant_age { 18 }
    maximum_applicant_age { 80 }
    insurer
  end
end
