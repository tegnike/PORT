class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable, :lockable, :timeoutable, :omniauthable, omniauth_providers: [:twitter, :github, :google_oauth2]

  def self.from_omniauth(auth)
    find_or_initialize_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["nickname"]
      user.password = Devise.friendly_token[0, 20]
      user.email = User.dumy_email(auth)
    end
  end


  private
    def self.dumy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
end
