FactoryBot.define do
  factory :notification do
    visited_id { Faker::Number.non_zero_digit }
    visitor_id { Faker::Number.non_zero_digit }
    action { 'comment' }
    checked { true }
  end
end