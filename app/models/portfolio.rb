class Portfolio < ApplicationRecord
  attr_accessor :pageview
  belongs_to :user
  has_many :progresses, dependent: :destroy
  accepts_nested_attributes_for :progresses
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  mount_uploader :image, ImageUploader
  has_rich_text :content
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true
  validates :web_url, format: /\A#{URI.regexp(%w(http https))}\z/,  allow_blank: true
  validates :git_url, format: /\Ahttps:\/\/github.com\/.*\z/,  allow_blank: true

  def self.pv_data(span, title)
    keys = []
    (span..Date.tomorrow).each do |date|
      keys << "portfolios/#{date.strftime("%Y-%m-%d")}"
    end
    REDIS.zunionstore("portfolios/#{title}", keys)
    ids = REDIS.zrevrangebyscore "portfolios/#{title}", "+inf", 0, withscores: true, limit: [0, 10]
    ids.map { |id, pv|
      portfolio = self.find(id)
      portfolio.pageview = pv.to_i
      portfolio
    }
  end
end
