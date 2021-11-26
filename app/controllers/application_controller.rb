# frozen_string_literal: true
#
# The application controller
class ApplicationController < ActionController::Base

  helper_method :current_user
  helper_method :logged_in?

  def current_user
    @current_user = User.find_by(id: session[:user_id])
    puts @current_user
    @current_user
  end

  def logged_in?
    !current_user.nil?
  end
end
