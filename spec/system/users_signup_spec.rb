require "rails_helper"

RSpec.describe "UsersSignup", type: :system, js: true do
  describe "normal sign up" do
    subject {
      visit new_user_registration_path
      fill_in "user_username", with: username
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
      click_on "アカウント登録"
    }
    context "try to sign up by invalid user info" do
      let(:username) { "" }
      let(:email) { "user@invalid" }
      let(:password) { "foo" }
      let(:password_confirmation) { "bar" }
      it "should not increase user count and raise error" do
        expect { subject }.to change { User.count }.by(0)
        expect(page).to have_css "#error_explanation"
      end
    end

    context "try to sign up by valid user info" do
      let(:username) { "test_user" }
      let(:email) { "user@example.com" }
      let(:password) { "password" }
      let(:password_confirmation) { "password" }
      it "should increase user count and redirect to root_path" do
        expect { subject }.to change { User.count }.by(1)
        expect(current_path).to eq root_path
      end
    end
  end
end
