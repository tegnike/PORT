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
  end
end
