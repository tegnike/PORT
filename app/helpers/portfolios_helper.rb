module PortfoliosHelper
  def score(portfolio)
    keys = []
    (portfolio.created_at.to_datetime..Date.tomorrow).each do |date|
      keys << "portfolios/#{date.strftime("%Y-%m-%d")}"
    end
    REDIS.zunionstore("portfolios/total/#{portfolio.id}", keys)
    (score = (REDIS.zscore("portfolios/total/#{portfolio.id}", portfolio.id))) ? score.to_i : 0
  end

  def get_progress_number(portfolio, progress)
    ids = portfolio.progresses.pluck(:id)
    ids.index(progress.id) + 1
  end
end
