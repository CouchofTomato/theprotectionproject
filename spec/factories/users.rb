FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.unique.password }
    admin { false }

    factory :admin_user do
      admin { true }
    end
  end
end
