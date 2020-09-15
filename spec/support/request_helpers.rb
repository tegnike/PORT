include Warden::Test::Helpers

module RequestHelpers
  def login(user)
    login_as user, scope: :user
  end

  def omniauth_callback(sns, email)
    allow_any_instance_of(OmniauthCallbacksController).to receive(:auth_params).and_return(
      {
        provider: sns,
        uid: "XXXXX",
        info: {
          nickname: "mockuser",
          description: "これはprofileです。",
          email: email,
          image: "https://user-images.githubusercontent.com/35606144/82140082-81643600-982d-11ea-9c1d-12345b333dae.jpg"
        },
        credentials: {
          token: "token"
        }
      }.with_indifferent_access
    )
  end
end
