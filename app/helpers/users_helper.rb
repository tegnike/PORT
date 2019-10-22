module UsersHelper
  def set_user_image(user)
    if user.image.url == nil
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
      image_tag(gravatar_url, alt: user.username, class: "user-image")
    else
      image_tag(user.image.url, alt: user.username, class: "user-image")
    end
  end

  def is_action?(action_name)
    controller.action_name == action_name ? "nav-link active" : "nav-link"
  end
end
