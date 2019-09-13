FactoryBot.define do
  password = Faker::Internet.password(min_length: 8)

  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.email }
    password { password }
    password_confirmation { password }
    confirmed_at { Time.zone.now }
  end
end
