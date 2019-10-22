class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    respond_to do |format|
      if @user = User.find(params[:followed_id])
        current_user.follow(@user)
        format.html { redirect_to @user }
        format.js {
          @page_user = User.find_by(id: params[:page_id])
          render :create
        }
      else
        flash_failed_for_render
        format.js { render :new }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @user = Relationship.find(params[:id]).followed
        current_user.unfollow(@user)
        format.html { redirect_to @user }
        format.js {
          @page_user = User.find_by(id: params[:page_id])
          render :destroy
        }
      else
        flash_failed_for_render
        format.js { render :new }
      end
    end
  end
end
