require "rails_helper"

RSpec.describe "UsersIndexTest", type: :system, js: true do
  describe "User index" do
    let(:user) { create(:user) }
    before {
      create_list(:user, 30)
      login(user)
      visit users_path
    }
    it "shows correct pagination" do
      expect(page).to have_css ".pagination"
      User.order(created_at: :desc).page(1).each do |user|
        expect(page).to have_link "#{user.username}"
      end
    end
  end
end
