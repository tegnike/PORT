class User < ApplicationRecord
  has_many :portfolios, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  mount_uploader :image, ImageUploader
  validates :username, presence: true, length: { maximum: 50 }, allow_nil: true
  validates :profile, length: { maximum: 200 }
  devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable, :lockable, :timeoutable, :omniauthable, omniauth_providers: [:twitter, :github, :google_oauth2]

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

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
      "#{auth["uid"]}-#{auth["provider"]}@example.com"
    end
end
