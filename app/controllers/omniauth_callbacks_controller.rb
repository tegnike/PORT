class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))

    if @user.persisted?
      sign_in_and_redirect @user
    else
      @user.skip_confirmation!
      @user.save!
      sign_in_and_redirect @user
    end
  end
end
