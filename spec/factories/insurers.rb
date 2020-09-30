FactoryBot.define do
  factory :insurer do
    name { Faker::Company.name }
  end

  trait :with_individual_product do
    after(:create) do |insurer|
      create :product, insurer: insurer
    end
  end

  trait :with_corporate_product do
    after(:create) do |insurer|
      create :product, customer_type: 'corporate', insurer: insurer
    end
  end
end
