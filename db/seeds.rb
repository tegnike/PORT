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

users = User.order(:created_at).take(100)
10.times do
  users.each do |portfolio_user|
    portfolio_user.portfolios.create!(
      image: open("#{Rails.root}/db/fixtures/noimage.jpg"),
      title: "ポートフォリオ共有サイト | PORT",
      content: "PORTは、エンジニアが自身のポートフォリオを共有するためのサービスです。<br>他のエンジニアのポートフォリオを参考にしたり、レビューを依頼して、ポートフォリオのブラッシュアップに活用しましょう ;)",
      web_url: "http://port-port.herokuapp.com",
      git_url: "https://github.com/tegnike/PORT"
    )
  end
end

Portfolio.all.each do |portfolio|
  portfolio.progresses.create!(
    status: "release",
    content: "これはプログレスです。ポートフォリオに1対多の関係で作成される、進捗報告用のモデルです。ステータスごとに更新して、その都度評価をもらいましょう。<br>これはプログレスです。ポートフォリオに1対多の関係で作成される、進捗報告用のモデルです。ステータスごとに更新して、その都度評価をもらいましょう。"
  )
end

Progress.all.each do |progress|
  progress.comments.create!(
    user: progress.portfolio.user,
    comment: "これはコメントです。プログレスごとにコメントは管理されます。評価はあくまで個人における目安です。より良いポートフォリオ作りの参考にしましょう。<br>これはコメントです。プログレスごとにコメントは管理されます。評価はあくまで個人における目安です。より良いポートフォリオ作りの参考にしましょう。",
    evaluation: rand(0.0..5.0).round(1)
  )
  2.times do
    progress.comments.create!(
      user: User.find(rand(1..User.count)),
      comment: "これはコメントです。プログレスごとにコメントは管理されます。評価はあくまで個人における目安です。より良いポートフォリオ作りの参考にしましょう。<br>これはコメントです。プログレスごとにコメントは管理されます。評価はあくまで個人における目安です。より良いポートフォリオ作りの参考にしましょう。",
      evaluation: rand(0.0..5.0).round(1)
    )
  end
end

users.each do |favorite_user|
  portfolios = Portfolio.order("RANDOM()").limit(10)
  portfolios.each do |portfolio|
    favorite_user.add_favorite(portfolio)
  end
end
