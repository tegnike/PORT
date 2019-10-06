class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :profile, :image])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :profile, :image])
    end

    def redirect_root
      if user_signed_in?
        @portfolio = current_user.portfolios.build
        @portfolio.progresses.build(content: "最初の投稿です。")
      end
      render "static_pages/home"
    end

    def flash_success
      flash[:notice] = t("flash.success", action: t(".action"))
    end

    def flash_failed
      flash.now[:alert] = t("flash.failed", action: t(".action"))
    end
end
