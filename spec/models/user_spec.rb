require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  describe "User validation" do
    it "shows user is valid" do
      expect(user).to be_valid
    end
  end

  describe "User's columns validation" do
    it { is_expected.to validate_length_of(:username).is_at_most(50) }
    it { is_expected.to validate_length_of(:profile).is_at_most(200) }
    it { is_expected.to allow_values("true", "false").for(:engineer)  }
  end

  describe "follow and unfollow" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    subject(:follow) { user1.follow(user2) }
    subject(:unfollow) { user1.unfollow(user2) }
    it "shows correct follow method" do
      expect(user1.following?(user2)).to be_falsey
      follow
      expect(user1.following?(user2)).to be_truthy
    end
    it "shows correct unfollow method" do
      follow
      expect(user2.followers.include?(user1)).to be_truthy
      unfollow
      expect(user1.following?(user2)).to be_falsey
    end
  end

  describe "association with portfolio" do
    let!(:portfolio) { create(:portfolio, user_id: user.id) }
    before {
      user.destroy
    }
    it "delete user's portfolio" do
      expect(Portfolio.where(user: user)).to be_empty
    end
  end

  describe "favorite function" do
    let(:portfolio) { create(:portfolio) }
    subject(:favorite) { user.add_favorite(portfolio) }
    subject(:unfavorite) { user.remove_favorite(portfolio) }
    it "shows correct favorite method" do
      expect(user.has_favorite?(portfolio)).to be_falsey
      favorite
      expect(user.has_favorite?(portfolio)).to be_truthy
    end
    it "shows correct unfavorite method" do
      favorite
      expect(portfolio.favorite_users.include?(user)).to be_truthy
      unfavorite
      expect(user.has_favorite?(portfolio)).to be_falsey
    end
  end
end
