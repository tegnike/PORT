module ProgressesHelper
  def average_evaluation(progress)
    evaluations = progress.comments.pluck(:evaluation)
    (evaluations.inject(0) { |sum, evaluation| sum + evaluation } / evaluations.length).round(1)
  end
end
