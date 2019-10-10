require "rails_helper"

RSpec.describe "ProgressesInterfaceTest", type: :system, js: true do
  describe "progress order in progress index page" do
    let(:user) { create(:user) }
    let(:portfolio) { create(:portfolio, user: user) }
    before {
      create_list(:progress, 10, portfolio: portfolio)
      login(user)
      visit portfolio_progresses_path(portfolio)
    }
    it "shows correct progress order" do
      (0..9).each do |n|
        expect(page.all("ol li")[n]).to have_content "##{10 - n}"
      end
    end
  end
end
