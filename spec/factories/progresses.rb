FactoryBot.define do
  factory :progress do
    portfolio
    status { 3 }
    sequence(:content) { |n| "Example content #{n}" }
  end
end
