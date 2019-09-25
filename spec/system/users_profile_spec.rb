require "rails_helper"

RSpec.describe "UsersProfile", type: :system, js: true do
  describe "user profile page" do
    let(:user) { create_user }
    before {
      create_list(:portfolio, 10, user_id: user.id)
      login(user)
      visit user_path(user)
    }
    it "shows correct information" do
      expect(page).to have_title full_title(user.username)
      expect(page).to have_content user.username
      expect(page).to have_content user.portfolios.count.to_s
      expect(page).to have_css "ul.pagination"
    end
    it "shows correct pagination of portfolios" do
      user.portfolios.page(1).order(created_at: :desc).per(5).each do |portfolio|
        expect(page).to have_content "#{portfolio.title}"
        expect(page).to have_css "#portfolio-#{portfolio.id}>img.image"
        expect(page).to have_link "#{portfolio.web_url}"
        expect(page).to have_link "#{portfolio.git_url}"
      end
    end
  end
end
