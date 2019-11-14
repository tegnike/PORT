class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :progress
  has_rich_text :comment
  validates :comment, presence: true
  validate :add_error_has_evaluation, on: :create

  def progress_owner
    self.progress.portfolio.user
  end

  def has_evaluation?
    return false unless self.user.comments
    self.evaluation && self.user.comments.where(progress: self.progress).where.not(evaluation: nil).any?
  end

  def add_error_has_evaluation
    if self.has_evaluation?
      errors[:base] << I18n.t("activerecord.attributes.comment.has_evaluation")
    end
  end
end
