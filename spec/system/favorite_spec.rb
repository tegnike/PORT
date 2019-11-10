require "rails_helper"

RSpec.describe "Favorite", type: :system, js: true do
  describe "favorite function" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    before {
      create_list(:portfolio, 10, user_id: user1.id)
      create_list(:portfolio, 10, user_id: user2.id)
      login(user1)
    }
    subject(:favorite) {
      first(".multi-info-box ul li .new_favorite").click_on
      sleep 1
      user1.reload
    }
    subject(:unfavorite) {
      first(".multi-info-box ul li .edit_favorite").click_on
      sleep 1
      user1.reload
    }

    context "access to my page" do
      before { visit user_path(user1) }
      it "shows favorite/unfavorite button operate correctly" do
        expect(page).to have_content "お気に入り 0"
        expect(page.first(".multi-info-box ul li")).to have_selector "#favorite_form", text: "0"

        expect { favorite }.to change { Favorite.count }.by(1)
        expect(page).to have_content "お気に入り 1"
        expect(page.first(".multi-info-box ul li")).to have_selector "#favorite_form", text: "1"

        expect { unfavorite }.to change { Favorite.count }.by(-1)
        expect(page).to have_content "お気に入り 0"
        expect(page.first(".multi-info-box ul li")).to have_selector "#favorite_form", text: "0"
      end
    end

    context "access to other user page" do
      before { visit user_path(user2) }
      it "shows favorite/unfavorite button operate correctly" do
        expect(page).to have_content "お気に入り 0"
        expect(page.first(".multi-info-box ul li")).to have_selector "#favorite_form", text: "0"

        expect { favorite }.to change { Favorite.count }.by(1)
        expect(page).to have_content "お気に入り 0"
        expect(page.first(".multi-info-box ul li")).to have_selector "#favorite_form", text: "1"

        expect { unfavorite }.to change { Favorite.count }.by(-1)
        expect(page).to have_content "お気に入り 0"
        expect(page.first(".multi-info-box ul li")).to have_selector "#favorite_form", text: "0"
      end
    end

    context "access to favorites page" do
      before {
         user1.add_favorite(user2.portfolios)
         visit user_path(user1)
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
