class RankingsController < ApplicationController
  def favorite
    @portfolios = Portfolio.find(Favorite.ranking)
    rescue ActiveRecord::RecordNotFound => e
      flash.now[:alert] = current_user.admin ? e.message : t("flash.failed", action: t(".action"))
      redirect_root
  end

  def total_pv
    pv_action(Date.strptime(ENV["RELEASE_DATE"]))
  end

  def weekly_pv
    pv_action(7.days.ago.to_datetime)
  end

  private
    def pv_action(span)
      @portfolios = Portfolio.pv_data(span, action_name)
      render "pageview"
      rescue ActiveRecord::RecordNotFound => e
        flash.now[:alert] = current_user.admin ? e.message : t("flash.failed", action: t(".action"))
        redirect_root
    end
end
