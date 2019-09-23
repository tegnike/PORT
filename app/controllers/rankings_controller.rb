class RankingsController < ApplicationController
  def favorite
    @portfolios = Portfolio.find(Favorite.group(:portfolio_id).order(Arel.sql("count(portfolio_id) desc")).limit(10).pluck(:portfolio_id))
    unless @portfolios
      render "static_pages/home"
    end
  end
end
