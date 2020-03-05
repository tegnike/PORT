class Progress < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :portfolio
  has_rich_text :content
  validates :content, presence: true
  validates :title, presence: true, length: { maximum: 50 }

  def average_evaluation
    evaluations = self.comments.where.not(evaluation: nil).pluck(:evaluation)
    if evaluations != []
      (evaluations.inject(0) { |sum, evaluation| sum + evaluation } / evaluations.length).round(1)
    end
  end

  def has_any_evaluations?
    self.comments.where.not(evaluation: nil).pluck(:evaluation) != []
  end
end
