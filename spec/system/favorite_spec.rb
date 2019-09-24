require "rails_helper"

RSpec.describe "Favorite", type: :system, js: true do
  describe "favorite function" do
    let(:user1) { create(:user, email: "user@example.com", password: "password", password_confirmation: "password") }
    let(:user2) { create(:user) }
    before {
      create_list(:portfolio, 10, user_id: user1.id)
      create_list(:portfolio, 10, user_id: user2.id)

      visit new_user_session_path # log in by user1
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
      click_button "Log in"
    }
    subject(:favorite) {
      first("ol li").click_button "☆"
      sleep 1
      user1.reload
    }
    subject(:unfavorite) {
      first("ol li").click_button "★"
      sleep 1
      user1.reload
    }

    context "access to my page" do
      before { visit user_path(user1) }
      it "shows favorite/unfavorite button operate correctly" do
        expect(page).to have_content "0 favorites"
        expect(page.first("ol li")).not_to have_css ".btn-warning"
        expect(page.first("ol li")).to have_content "(0)"

        expect { favorite }.to change { Favorite.count }.by(1)
        expect(page).to have_content "1 favorite"
        expect(page.first("ol li")).to have_css ".btn-warning"
        expect(page.first("ol li")).to have_content "(1)"

        expect { unfavorite }.to change { Favorite.count }.by(-1)
        expect(page).to have_content "0 favorites"
        expect(page.first("ol li")).not_to have_css "☆.btn-warning"
        expect(page.first("ol li")).to have_content "(0)"
      end
    end

    context "access to other user page" do
      before { visit user_path(user2) }
      it "shows favorite/unfavorite button operate correctly" do
        expect(page).to have_content "0 favorites"
        expect(page.first("ol li")).not_to have_css ".btn-warning"
        expect(page.first("ol li")).to have_content "(0)"

        expect { favorite }.to change { Favorite.count }.by(1)
        expect(page).to have_content "0 favorites"
        expect(page.first("ol li")).to have_css ".btn-warning"
        expect(page.first("ol li")).to have_content "(1)"

        expect { unfavorite }.to change { Favorite.count }.by(-1)
        expect(page).to have_content "0 favorites"
        expect(page.first("ol li")).not_to have_css "☆.btn-warning"
        expect(page.first("ol li")).to have_content "(0)"
      end
    end

    context "access to favorites page" do
      before {
         user1.add_favorite(user2.portfolios)
         visit favorites_user_path(user1)
       }
      it "shows correct favorites information" do
        expect(user1.favorites).not_to be_empty
        expect(page).to have_content user1.favorites.count.to_s
        user1.favorite_portfolios.page(1).order(created_at: :desc).per(5).each do |portfolio|
          expect(page).to have_content "#{portfolio.title}"
        end
      end
    end
  end
end
