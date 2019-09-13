require "rails_helper"

RSpec.describe OmniauthCallbacksController, type: :request do
  describe "GET #sns_authentication" do
    subject { post user_twitter_omniauth_callback_path }

    context "set oauth information" do
      before {
        allow_any_instance_of(OmniauthCallbacksController).to receive(:auth_params).and_return(auth_params_mock)
      }
      it "increases user count and get 302 response" do
        expect { subject }.to change { User.count }.by(1)
        expect(response.status).to eq(302)
        expect(response.server_error?).not_to be
      end
      it "user has correct information" do
        subject
        @user = User.last
        expect(@user.username).to eq "mockuser"
        expect(@user.email).to eq "omniauth@example.com"
        expect(@user.profile).to eq "これはprofileです。"
      end
    end

    context "set oauth information without email" do
      before {
        allow_any_instance_of(OmniauthCallbacksController).to receive(:auth_params).and_return(auth_params_mock_no_email)
      }
      it "user has correct information" do
        subject
        @user = User.last
        expect(@user.username).to eq "mockuser"
        expect(@user.email).to eq "xxxxx-sns@example.com"
        expect(@user.profile).to eq "これはprofileです。"
      end
    end
  end
end
