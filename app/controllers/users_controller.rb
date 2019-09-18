class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
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
end
