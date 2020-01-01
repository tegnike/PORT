require "rails_helper"

RSpec.describe "PageviewRanking", type: :system, js: true do
  describe "pageview ranking page" do
    let(:user) { create(:user) }
    before {
      create_list(:user, 6)
      create_list(:portfolio, 3, user: user)
      Portfolio.all.each { |portfolio| create(:progress, portfolio: portfolio) }
      users = User.all
      n = 2
      users[0..2].each do |u|
        login(u)
        (0..n).each { |m| visit portfolio_path(user.portfolios[m]) }
        logout
        n -= 1
      end
      travel_to(Time.current.since(3.month)) do
        n = 2
        users[3..5].each do |u|
          login(u)
          (0..n).each { |m| visit portfolio_path(user.portfolios[m]) }
          logout
          n -= 1
        end
      end
    }
    after(:all) {
      DatabaseCleaner[:redis].clean
    }

    it "shows correct ranking order in total_pv ranking" do
      travel_to(Time.current.since(3.month)) do
        visit rankings_total_pv_path
        (0..2).each do |n|
          expect(page.all("ol li")[n]).to have_content "#{6 - 2 * n} views"
        end
      end
    end
    it "shows correct ranking order in weekly_pv ranking" do
      travel_to(Time.current.since(3.month)) do
        visit rankings_weekly_pv_path
        (0..2).each do |n|
          expect(page.all("ol li")[n]).to have_content "#{3 - n} views"
        end
      end
    end
  end
end
