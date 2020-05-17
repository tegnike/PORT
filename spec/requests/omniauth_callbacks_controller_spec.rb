require "rails_helper"

RSpec.describe OmniauthCallbacksController, type: :request do
  describe "GET #twitter_authentication" do
    subject {
      omniauth_callback("twitter", email)
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
        expect(@user.engineer).to eq false
      end
    end

    context "set oauth information without email" do
      let(:email) { nil }
      it "user has correct information" do
        subject
        @user = User.last
        expect(@user.username).to eq "mockuser"
        expect(@user.email).to eq "xxxxx-twitter@example.com"
        expect(@user.profile).to eq "これはprofileです。"
      end
    end
  end

  describe "GET #github_authentication" do
    subject {
      omniauth_callback("github", email)
      post user_github_omniauth_callback_path
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
        expect(@user.engineer).to eq true
      end
    end

    context "set oauth information without email" do
      let(:email) { nil }
      it "user has correct information" do
        subject
        @user = User.last
        expect(@user.username).to eq "mockuser"
        expect(@user.email).to eq "xxxxx-github@example.com"
        expect(@user.profile).to eq "これはprofileです。"
      end
    end
  end

  describe "GET #google_oauth2_authentication" do
    subject {
      omniauth_callback("google_oauth2", email)
      post user_google_oauth2_omniauth_callback_path
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
        expect(@user.engineer).to eq false
      end
    end

    context "set oauth information without email" do
      let(:email) { nil }
      it "user has correct information" do
        subject
        @user = User.last
        expect(@user.username).to eq "mockuser"
        expect(@user.email).to eq "xxxxx-google_oauth2@example.com"
        expect(@user.profile).to eq "これはprofileです。"
      end
    end
  end
end
