module ProgressesHelper
  def get_status_number(progress)
    Progress.where(id: progress.id).where(status: progress.status).count
  end
end
