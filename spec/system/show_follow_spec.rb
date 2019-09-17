require "rails_helper"

RSpec.describe "ShowFollowTest", type: :system, js: true do
  describe "following and follower pages" do
    let!(:user1) { create(:user, email: "user@example.com", password: "password", password_confirmation: "password") }
    before {
      create_list(:user, 30)
      User.where.not(email: "user@example.com").each do |user|
        user1.following << user
        user1.followers << user
      end
      visit new_user_session_path
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "password"
      click_button "Log in"
    }
    context "access to following page" do
      before { visit following_user_path(user1) }
      it "shows correct pagination" do
        expect(page).to have_css ".pagination"
        user1.following.order(created_at: :desc).page(1).each do |user|
          expect(page).to have_link "#{user.username}"
        end
      end
    end
    context "access to follower page" do
      before { visit followers_user_path(user1) }
      it "shows correct pagination" do
        expect(page).to have_css ".pagination"
        user1.followers.order(created_at: :desc).page(1).each do |user|
          expect(page).to have_link "#{user.username}"
        end
      end
    end
  end
end
