class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :profile, :image, :engineer])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :profile, :image, :engineer])
    end

    def flash_success
      flash[:notice] = t("flash.success", action: t(".action"))
    end

    def flash_failed_for_redirect
      flash[:alert] = t("flash.failed", action: t(".action"))
    end

    def flash_failed_for_render
      flash.now[:alert] = t("flash.failed", action: t(".action"))
    end
end
