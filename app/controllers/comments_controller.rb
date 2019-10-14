class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_portfolio_progress
  before_action :owner_has_evaluation?, only: [:create, :update]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def create
    @comment = @progress.comments.build(comment_params)
    if @comment.save
      flash_success
      redirect_to @portfolio
    else
      flash_failed_for_render
      @comments = @progress.comments.page(params[:page])
      render "portfolios/show"
    end
  end

  def edit
    respond_to do |format|
      format.html { render "edit" }
      format.js { render :edit }
    end
  end

  def update
    respond_to do |format|
      if @comment.update_attributes(comment_params)
        flash_success
        format.html {
           @comments = @progress.comments.page(params[:page])
           redirect_to @portfolio
         }
        format.js { render :update }
      else
        flash_failed_for_render
        format.js { render :edit }
      end
    end
  end

  def destroy
    if @comment.destroy
      flash_success
      @comments = @progress.comments.page(params[:page])
      redirect_to @portfolio
    else
      flash_failed_for_redirect
      redirect_to root_url
    end
  end

  private
    def get_portfolio_progress
      @progress = Progress.find(params[:progress_id])
      @portfolio = Portfolio.find(params[:portfolio_id])
    end

    def comment_params
      params.require(:comment).permit(:user_id, :comment, :evaluation)
    end

    def owner_has_evaluation?
      if (params[:comment][:user_id].to_i == @portfolio.user_id) && params[:comment][:evaluation] != nil
        @comment = @progress.comments.build(comment_params)
        @comments = @progress.comments.page(params[:page])
        flash.now[:alert] = t(".validation")
        render "portfolios/show"
      end
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      if @comment.nil?
        flash_failed_for_redirect
        redirect_to root_url
      end
    end
end
