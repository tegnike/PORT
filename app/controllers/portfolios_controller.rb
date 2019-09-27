class PortfoliosController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def create
    @portfolio = current_user.portfolios.build(portfolio_params)
    if @portfolio.save
      redirect_to user_path(current_user), notice: t("flash.create", item: "ポートフォリオ")
    else
      render "static_pages/home"
    end
  end

  def destroy
    if @portfolio.destroy
      redirect_to request.referrer || root_url, notice: t("flash.delete", item: "ポートフォリオ")
    else
      flash.now[:alert] = t("flash.alert", matter: "ポートフォリオの削除")
      render "static_pages/home"
    end
  end

  private
    def portfolio_params
      params.require(:portfolio).permit(:title, :content, :image, :web_url, :git_url)
    end

    def correct_user
      @portfolio = current_user.portfolios.find_by(id: params[:id])
      redirect_to root_url if @portfolio.nil?
    end
end
