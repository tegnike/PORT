require "rails_helper"

RSpec.describe "Following", type: :system, js: true do
  describe "follow function" do
    let(:user1) { create(:user, email: "user@example.com", password: "password", password_confirmation: "password") }
    let(:user2) { create(:user) }
    before {
      user2.following << user1

      visit new_user_session_path # log in by user1
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
      click_button "Log in"
    }
    context "access to other user page" do
      before { visit user_path(user2) }
      it "shows follow/unfollow button operate correctly" do
        expect(user1.following).not_to include(user2)
        click_button "Follow"
        sleep 1
        user1.reload
        expect(user1.following).to include(user2)
        click_button "Unfollow"
        sleep 1
        user1.reload
        expect(user1.following).not_to include(user2)
      end
    end
  end
end
