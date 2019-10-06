class RankingsController < ApplicationController
  def favorite
    @portfolios = Portfolio.find(Favorite.ranking)
    rescue ActiveRecord::RecordNotFound => e
      flash.now[:alert] = current_user.admin ? e.message : t("flash.get_alert", matter: t(".title"))
      redirect_root
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
      render "pageview"
      rescue ActiveRecord::RecordNotFound => e
        flash.now[:alert] = current_user.admin ? e.message : t("flash.get_alert", matter: t(".title"))
        redirect_root
    end
end
