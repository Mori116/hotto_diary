FactoryBot.define do
  factory :diary do
    title { Faker::Lorem.characters(number:10) }
    body { Faker::Lorem.characters(number:40) }
    status { false }
  end
end