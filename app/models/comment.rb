class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :progress
  has_rich_text :comment
  validates :comment, presence: true
  validates :evaluation, presence: true
  validates :evaluation, numericality: true
end
