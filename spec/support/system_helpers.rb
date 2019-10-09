module SystemHelpers
  def login(user)
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "password"
    click_button "ログイン"
  end

  def logout
    click_link "マイアカウント"
    click_link "ログアウト"
  end
end
