class RegistrationsController < Devise::RegistrationsController
  before_action :permit_extra_params

  def create
    build_resource(sign_up_params)
    if resource.save
      sign_up(resource_name, resource) if resource.persisted?
      render :head, status: :created
    else
      render json: { errors: { user: resource.errors.full_messages } }, status: :bad_request
    end
  end

  private

  def permit_extra_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
