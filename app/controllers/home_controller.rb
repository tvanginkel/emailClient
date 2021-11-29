# frozen_string_literal: true

# Controls the home controller
class HomeController < ApplicationController
  before_action :require_login

  def index; end

end
