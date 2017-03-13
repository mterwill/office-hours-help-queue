class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  helper_method :current_user

  protected
  def find_verified_user
    if current_user = User.find_by(id: cookies.signed[:user_id])
      current_user
    else
      reject_unauthorized_connection
    end
  end

  def current_user
    @current_user ||= User.find_by_id(cookies.signed[:user_id]) if cookies.signed[:user_id]
  end

  def authenticate_user!
    redirect_to "/auth/google_oauth2?origin=#{request.original_url}" unless current_user.present?
  end
end
