require "rails_helper"

RSpec.describe "Following", type: :system, js: true do
  describe "follow function" do
    let(:user1) { create(:user, email: "user@example.com", password: "password", password_confirmation: "password") }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:user4) { create(:user) }
    before {
      user1.following << user3
      user1.following << user4
      user2.following << user1
      user4.following << user1

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

    context "access to following page" do
      before { visit following_user_path(user1) }
      it "shows correct following information" do
        expect(user1.following).not_to be_empty
        expect(page).to have_content user1.following.count.to_s
        user1.following.each do |user|
          expect(page).to have_link "#{user.username}"
        end
      end
    end
    context "access to followers page" do
      before { visit followers_user_path(user1) }
      it "shows correct followers information" do
        expect(user1.followers).not_to be_empty
        expect(page).to have_content user1.followers.count.to_s
        user1.followers.each do |user|
          expect(page).to have_link "#{user.username}"
        end
      end
    end
  end
end
