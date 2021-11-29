# frozen_string_literal: true

# The application controller
class ApplicationController < ActionController::Base

  helper_method :current_user
  helper_method :logged_in?
  helper_method :require_login

  # Get the current user from the db using the id from the session
  def current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  # Check if the user is logged in by checking if current_user is null
  def logged_in?
    !current_user.nil?
  end

  # This function checks if the user is logged in by using the session cache
  def require_login
    return if logged_in?

    flash[:error] = 'You must be logged in to access this page'
    redirect_to '/auth/login'
  end
end
