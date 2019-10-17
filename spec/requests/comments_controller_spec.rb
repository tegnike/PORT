require "rails_helper"

RSpec.describe CommentsController, type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:portfolio) { create(:portfolio, user: user) }
  let(:progress) { create(:progress, portfolio: portfolio) }
  let!(:comment) { create(:comment, user: user, progress: progress) }

  describe "POST #create" do
    context "try to post comment before log in" do
      subject {
        post portfolio_progress_comments_path(portfolio, progress), params: { comment: { user_id: user2.id, comment: "content", evaluation: 5.0 } }
      }
      it "can't post progress and redirect to login_url" do
        expect { subject }.to change { Comment.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "try to post progress after log in" do
      subject {
        login(user)
        post portfolio_progress_comments_path(portfolio, progress), params: { comment: { user_id: user2.id, comment: "content", evaluation: 5.0 } }
      }
      it "can post progress and redirect to portfolio_path" do
        expect { subject }.to change { Comment.count }.by(1)
        expect(response).to redirect_to portfolio_path(portfolio)
      end
    end
  end

  describe "GET #edit" do
    context "try to access to edit_portfolio_progress_path before login" do
      before { get edit_portfolio_progress_comment_path(portfolio, progress, comment) }
      it "should redirest to login_url" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "try to access to edit_portfolio_progress_path after log in" do
      before {
        login(user)
        get edit_portfolio_progress_comment_path(portfolio, progress, comment)
      }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PATCH #update" do
    context "try to update progress before log in" do
      before {
        put portfolio_progress_comment_path(portfolio, progress, comment), params: { comment: { user_id: user2.id, comment: "content2", evaluation: 5.0 } }
      }
      it "can't update progress and redirect to login_url" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "try to post progress after log in" do
      before {
        login(user)
        put portfolio_progress_comment_path(portfolio, progress, comment), params: { comment: { user_id: user2.id, comment: "content2", evaluation: 5.0 } }
      }
      it "can update progress and redirect to portfolio_path" do
        expect(response).to redirect_to portfolio_path(portfolio)
      end
    end
  end

  describe "DELETE #destroy" do
    context "try to delete comment before log in" do
      subject { delete portfolio_progress_comment_path(portfolio, progress, comment) }
      it "can't delete comment and redirect to login_url" do
        expect { subject }.to change { Comment.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "try to delete comment after log in" do
      before { login(user) }
      subject { delete portfolio_progress_comment_path(portfolio, progress, comment) }
      it "can delete comment" do
        expect { subject }.to change { Comment.count }.by(-1)
      end
    end
    context "try to delete other user's portfolio" do
      before { login(user2) }
      subject { delete portfolio_progress_comment_path(portfolio, progress, comment) }
      it "can't delete progress and redirect to login_url" do
        expect { subject }.to change { Portfolio.count }.by(0)
        expect(response).to redirect_to root_url
      end
    end
  end
end
