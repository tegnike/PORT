class RankingsController < ApplicationController
  def favorite
    @portfolios = Portfolio.find(Favorite.ranking)
    unless @portfolios
      render "static_pages/home"
    end
  end
end
