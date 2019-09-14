class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def following
    @title = "フォローユーザー"
    @user  = User.find(params[:id])
    @users = @user.following
    render "show_follow"
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers
    render "show_follow"
  end
end
