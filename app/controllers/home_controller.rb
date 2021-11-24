# frozen_string_literal: true

# Controls the home controller
class HomeController < ApplicationController
  before_action :require_login

  def require_login
    return if logged_in?
    puts 'You must be logged in to access this page'
    redirect_to '/auth/login'
  end

  def index; end
end
