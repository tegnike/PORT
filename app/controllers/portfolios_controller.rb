class PortfoliosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
    @portfolio = Portfolio.find(params[:id])
    if current_user
      cookies_id = current_user.id * 100000 + @portfolio.id
      unless current_user == @portfolio.user || cookies.permanent.signed["#{cookies_id}"]
        cookies.permanent.signed["#{cookies_id}"] = SecureRandom.base64(12)
        REDIS.zincrby "portfolios/#{Date.current}", 1, @portfolio.id
      end
    end
    # the latest progress
    @progress = @portfolio.progresses.limit(1).order("created_at DESC").first
    # comment index
    @comments = @progress.comments.page(params[:page]).order(:created_at)
    # comment new
    @comment = @progress.comments.build
  end

  def new
    @portfolio = current_user.portfolios.build
    @portfolio.progresses.build(content: t("application.message.first_post"))
  end

  def create
    @portfolio = current_user.portfolios.build(portfolio_params)
    if @portfolio.save
      flash_success
      redirect_to @portfolio
    else
      flash_failed_for_render
      render "new"
    end
  end

  def edit
  end

  def update
    if @portfolio.update_attributes(portfolio_params)
      flash_success
      redirect_to @portfolio
    else
      flash_failed_for_render
      render "edit"
    end
  end

  def destroy
    portfolio = @portfolio
    if @portfolio.destroy
      delete_redis(portfolio)
      flash_success
      redirect_to @portfolio.user
    else
      flash_failed_for_redirect
      redirect_to root_url
    end
  end

  private
    def portfolio_params
      params.require(:portfolio).permit(
        :title,
        :content,
        :image,
        :web_url,
        :git_url,
        progresses_attributes: [ :content, :status ]
      )
    end

    def correct_user
      @portfolio = current_user.portfolios.find_by(id: params[:id])
      if @portfolio.nil?
        flash_failed_for_redirect
        redirect_to root_url
      end
    end

    def delete_redis(portfolio)
      (portfolio.created_at.yesterday.to_datetime..Date.tomorrow).each do |date|
        REDIS.zrem "portfolios/#{date.strftime("%Y-%m-%d")}", portfolio.id
      end
      REDIS.del "portfolios/total/#{portfolio.id}"
    end
end
