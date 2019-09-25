class RankingsController < ApplicationController
  def favorite
    @portfolios = Portfolio.find(Favorite.ranking)
    unless @portfolios
      flash.now[:alert] = "お気に入りランキングを取得できませんでした。"
      render "static_pages/home"
    end
  end
end
