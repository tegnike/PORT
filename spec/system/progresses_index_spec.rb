require "rails_helper"

RSpec.describe "ProgressesIndexTest", type: :system, js: true do
  describe "progress index page" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:portfolio) { create(:portfolio, user: user) }
    before {
      create_list(:progress, 10, portfolio: portfolio)
      progresses = portfolio.progresses.order(created_at: :desc)
      n = 0
      progresses.each do |progress|
        3.times do
          progress.comments.create!(user_id: user2.id, comment: "test", evaluation: n)
          n += 1
        end
      end
      login(user)
      visit portfolio_progresses_path(portfolio)
    }
    it "shows correct progress order" do
      (0..9).each do |n|
        expect(page.all("ol li")[n]).to have_content "##{10 - n}"
      end
    end
    it "shows average evaluation" do
      (0..9).each do |n|
        expect(page.all("ol li")[n]).to have_content "評価：#{"%0.1f" % (1 + n * 3)}"
        expect(page.all("ol li")[n]).to have_content "（3 件）"
      end
    end
  end
end
