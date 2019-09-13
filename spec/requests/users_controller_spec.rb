require "rails_helper"

RSpec.describe UsersController, type: :request do
  describe "GET #show" do
    let(:user) { create(:user) }
    context "get user_path before login" do
      before { get user_path(user) }
      it "should fail to get a successful request" do
        expect(response).not_to have_http_status(:success)
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
end
