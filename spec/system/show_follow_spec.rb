require "rails_helper"

RSpec.describe "ShowFollowTest", type: :system, js: true do
  describe "following and follower pages" do
    let!(:user1) { create(:user) }
    before {
      create_list(:user, 30)
      User.where.not(id: user1.id).each do |user|
        user1.follow(user)
        user.follow(user1)
      end
      login(user1)
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
