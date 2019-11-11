require "rails_helper"

RSpec.describe UsersController, type: :request do
  describe "GET #index" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:user) { create(:user) }
    context "get user_path before login" do
      before { get user_path(user) }
      it "should get a successful request" do
        expect(response).to have_http_status(:success)
      end
    end
    context "get user_path after login" do
      before {
        login(user)
        get user_path(user)
      }
      it "should get a successful request" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #following" do
    let(:user) { create(:user) }
    context "get following_user_path before login" do
      before { get following_user_path(user) }
      it "should get a successful request" do
        expect(response).to have_http_status(:success)
      end
    end
    context "get following_user_path after login" do
      before {
        login(user)
        get following_user_path(user)
      }
      it "should get a successful request" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #followers" do
    let(:user) { create(:user) }
    context "get followers_user_path before login" do
      before { get followers_user_path(user) }
      it "should get a successful request" do
        expect(response).to have_http_status(:success)
      end
    end
    context "get followers_user_path after login" do
      before {
        login(user)
        get followers_user_path(user)
      }
      it "should get a successful request" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #comment" do
    let(:user) { create(:user) }
    context "get comments_user_path before login" do
      before { get comments_user_path(user) }
      it "should get a successful request" do
        expect(response).to have_http_status(:success)
      end
    end
    context "get comments_user_path after login" do
      before {
        login(user)
        get comments_user_path(user)
      }
      it "should get a successful request" do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
