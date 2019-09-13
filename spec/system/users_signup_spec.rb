require "rails_helper"

RSpec.describe "UsersSignup", type: :system, js: true do
  describe "normal sign up" do
    context "try to sign up by invalid user info" do
      subject {
        visit new_user_registration_path
        fill_in "Username", with: ""
        fill_in "Profile", with: ""
        fill_in "Email", with: "user@invalid"
        attach_file "user_image", "#{Rails.root}/spec/factories/rails.png"
        fill_in "Password", with: "foo"
        fill_in "Password confirmation", with: "bar"
        click_on "Sign up"
      }
      it "should not increase user count and raise error" do
        expect { subject }.to change { User.count }.by(0)
        expect(page).to have_css "#error_explanation"
      end
    end

    context "try to sign up by valid user info" do
      subject {
        visit new_user_registration_path
        fill_in "Username", with: "test_user"
        fill_in "Profile", with: "This is test_user profile."
        fill_in "Email", with: "user@example.com"
        attach_file "user_image", "#{Rails.root}/spec/factories/rails.png"
        fill_in "Password", with: "password"
        fill_in "Password confirmation", with: "password"
        click_on "Sign up"
      }
      it "should increase user count and redirect to root_path" do
        expect { subject }.to change { User.count }.by(1)
        expect(current_path).to eq root_path
      end
    end
  end
end
