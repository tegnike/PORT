class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :request_path
  before_action :configure_permitted_parameters, if: :devise_controller?

  def request_path
    @path = controller_path + "#" + action_name
    def @path.is(*str)
      str.map { |s| self.include?(s) }.include?(true)
    end
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :profile, :image])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :profile, :image])
    end
end
