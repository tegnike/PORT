class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @portfolio = current_user.portfolios.build
      @portfolio.progresses.build(content: "最初の投稿です。")
    end
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
