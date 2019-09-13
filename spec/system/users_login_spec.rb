require "rails_helper"

RSpec.describe "UsersLoginTest", type: :system, js: true do
  describe "user login" do
    let!(:user) { create(:user, email: "user@example.com", password: "password", password_confirmation: "password") }

    context "try to login by invalid user info" do
      before {
        visit new_user_session_path
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: ""
        click_button "Log in"
      }
      it "render new_user_session_path" do
        expect(current_path).to eq new_user_session_path
        expect(page).to have_selector ".alert", text: "Invalid Email or password."
      end
      it "doesn't show alert message after moving to root_path" do
        visit root_path
        expect(page).to have_no_selector ".alert", text: "Invalid Email or password."
      end
    end

    context "log in by valid user info" do
      before {
        visit new_user_session_path
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "password"
        click_button "Log in"
      }
      it "redirect to root_path and change header links" do
        expect(current_path).to eq root_path
        expect(page).to have_link "マイアカウント"
      end
      it "change header links after log out" do
        click_link "マイアカウント"
        click_link "ログアウト"
        expect(page).to have_link "ログイン"
      end
    end
  end
end
