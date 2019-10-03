class Progress < ApplicationRecord
  belongs_to :portfolio
  validates :portfolio_id, presence: true
  has_rich_text :content
  validates :content, presence: true
end
