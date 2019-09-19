FactoryBot.define do
  factory :portfolio do
    user
    sequence(:title) { |n| "Example title #{n}" }
    sequence(:content) { |n| "Example content #{n}" }
    image { Rack::Test::UploadedFile.new(Rails.root.join("spec/factories/rails.png"), "image/png") }
    sequence(:web_url) { |n| "http://example/web_url_#{n}" }
    sequence(:git_url) { |n| "http://example/git_url_#{n}" }
  end
end
