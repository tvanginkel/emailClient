# frozen_string_literal: true

# Controller for the authentication
class AuthController < ApplicationController

  # GET /auth/login
  def login; end

  # GET /auth/register
  def register; end

  # GET /auth/logout
  #
  # Log out from an existing account and delete the session data
  def logout
    # Delete all session data to prevent unauthorized access to pages
    reset_session
    flash[:notice] = I18n.t 'success.logout'
    redirect_to '/auth/login'
  end

  # POST /auth/login
  #
  # Login to and existing account using and email and a password
  def login_account
    # Get params from post request
    email = account_params[:email]
    password = account_params[:password]

    # Check to make sure the password is not empty
    if password == ''
      flash[:error] = I18n.t 'empty.password'
      return redirect_back(fallback_location: root_path)
    end

    # Find the user in the db
    user = User.find_by_email(email)

    # Check if the user was found
    if user.nil?
      flash[:error] = I18n.t 'error.incorrect_credentials'
      return redirect_back(fallback_location: root_path)
    end

    # Check if the password is correct
    unless Argon2::Password.verify_password(password, user.password)
      flash[:error] = I18n.t 'error.incorrect_credentials'
      return redirect_back(fallback_location: root_path)
    end

    # Store the new user id to the session
    session[:user_id] = user.id
    redirect_to root_path
  end

  # POST /auth/register
  #
  # Create an account using and email and a password
  def create_account
    # Get params from post request
    email = account_params[:email]
    password = account_params[:password]

    # Try to get a user with this email
    user = User.find_by_email(email)

    # If a user was found tell return an error message
    unless user.nil?
      flash[:error] = I18n.t 'error.email_already_exists'
      return redirect_back(fallback_location: root_path)
    end

    # Check the password is not empty
    if password == ''
      flash[:error] = I18n.t 'invalid.password'
      return redirect_back(fallback_location: root_path)
    end

    # Hash the user password
    hash = Argon2::Password.new.create(password)

    # Create user
    user = User.new(email: email, password: hash)

    unless user.valid?
      flash[:error] = I18n.t 'invalid.email'
      return redirect_back(fallback_location: root_path)
    end

    # Check if the user was saved to the db
    unless user.save
      flash[:error] = I18n.t 'error.unexpected_error'
      return redirect_back(fallback_location: root_path)
    end

    # Save user_id to session
    session[:user_id] = user.id

    # Redirect to home page
    redirect_to root_path
  end

  private

  # Use strong parameters to prevent any unexpected input from the user
  def account_params
    params.permit(:email, :password)
  end
end
