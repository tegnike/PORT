FactoryBot.define do
  factory :portfolio do
    user
    sequence(:title) { |n| "Example title #{n}" }
    sequence(:content) { |n| "Example content #{n}" }
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/factories/rails.png"), "image/png") }
    sequence(:web_url) { |n| "Example web_url #{n}" }
    sequence(:git_url) { |n| "Example git_url #{n}" }
  end
end
