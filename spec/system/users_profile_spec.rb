require "rails_helper"

RSpec.describe "UsersProfile", type: :system, js: true do
  describe "user profile page" do
    let(:user) { create(:user) }
    before {
      create_list(:portfolio, 10, user_id: user.id)
      login(user)
      visit user_path(user)
    }
    it "shows correct information" do
      expect(page).to have_title full_title(user.username)
      expect(page).to have_content user.username
      expect(page).to have_content "エンジニア"
      expect(page).to have_content user.portfolios.count.to_s
      expect(page).to have_css "ul.pagination"
    end
    it "shows correct pagination of portfolios" do
      user.portfolios.page(1).order(created_at: :desc).per(3).each do |portfolio|
        expect(page).to have_content "#{portfolio.title}"
      end
    end
  end
end
