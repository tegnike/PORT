require "rails_helper"

RSpec.describe "PageviewRanking", type: :system, js: true do
  describe "pageview ranking page" do
    let(:user) { create(:user) }
    before {
      create_list(:user, 30)
      create_list(:portfolio, 20, user_id: user.id)
      Portfolio.all.each { |portfolio| create(:progress, portfolio: portfolio) }
      users = User.all
      n = 19
      users[0..19].each do |u|
        login(u)
        (0..n).each { |m| visit portfolio_path(user.portfolios[m]) }
        logout
        n -= 1
      end
      travel_to(Time.current.since(3.month)) do
        n = 9
        users[20..29].each do |u|
          login(u)
          (0..n).each { |m| visit portfolio_path(user.portfolios[m]) }
          logout
          n -= 1
        end
      end
    }
    subject(:total_pv) { visit rankings_total_pv_path }
    subject(:weekly_pv) { visit rankings_weekly_pv_path }
    it "shows correct ranking order in total_pv ranking" do
      travel_to(Time.current.since(3.month)) do
        total_pv
        (0..9).each do |n|
          expect(page.all("ol li")[n]).to have_content "#{30 - 2 * n} views"
        end
      end
    end
    it "shows correct ranking order in weekly_pv ranking" do
      travel_to(Time.current.since(3.month)) do
        weekly_pv
        (0..9).each do |n|
          expect(page.all("ol li")[n]).to have_content "#{10 - n} views"
        end
      end
    end
  end
end
