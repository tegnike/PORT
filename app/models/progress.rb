class Progress < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :portfolio
  has_rich_text :content
  validates :content, presence: true
  validates :status, presence: true

  enum status: { plan: 0, design: 1, development: 2, release: 3 }

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
