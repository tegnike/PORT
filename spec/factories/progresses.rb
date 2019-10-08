FactoryBot.define do
  factory :progress do
    portfolio
    sequence(:content) { |n| "Example content #{n}" }
  end
end
