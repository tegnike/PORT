require "rails_helper"

RSpec.describe ProgressesController, type: :request do
  let(:user) { create(:user) }
  let!(:portfolio) { create(:portfolio, user: user) }
  let!(:progress) { create(:progress, portfolio: portfolio) }

  describe "GET #index" do
    context "try to access to portfolio_progresses_path before log in" do
      before { get portfolio_progresses_path(portfolio) }
      it "redirect to login_url" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "try to access to portfolio_progresses_path after log in" do
      before {
        login(user)
        get portfolio_progresses_path(portfolio)
      }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #new" do
    context "try to access to new_portfolio_progress_path before log in" do
      before { get new_portfolio_progress_path(portfolio) }
      it "redirect to login_url" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "try to access to new_portfolio_progress_path after log in" do
      before {
        login(user)
        get new_portfolio_progress_path(portfolio)
      }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST #create" do
    context "try to post progress before log in" do
      subject {
        post portfolio_progresses_path(portfolio), params: { progress: { content: "content" } }
      }
      it "can't post progress and redirect to login_url" do
        expect { subject }.to change { Progress.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "try to post progress after log in" do
      subject {
        login(user)
        post portfolio_progresses_path(portfolio), params: { progress: { content: "content" } }
      }
      it "can post progress and redirect to portfolio_path" do
        expect { subject }.to change { Progress.count }.by(1)
        expect(response).to redirect_to portfolio_path(portfolio)
      end
    end
  end

  describe "GET #edit" do
    context "try to access to edit_portfolio_progress_path before login" do
      before {
        get edit_portfolio_progress_path(portfolio, progress) }
      it "should redirest to login_url" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "try to access to edit_portfolio_progress_path after log in" do
      before {
        login(user)
        get edit_portfolio_progress_path(portfolio, progress)
      }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PATCH #update" do
    context "try to update progress before log in" do
      before {
        post portfolio_progresses_path(portfolio, progress), params: { progress: { content: "content2" } }
      }
      it "can't update progress and redirect to login_url" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "try to post progress after log in" do
      before {
        login(user)
        post portfolio_progresses_path(portfolio, progress), params: { progress: { content: "content2" } }
      }
      it "can update progress and redirect to portfolio_path" do
        expect(response).to redirect_to portfolio_path(portfolio)
      end
    end
  end

  describe "DELETE #destroy" do
    context "try to delete progress before log in" do
      subject { delete portfolio_progress_path(portfolio, progress) }
      it "can't delete progress and redirect to login_url" do
        expect { subject }.to change { Progress.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "try to delete portfolio after log in" do
      before { login(user) }
      subject { delete portfolio_progress_path(portfolio, progress) }
      it "can delete progress and redis_data" do
        expect { subject }.to change { Progress.count }.by(-1)
        expect(response).to redirect_to portfolio_progresses_path(portfolio)
      end
    end

    context "try to delete other user's portfolio" do
      let(:user2) { create(:user) }
      let!(:portfolio2) { create(:portfolio, user: user2) }
      let!(:progress2) { create(:progress, portfolio: portfolio) }
      before { login(user) }
      subject { delete portfolio_progress_path(portfolio2, progress2) }
      it "can't delete progress and redirect to login_url" do
        expect { subject }.to change { Portfolio.count }.by(0)
        expect(response).to redirect_to root_url
      end
    end
  end
end
