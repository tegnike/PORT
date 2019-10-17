FactoryBot.define do
  factory :comment do
    user
    progress
    sequence(:comment) { |n| "Example content #{n}" }
    evaluation { 1.5 }
  end
end
