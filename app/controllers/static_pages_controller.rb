class StaticPagesController < ApplicationController
  def home
    @portfolios = Portfolio.order(created_at: :desc).page(params[:page])
    if user_signed_in?
      @portfolio = current_user.portfolios.build
      @portfolio.progresses.build(content: t("application.message.first_post"))
    else
      @user = User.new
    end
  end

  def help
  end

  def about
  end

  def policy
  end

  def terms
  end
end
