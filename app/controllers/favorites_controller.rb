class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @user = User.find(params[:user_id])
    current_user.add_favorite(@portfolio)
    respond_to do |format|
      format.html { redirect_to @portfolio }
      format.js
    end
  end

  def destroy
    @portfolio = Favorite.find(params[:id]).portfolio
    @user = User.find(params[:user_id])
    current_user.remove_favorite(@portfolio)
    respond_to do |format|
      format.html { redirect_to @portfolio }
      format.js
    end
  end
end
