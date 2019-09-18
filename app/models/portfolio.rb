class Portfolio < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  has_rich_text :content
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true
  validates :web_url, presence: true
  validates :git_url, presence: true
end
