FactoryBot.define do
  factory :progress do
    portfolio
    sequence(:title) { |n| "Example title #{n}" }
    sequence(:content) { |n| "Example content #{n}" }
  end
end
