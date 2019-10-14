class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :progress
  has_rich_text :comment
  validates :comment, presence: true
  validates :evaluation, presence: true, unless: :progress_owner?
  validates :evaluation, numericality: true, unless: :progress_owner?

  def progress_owner?
    self.user == self.progress.portfolio.user
  end
end
