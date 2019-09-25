class PortfoliosController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def create
    @portfolio = current_user.portfolios.build(portfolio_params)
    if @portfolio.save
      redirect_to user_path(current_user), notice: "ポートフォリオを作成しました"
    else
      flash.now[:alert] = "情報が不正です。内容をご確認ください。"
      render "static_pages/home"
    end
  end

  def destroy
    if @portfolio.destroy
      redirect_to request.referrer || root_url, notice: "ポートフォリオを削除しました。"
    else
      flash.now[:alert] = "ポートフォリオの削除に失敗しました。"
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
