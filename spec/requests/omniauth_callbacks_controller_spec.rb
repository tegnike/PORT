require "rails_helper"

RSpec.describe OmniauthCallbacksController, type: :request do
  describe "GET #sns_authentication" do
    subject {
      allow_any_instance_of(OmniauthCallbacksController).to receive(:auth_params).and_return(
        {
          provider: "sns",
          uid: "XXXXX",
          info: {
            nickname: "mockuser",
            description: "これはprofileです。",
            email: email,
            image: "http://www.ryolab.org/media/images/dummy-profile-pic-300x300.jpg"
          },
          credentials: {
            token: "token"
          }
        }.with_indifferent_access
      )
      post user_twitter_omniauth_callback_path
    }

    context "set oauth information" do
      let(:email) { "omniauth@example.com" }
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
      let(:email) { nil }
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
