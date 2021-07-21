FactoryBot.define do
  factory :group do
    name { Faker::Lorem.characters(number:10) }
    owner_id { Faker::Number.non_zero_digit }
    password { 'password' }
    password_confirmation { 'password' }
  end
end