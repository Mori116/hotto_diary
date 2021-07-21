FactoryBot.define do
  factory :user do
    last_name { Faker::Lorem.characters(number: 10) }
    first_name { Faker::Lorem.characters(number: 10) }
    last_name_kana { "タナカ" }
    first_name_kana { "タロウ" }
    email { Faker::Internet.email }
    nickname  { Faker::Lorem.characters(number: 10) }
    is_deleted { false }
    password { 'password' }
    password_confirmation { 'password' }
  end
end