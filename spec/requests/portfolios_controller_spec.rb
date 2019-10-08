require "rails_helper"

RSpec.describe PortfoliosController, type: :request do
  let(:user) { create(:user) }
  let(:portfolio) { create(:portfolio, user: user) }
  let!(:progress) { create(:progress, portfolio: portfolio) }

  describe "GET #show" do
    it "returns http success" do
      get portfolio_path(portfolio)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    context "get new_portfolio_path before login" do
      before { get new_portfolio_path }
      it "should redirest to login_url" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    context "try to post portfolio before log in" do
      subject {
        post portfolios_path, params: { portfolio: {
          title: "title",
          content: "content",
          web_url: "web_url",
          git_url: "git_url" }
        }
      }
      it "can't post portfolio and redirect to login_url" do
        expect { subject }.to change { Portfolio.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #edit" do
    context "get edit_portfolio_path before login" do
      before { get edit_portfolio_path(portfolio) }
      it "should redirest to login_url" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #update" do
    context "try to post portfolio before log in" do
      before {
        put portfolio_path(portfolio), params: { portfolio: {
          title: "title2",
          content: "content2",
          web_url: "http://example/web_url_test2",
          git_url: "http://example/git_url_test2" }
        }
      }
      it "redirect to login_url" do
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "try to post portfolio after log in" do
      before {
        login(user)
        put portfolio_path(portfolio), params: { portfolio: {
          title: "title2",
          content: "content2",
          web_url: "http://example/web_url_test2",
          git_url: "http://example/git_url_test2" }
        }
      }
      it "redirect to portfolio_path and update information" do
        expect(response).to redirect_to portfolio_path(portfolio)
        expect(Portfolio.find(portfolio.id).title).to eq("title2")
      end
    end
  end

  describe "DELETE #destroy" do
    context "try to delete portfolio before log in" do
      let!(:portfolio) { create(:portfolio, user_id: user.id) }
      subject { delete portfolio_path(portfolio) }
      it "can't delete portfolio and redirect to login_url" do
        expect { subject }.to change { Portfolio.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "try to delete portfolio after log in" do
      let!(:portfolio) { create(:portfolio, user_id: user.id) }
      before {
        login(user)
        REDIS.zadd("portfolios/total/#{portfolio.id}", 1, portfolio.id)
      }
      subject { delete portfolio_path(portfolio) }
      it "can delete portfolio and redis_data" do
        expect { subject }.to change { Portfolio.count }.by(-1)
        expect(response).to redirect_to user_path(portfolio.user)
        expect(REDIS.keys("portfolios/total/#{portfolio.id}")).to be_empty
      end
    end

    context "try to delete other user's portfolio" do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }
      let!(:portfolio) { create(:portfolio, user_id: user2.id) }
      before { login(user1) }
      subject { delete portfolio_path(portfolio) }
      it "can't delete portfolio and redirect to login_url" do
        expect { subject }.to change { Portfolio.count }.by(0)
        expect(response).to redirect_to root_url
      end
    end
  end
end
