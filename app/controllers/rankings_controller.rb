class RankingsController < ApplicationController
  def favorite
    @portfolios = Portfolio.find(Favorite.ranking)
    unless @portfolios
      flash.now[:alert] = t("flash.alert", matter: "お気に入りランキングの取得")
      render "static_pages/home"
    end
  end

  def total_pv
    pv_action(Date.strptime(ENV["RELEASE_DATE"]), "総合アクセスランキングの取得")
  end

  def weekly_pv
    pv_action(7.days.ago.to_datetime, "週間アクセスランキングの取得")
  end

  private

    def pv_action(span, matter)
      @portfolios = Portfolio.pv_data(span, "weekly")
      unless @portfolios
        flash.now[:alert] = t("flash.alert", matter: matter)
        render "static_pages/home"
      end
      render "pageview"
    end
end
