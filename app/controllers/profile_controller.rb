class ProfileController < ApplicationController
  before_action :require_login

  # GET /profile/profile
  def profile; end

  # POST /profile/profile
  #
  # Updates the password of the current user
  def change_password
    # Get the new password
    password = params[:password]

    if password == ''
      flash[:notice] = I18n.t 'empty_password'
      return redirect_back(fallback_location: root_path)
    end

    # Hash the user password
    hash = Argon2::Password.new.create(password)

    # Get the user from the db
    user = User.find_by_email(current_user.email)

    # Update the password of the user
    user.password = hash

    # Try to save the modified user to the db
    unless user.save
      # Show a flash error and reload the page if failed to save
      flash[:error] = I18n.t 'unexpected_error'
      return redirect_back(fallback_location: root_path)
    end

    flash[:notice] = I18n.t 'success'
    redirect_back(fallback_location: root_path)
  end
end
