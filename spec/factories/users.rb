FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    admin { false }
  end

  factory :admin_user do
    admin { true }
  end
end
