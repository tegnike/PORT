require "rails_helper"

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }

  describe "Comment validation" do
    it "shows comment is valid" do
      expect(comment).to be_valid
    end
  end

  describe "Comment's columns validation" do
    describe "presence" do
      it { is_expected.to validate_presence_of :comment }
      it { is_expected.to validate_presence_of :evaluation }
      it { should validate_numericality_of(:evaluation) }
    end
  end
end
