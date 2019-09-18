class StaticPagesController < ApplicationController
  def home
    @portfolio = current_user.portfolios.build if user_signed_in?
  end

  def help
  end

  def about
  end

  def policy
  end

  def terms
  end
end
