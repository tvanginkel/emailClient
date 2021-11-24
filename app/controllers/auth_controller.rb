# frozen_string_literal: true

# Controller for the authentication
class AuthController < ApplicationController
  add_flash_types :info, :error, :warning

  def login; end

  def logout
    reset_session
    redirect_to '/auth/login'
  end

  def login_account
    @email = params[:email]
    @password = params[:password]

    @user = User.find_by_email(@email)

    if @user.nil?
      flash[:notice] = 'User not found'
    else
      puts "Welcome #{@email}"
      session[:user_id] = @user.id
      redirect_to root_path
    end
  end

  def register; end

  def create_account
    @email = params[:email]
    @password = params[:password]

    @user = User.new(email: @email, password: @password)

    if @user.save
      session[:user_id] = @user.id;
      redirect_to root_path
    else
      puts 'Error creating user'
    end
  end
end
