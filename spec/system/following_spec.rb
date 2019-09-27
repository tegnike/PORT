require "rails_helper"

RSpec.describe "Following", type: :system, js: true do
  describe "follow function" do
    let(:user1) { create_user }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:user4) { create(:user) }
    before {
      user1.follow(user3)
      user1.follow(user4)
      user2.follow(user1)
      user4.follow(user1)
      login(user1)
    }
    context "access to other user page" do
      before { visit user_path(user2) }
      it "shows follow/unfollow button operate correctly" do
        expect(user1.following).not_to include(user2)
        click_button "フォロー"
        sleep 1
        user1.reload
        expect(user1.following).to include(user2)
        click_button "フォロー中"
        page.driver.browser.switch_to.alert.accept
        find ".btn-primary"
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
