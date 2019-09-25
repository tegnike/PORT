class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @portfolio && @user
        current_user.add_favorite(@portfolio)
        format.html { redirect_to @portfolio }
        format.js { render :create }
      else
        flash.now[:alert] = "お気に入り登録に失敗しました。"
        format.js { render :new }
      end
    end
  end

  def destroy
    @portfolio = Favorite.find(params[:id]).portfolio
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @portfolio && @user
        current_user.remove_favorite(@portfolio)
        format.html { redirect_to @portfolio }
        format.js { render :destroy }
      else
        flash.now[:alert] = "お気に入りを削除できませんでした。"
        format.js { render :new }
      end
    end
  end
end
