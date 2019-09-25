module SystemHelpers
  def create_user
    create(:user, email: "user@example.com", password: "password", password_confirmation: "password")
  end

  def login(user)
    visit new_user_session_path
    fill_in "user_email", with: "user@example.com"
    fill_in "user_password", with: "password"
    click_button "Log in"
  end
end
