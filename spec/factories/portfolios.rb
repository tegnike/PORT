FactoryBot.define do
  factory :portfolio do
    user
    sequence(:title) { |n| "Example title #{n}" }
    content { "content" }
    image { "image" }
    web_url { "web_url" }
    git_url { "git_url" }
  end
end
