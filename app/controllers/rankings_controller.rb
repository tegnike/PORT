class RankingsController < ApplicationController
  def favorite
    @portfolios = Portfolio.find(Favorite.ranking)
    unless @portfolios
      flash.now[:alert] = t("flash.alert", matter: "お気に入りランキングの取得")
      render "static_pages/home"
    end
  end
end
