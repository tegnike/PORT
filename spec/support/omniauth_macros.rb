module OmniauthMacros
  def auth_params_mock
    OmniAuth.config.mock_auth[:sns] = OmniAuth::AuthHash.new(
      {
        provider: "sns",
        uid: "XXXXX",
        info: {
          nickname: "mockuser",
          description: "これはprofileです。",
          email: "omniauth@example.com",
          image: "http://www.ryolab.org/media/images/dummy-profile-pic-300x300.jpg"
        },
        credentials: {
          token: "token"
        }
      }.with_indifferent_access
    )
  end

  def auth_params_mock_no_email
    auth = auth_params_mock
    auth[:info][:email] = nil
    auth
  end
end
