# frozen_string_literal: true

# Controller for the authentication
class AuthController < ApplicationController

  def login; end

  def logout
    # Delete all session data to prevent unauthorized access to pages
    reset_session
    flash[:notice] = 'Log out was successful'
    redirect_to '/auth/login'
  end

  def login_account
    # Get params from post request
    @email = params[:email]
    @password = params[:password]

    # Find the user in the db
    @user = User.find_by_email(@email)

    # TODO: add error message to UI

    # Check if the user was found
    if @user.nil?
      flash[:error] = 'The email or password was incorrect'
      return redirect_back(fallback_location: root_path)
    end

    # Check if the password is correct
    unless Argon2::Password.verify_password(@password, @user.password)
      flash[:error] = 'The email or password was incorrect'
      return redirect_back(fallback_location: root_path)
    end

    # Store the new user id to the session
    session[:user_id] = @user.id
    redirect_to root_path
  end

  def register; end

  def create_account
    # Get params from post request
    @email = params[:email]
    @password = params[:password]

    # Hash the user password
    @hash = Argon2::Password.new.create(@password)

    # Create user
    @user = User.new(email: @email, password: @hash)

    # Check if the user was saved to the db
    unless @user.save
      flash[:error] = 'There was an error creating the account'
      return redirect_back(fallback_location: root_path)
    end
    # Save user_id to session
    session[:user_id] = @user.id

    redirect_to root_path

  end

  private

end
