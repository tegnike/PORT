require "rails_helper"

RSpec.describe Progress, type: :model do
  let(:progress) { create(:progress) }

  describe "Portfolio validation" do
    it "shows user is valid" do
      expect(progress).to be_valid
    end
  end

  describe "Progress's columns validation" do
    describe "presence" do
      it { is_expected.to validate_presence_of :content }
      it { is_expected.to validate_presence_of :title }
    end

    describe "characters" do
      it { is_expected.to validate_length_of(:title).is_at_most(50) }
    end
  end
end
