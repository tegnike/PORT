require "rails_helper"

RSpec.describe RegistrationsController, type: :request do
  describe "user #update by sns_login" do
    subject(:login) {
      allow_any_instance_of(OmniauthCallbacksController).to receive(:auth_params).and_return(
        {
          provider: "sns",
          uid: "XXXXX",
          info: {
            nickname: "mockuser",
            description: "これはprofileです。",
            email: "test@example.com",
            image: "http://www.ryolab.org/media/images/dummy-profile-pic-300x300.jpg"
          },
          credentials: {
            token: "token"
          }
        }.with_indifferent_access
      )
      post user_twitter_omniauth_callback_path
    }

    context "try to update user profile" do
      context "without password" do
        before {
          login
          @user = User.find_by_email("test@example.com")
          put user_registration_path params: { user: {
            username: "user_update",
            profile: "content_update" }
          }
        }
        it "redirect to current_user page" do
          expect(response).to redirect_to user_path(@user)
        end
      end
    end
  end

  describe "user #update by normal_login" do
    let(:user) { create(:user, email: "test@example.com") }
    context "try to update user profile" do
      context "without password" do
        before {
          login(user)
          put user_registration_path params: { user: {
            username: "user_update",
            profile: "content_update" }
          }
        }
        it "get a successful request, it means render edit page" do
          expect(response).to have_http_status(:success)
        end
      end
      context "with password" do
        before {
          login(user)
          put user_registration_path params: { user: {
            username: "user_update",
            profile: "content_update",
            current_password: "password" }
          }
        }
        it "redirect to current_user page" do
          expect(response).to redirect_to user_path(user)
        end
      end
    end
  end
end
