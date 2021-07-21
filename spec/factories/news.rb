FactoryBot.define do
  factory :news do
    body { Faker::Lorem.characters(number:10) }
  end
end