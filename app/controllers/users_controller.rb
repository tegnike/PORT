class UsersController < ApplicationController
  before_action :user_infomation, except: :index

  def index
    # @users = User.where.not(confirmed_at: nil).order(created_at: :desc).page(params[:page])
    @users = User.order(created_at: :desc).page(params[:page])
  end

  def show
    @portfolios = @user.favorite_portfolios.order(created_at: :desc).page(params[:page]).per(5)
  end

  def following
    @users = @user.following.order(created_at: :desc).page(params[:page])
    render "show"
  end

  def followers
    @users = @user.followers.order(created_at: :desc).page(params[:page])
    render "show"
  end

  def comments
    @comments = @user.comments.order(created_at: :desc).page(params[:page])
    render "show"
  end

  private
    def user_infomation
      @user = User.find(params[:id])
      @my_portfolios = @user.portfolios.order(created_at: :desc).page(params[:page]).per(3)
    end
end
