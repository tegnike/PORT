User.create!(username:  "Example User",
             email: "test@example.com",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             confirmed_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@example.com"
  password = "password"
  User.create!(username:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               confirmed_at: Time.zone.now)
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

users = User.order(:created_at).take(6)
10.times do
  users.each do |portfolio_user|
    portfolio_user.portfolios.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      content: Faker::Lorem.sentence(word_count: 20),
      image: open("#{Rails.root}/db/fixtures/rails.png"),
      web_url: "http://port-port.herokuapp.com",
      git_url: "http://port-port.herokuapp.com"
    )
  end
end

Portfolio.all.each do |portfolio|
  portfolio.progresses.create!(
    content: Faker::Lorem.sentence(word_count: 20)
  )
end

users.each do |favorite_user|
  portfolios = Portfolio.order("RANDOM()").limit(10)
  portfolios.each do |portfolio|
    favorite_user.add_favorite(portfolio)
  end
end
