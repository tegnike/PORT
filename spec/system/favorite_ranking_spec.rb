require "rails_helper"

RSpec.describe "FavoriteRanking", type: :system, js: true do
  describe "favorite ranking page" do
    let(:user) { create(:user, email: "user@example.com", password: "password", password_confirmation: "password") }
    before {
      create_list(:user, 10)
      create_list(:portfolio, 10, user_id: user.id)
      users = User.all
      (0..9).each do |n|
        users[0..n].each { |u| u.add_favorite(user.portfolios[n]) }
      end
      visit new_user_session_path # log in by user1
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
      click_button "Log in"
    }

    context "access to favorite page" do
      before {
        visit rankings_favorite_path
      }
      it "shows correct ranking order" do
        (0..9).each do |n|
          expect(page.all("ol li")[n]).to have_content "(#{10 - n})"
        end
      end
    end
  end
end
