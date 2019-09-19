require "rails_helper"

RSpec.describe PortfoliosController, type: :request do
  describe "POST #create" do
    context "try to post portfolio before log in" do
      subject { post portfolios_path, params: { portfolio: {
        title: "title",
        content: "content",
        web_url: "web_url",
        git_url: "git_url" } }
      }
      it "can't post portfolio and redirect to login_url" do
        expect { subject }.to change { Portfolio.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    context "try to delete portfolio before log in" do
      let!(:portfolio) { create(:portfolio) }
      subject { delete portfolio_path(portfolio) }
      it "can't delete portfolio and redirect  to login_url" do
        expect { subject }.to change { Portfolio.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "try to delete other user's portfolio" do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }
      let!(:portfolio) { create(:portfolio, user_id: user2.id) }
      before {
        login(user1)
      }
      subject { delete portfolio_path(portfolio) }
      it "can't delete portfolio and redirect to login_url" do
        expect { subject }.to change { Portfolio.count }.by(0)
        expect(response).to redirect_to root_url
      end
    end
  end
end
