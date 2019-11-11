require "rails_helper"

RSpec.describe "FavoriteRanking", type: :system, js: true do
  describe "favorite ranking page" do
    let(:user) { create(:user) }
    before {
      create_list(:user, 10)
      create_list(:portfolio, 10, user_id: user.id)
      users = User.all
      (0..9).each do |n|
        users[0..n].each { |u| u.add_favorite(user.portfolios[n]) }
      end
      login(user)
    }

    context "access to favorite page" do
      before {
        visit rankings_favorite_path
      }
      it "shows correct ranking order" do
        (0..9).each do |n|
          expect(page.all("ol li")[n]).to have_selector "#favorite_form", text: "#{10 - n}"
        end
      end
    end
  end
end
