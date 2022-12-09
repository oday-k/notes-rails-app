class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      render json: { error: 'you need to login' }, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: 'record not found' }, status: :not_found
  end
end
