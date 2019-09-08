class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  validates :username, presence: true, length: { maximum: 50 }, allow_nil: true
  validates :profile, length: { maximum: 200 }
  validate  :image_size
  devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable, :lockable, :timeoutable, :omniauthable, omniauth_providers: [:twitter, :github, :google_oauth2]

  def self.from_omniauth(auth)
    find_or_initialize_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["nickname"]
      user.profile = auth["info"]["description"]
      user.image = auth["info"]["image"]
      user.password = Devise.friendly_token[0, 20]
      user.email = User.dumy_email(auth)
    end
  end

  private
    def image_size
      if image.size > 5.megabytes
        errors.add(:image, "should be less than 5MB")
      end
    end

    def self.dumy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
end
