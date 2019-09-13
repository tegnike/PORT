class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  validates :username, presence: true, length: { maximum: 50 }, allow_nil: true
  validates :profile, length: { maximum: 200 }
  devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable, :lockable, :timeoutable, :omniauthable, omniauth_providers: [:twitter, :github, :google_oauth2]

  def remember_me
    true
  end

  def self.from_omniauth(auth)
    find_or_initialize_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["nickname"]
      user.profile = auth["info"]["description"]
      user.remote_image_url = auth["info"]["image"]
      user.password = Devise.friendly_token[0, 20]
      if auth["info"]["email"]
        user.email = auth["info"]["email"]
      else
        user.email = self.dumy_email(auth)
      end
    end
  end

  private
    def self.dumy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
end
