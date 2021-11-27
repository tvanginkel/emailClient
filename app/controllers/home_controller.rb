# frozen_string_literal: true

# Controls the home controller
class HomeController < ApplicationController
  before_action :require_login

  def index; end

  def new_email; end

  # Create and email and store it to the db. The way emails are managed in the app is:
  # Create one copy of the email and store it in the 'sent' mailbox of the sender,
  # Create a second copy of the email and store it in the receivers received mailbox.
  #
  # This way there will be 2 copies of the same email unless on of the user decides to delete the email
  # from their mailbox
  def create_email
    # Get all the params needed to create the email
    @to = params[:to]
    @subject = params[:subject]
    @content = params[:content]

    # Get the 'sent' mailbox of the current user
    @mailbox = MailBox.where(name: 'sent', user_id: current_user.id).first

    # Create an email and store it in the 'sent' mailbox
    @email = Email.new(subject: @subject, content: @content, to: @to, from: current_user.email,
                       mail_box_id: @mailbox.id)

    # Save the email to the db, if there's and error print the error and refresh the page
    unless @email.save
      flash[:error] = "Error creating email: #{@email.errors}"
      return redirect_back(fallback_location: root_path)
    end

    # Refresh the page and notify the user that the email was sent successfully
    flash[:notice] = 'Email sent'
    redirect_to '/home/inbox'
  end

  def inbox
    # Get all the mailboxes the user has
    @mailboxes = MailBox.where(user_id: current_user.id)
  end

  # This function checks if the user is logged in by using the session cache
  def require_login
    return if logged_in?

    flash[:error] = 'You must be logged in to access this page'
    redirect_to '/auth/login'
  end

  def create_inbox
    # Get the params needed to create the inbox
    @name = params[:name]

    #Create the mailbox
    @mailbox = MailBox.new(name: @name, user_id: current_user.id)

    #Save the mailbox to the db, throw and error if it couldn't save
    unless @mailbox.save
      flash[:error] = @mailbox.errors
      return redirect_back(fallback_location: root_path)
    end

    # Tell the user the mailbox was created and refresh the page
    flash[:notice] = 'Mailbox created successfully'
    redirect_back(fallback_location: root_path)
  end

end
