class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @title = @user.username
    @portfolios = @user.portfolios.page(params[:page]).per(5)
  end

  def following
    @title = "フォローユーザー"
    @user  = User.find(params[:id])
    @users = @user.following.order(created_at: :desc).page(params[:page])
    render "show_follow"
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.order(created_at: :desc).page(params[:page])
    render "show_follow"
  end

  def favorites
    @title = "いいねしたポートフォリオ"
    @user = User.find(params[:id])
    @portfolios = @user.favorite_portfolios.page(params[:page]).per(5)
    render "show"
  end
end
