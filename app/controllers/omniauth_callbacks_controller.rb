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
    @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))

    unless @user.persisted?
      @user.skip_confirmation!
      @user.save!
    end

    sign_in_and_redirect @user
  end
end
