module PortfoliosHelper
  def score(portfolio)
    (score = (REDIS.zscore "portfolios/total", portfolio.id)) ? score : 0
  end
end
