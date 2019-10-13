class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    respond_to do |format|
      if @user = User.find(params[:followed_id])
        current_user.follow(@user)
        format.html { redirect_to @user }
        format.js { render :create }
      else
        flash_failed_render
        format.js { render :new }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @user = Relationship.find(params[:id]).followed
        current_user.unfollow(@user)
        format.html { redirect_to @user }
        format.js { render :destroy }
      else
        flash_failed_render
        format.js { render :new }
      end
    end
  end
end
