class ProfileController < ApplicationController
  before_action :require_login

  def profile; end

  # Updates the password of the current user
  def change_password
    # Get the new password
    @password = params[:password]

    # Hash the user password
    @hash = Argon2::Password.new.create(@password)

    # Get the user from the db
    @user = User.find_by_email(current_user.email)

    # Update the password of the user
    @user.password = @hash

    # Try to save the modified user to the db
    unless @user.save
      # Show a flash error and reload the page if failed to save
      flash[:error] = 'Error changing password'
      return redirect_back(fallback_location: root_path)
    end

    flash[:notice] = 'Password changed successfully'
    redirect_back(fallback_location: root_path)
  end
end
