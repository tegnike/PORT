require "rails_helper"

RSpec.describe "ProgressesIndexTest", type: :system, js: true do
  describe "progress index page" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:portfolio) { create(:portfolio, user: user) }
    before {
      create_list(:progress, 10, portfolio: portfolio)
      progresses = portfolio.progresses.order(created_at: :desc)
      progresses.each do |progress|
        progress.comments.create!(user: user, comment: "test", evaluation: 0)
        progress.comments.create!(user: user2, comment: "test", evaluation: 1)
        progress.comments.create!(user: user3, comment: "test", evaluation: 2)
      end
      login(user)
      visit portfolio_progresses_path(portfolio)
    }
    it "shows correct progress order" do
      (0..9).each do |n|
        expect(page.all("ol li")[n]).to have_content "##{10 - n}"
        expect(page.all("ol li")[n]).to have_content "公開"
      end
    end
    it "shows average evaluation" do
      (0..9).each do |n|
        expect(page.all("ol li")[n]).to have_content "評価：1.0"
        expect(page.all("ol li")[n]).to have_content "（3 件）"
      end
    end
  end
end
