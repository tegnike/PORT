class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    sns_authentication
  end

  def github
    sns_authentication
  end

  def google_oauth2
    sns_authentication
  end

  def sns_authentication
    @user = User.from_omniauth(auth_params)

    unless @user.persisted?
      # @user.skip_confirmation!
      @user.save!
    end

    flash_success
    sign_in_and_redirect @user

  rescue ActiveRecord::RecordInvalid
    flash[:alert] = t(".error.record_invalid")
    redirect_to root_url
  end

  def auth_params
    request.env["omniauth.auth"].except("extra")
  end
end
