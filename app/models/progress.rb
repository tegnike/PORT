class Progress < ApplicationRecord
  belongs_to :portfolio
  has_rich_text :content
  validates :content, presence: true
end
