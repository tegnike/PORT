class RegistrationsController < Devise::RegistrationsController
  protected
    def after_update_path_for(resource)
      user_path(resource)
    end

    def update_resource(resource, params)
      if resource.provider
        resource.update(params)
      else
        super
      end
    end
end
