class Progress < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :portfolio
  has_rich_text :content
  validates :content, presence: true
end
