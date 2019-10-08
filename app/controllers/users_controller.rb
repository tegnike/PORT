class UsersController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @users = User.where.not(confirmed_at: nil).order(created_at: :desc).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.username
    @portfolios = @user.portfolios.order(created_at: :desc).page(params[:page]).per(5)
  end

  def following
    @user  = User.find(params[:id])
    @users = @user.following.order(created_at: :desc).page(params[:page])
    render "show_follow"
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers.order(created_at: :desc).page(params[:page])
    render "show_follow"
  end

  def favorites
    @user = User.find(params[:id])
    @portfolios = @user.favorite_portfolios.order(created_at: :desc).page(params[:page]).per(5)
    render "show"
  end
end
