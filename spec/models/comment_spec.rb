require "rails_helper"

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:portfolio) { create(:portfolio, user: user) }
  let(:progress) { create(:progress, portfolio: portfolio) }
  let(:comment) { create(:comment) }

  describe "Comment validation" do
    it "shows comment is valid" do
      expect(comment).to be_valid
    end
  end

  describe "Comment's columns validation" do
    describe "comment presence" do
      before { @comment = create(:comment, user: user, progress: progress) }
      context "comment has comment" do
        it "should be valid" do
          expect(@comment).to be_valid
        end
      end
      context "comment doesn't have comment" do
        before { @comment.comment = "" }
        it "should be invalid" do
          expect(@comment).not_to be_valid
        end
      end
    end

    describe "evaluation presence" do
      context "other user's portfolio" do
        before { @comment = create(:comment, user: user2, progress: progress) }
        context "comment has evaluation" do
          it "should be valid" do
            expect(comment).to be_valid
          end
        end
        context "comment doesn't have evaluation" do
          before { comment.evaluation = "" }
          it "should be invalid" do
            expect(comment).not_to be_valid
          end
        end
      end
      context "owner's portfolio" do
        before { @comment = create(:comment, user: user, progress: progress) }
        context "comment doesn't have evaluation" do
          before { @comment.evaluation = "" }
          it "should be valid" do
            expect(@comment).to be_valid
          end
        end
      end
    end
  end
end
