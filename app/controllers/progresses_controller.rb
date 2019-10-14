class ProgressesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_portfolio
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @progresses = @portfolio.progresses.order(created_at: :desc).page(params[:page])
  end

  def show
    @progress = Progress.find(params[:id])
    @comments = @progress.comments.page(params[:page])
    @comment = @progress.comments.build
  end

  def new
    @progress = @portfolio.progresses.build
  end

  def create
    @progress = @portfolio.progresses.build(progress_params)
    if @progress.save
      flash_success
      @comments = @progress.comments.page(params[:page])
      redirect_to @portfolio
    else
      flash_failed_for_render
      render "new"
    end
  end

  def edit
  end

  def update
    if @progress.update_attributes(progress_params)
      flash_success
      redirect_to portfolio_progresses_path(@portfolio)
    else
      flash_failed_for_render
      render "edit"
    end
  end

  def destroy
    if @progress.destroy
      flash_success
      redirect_to portfolio_progresses_path(@portfolio)
    else
      flash_failed_for_redirect
      redirect_to root_url
    end
  end

  private
    def get_portfolio
      @portfolio = Portfolio.find(params[:portfolio_id])
    end

    def progress_params
      params.require(:progress).permit(:content)
    end

    def correct_user
      @progress = @portfolio.progresses.find_by(id: params[:id])
      if @progress.nil?
        flash_failed_for_redirect
        redirect_to root_url
      end
    end
end
