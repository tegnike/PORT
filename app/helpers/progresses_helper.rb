module ProgressesHelper
  def get_status_number(progress)
    ids = progress.portfolio.progresses.select { |r| r.status == progress.status }.pluck(:id)
    ids.index(progress.id) + 1
  end
end
