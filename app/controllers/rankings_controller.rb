class RankingsController < ApplicationController
  def favorite
    @portfolios = Portfolio.find(Favorite.ranking)
    unless @portfolios
      flash.now[:alert] = t("flash.get_alert", matter: t(".title"))
      render "static_pages/home"
    end
  end

  def total_pv
    pv_action(Date.strptime(ENV["RELEASE_DATE"]), t(".title"))
  end

  def weekly_pv
    pv_action(7.days.ago.to_datetime, t(".title"))
  end

  private
    def pv_action(span, matter)
      @portfolios = Portfolio.pv_data(span, action_name)
      unless @portfolios
        flash.now[:alert] = t("flash.get_alert", matter: matter)
        render "static_pages/home"
      end
      render "pageview"
    end
end
