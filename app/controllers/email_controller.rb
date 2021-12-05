# frozen_string_literal: true

# Email Controller class
class EmailController < ApplicationController
  before_action :require_login

  def view_email
    # Get the email from the db
    email = Email.find_by(id: params[:id])

    # Check the email exists
    if email.nil?
      flash[:error] = I18n.t 'not_found.email'
      return redirect_back(fallback_location: root_path)
    end

    # Get the user that the email belongs to
    user = helpers.get_user_from_email(email.id)

    # Check the user was found
    # This should never trigger as it is impossible to have and email without a user
    if email.nil?
      flash[:error] = I18n.t 'not_found.user'
      return redirect_back(fallback_location: root_path)
    end

    # Check the email the user is trying to view belongs to the current user
    if user.id != current_user.id
      flash[:error] = I18n.t 'error.unauthorized'
      return redirect_back(fallback_location: root_path)
    end

    # Give the view access to the email info
    @email = email
  end

  def remove_inbox
    mailbox = MailBox.where(user_id: current_user.id, name: params[:name])[0]

    # Check the mailbox exists
    if mailbox.nil?
      flash[:error] = I18n.t 'not_found.mailbox'
      return redirect_back(fallback_location: root_path)
    end

    # Destroy the mailbox
    MailBox.destroy(mailbox.id)

    # Tell the user it was a success
    flash[:notice] = I18n.t 'success.success'
    redirect_back(fallback_location: root_path)
  end

  # POST /email/change_inbox
  #
  # Change the mailbox an email of the current user belongs to
  def change_inbox
    # Find the email from the db
    email = Email.find_by(id: params[:email_id])

    # Check the email exists
    if email.nil?
      flash[:error] = I18n.t 'not_found.email'
      return redirect_back(fallback_location: root_path)
    end

    # Find the mailbox the user wants to move the email to
    mailbox = MailBox.where(user_id: current_user.id, name: params[:name])[0]

    # Check it exists
    if mailbox.nil?
      flash[:error] = I18n.t 'not_found.mailbox'
      return redirect_back(fallback_location: root_path)
    end

    # Change the mailbox the email belongs to
    email.mail_box_id = mailbox.id

    # Save the changes to the db
    unless email.save
      flash[:error] = I18n.t 'error.unexpected_error'
      redirect_back(fallback_location: root_path)
    end

    # Tell the user it was a success
    flash[:notice] = I18n.t 'success.success'
    redirect_back(fallback_location: root_path)
  end

  # GET /email/new_email
  def new_email; end

  # POST /email/new_email
  #
  # Create and email and store it to the db. The way emails are managed in the app is:
  # Create one copy of the email and store it in the 'sent' mailbox of the sender,
  # Create a second copy of the email and store it in the receivers received mailbox.
  #
  # This way there will be 2 copies of the same email unless on of the user decides to delete the email
  # from their mailbox
  def create_email
    # Get all the params needed to create the email from the email_params to ensure safety
    to = email_params[:to]
    subject = email_params[:subject]
    content = email_params[:content]

    # Get the user the email is intended for
    user_to = User.find_by_email(to)

    # Check if the user the email is being sent to exists
    if user_to.nil?
      flash[:error] = I18n.t 'not_found.user'
      return redirect_back(fallback_location: root_path)
    end

    # Get the 'sent' mailbox of the current user
    mailbox = MailBox.where(name: 'Sent', user_id: current_user.id).first

    # Check if the mailbox was found, if it wasn't create it
    mailbox = MailBox.create(name: 'Sent', user_id: current_user.id) if mailbox.nil?

    # Create an email and store it in the sender's mailbox
    email = Email.new(subject: subject, content: content, to: to, from: current_user.email,
                      mail_box_id: mailbox.id)

    # Check if the email validation passes
    unless email.valid?
      flash[:error] = I18n.t 'empty.subject'
      return redirect_back(fallback_location: root_path)
    end

    # Save the email to the db, if there's and error print the error and refresh the page
    unless email.save
      flash[:error] = "#{I18n.t 'error.unexpected_error'}: #{email.errors}"
      return redirect_back(fallback_location: root_path)
    end

    # Get the 'received' mailbox of the user_to
    mailbox_to = MailBox.where(name: 'Received', user_id: user_to.id).first

    # Check if the mailbox exists, if it doesn't then create it
    mailbox_to = MailBox.create(name: 'Received', user_id: user_to.id) if mailbox_to.nil?

    # Create the same email but put it in the receiver's mailbox
    email_to = Email.new(subject: subject, content: content, to: to, from: current_user.email,
                         mail_box_id: mailbox_to.id)

    # Try to save the email to the db, if it doesn't work then throw and error
    unless email_to.save
      flash[:error] = "#{I18n.t 'error.unexpected_error'}: #{email_to.errors}"
      return redirect_back(fallback_location: root_path)
    end

    # Refresh the page and notify the user that the email was sent successfully
    flash[:notice] = I18n.t 'success.success'

    # Redirect to the inbox page
    redirect_to '/email/inbox'
  end

  # GET /email/inbox
  # Get all the mailboxes the user has
  def inbox
    @mailboxes = MailBox.where(user_id: current_user.id)
  end

  # POST /email/inbox
  # Creates an inbox for the given user
  def create_inbox
    # Get the params needed to create the inbox
    name = inbox_params[:name]

    # Create the mailbox
    mailbox = MailBox.new(name: name, user_id: current_user.id)

    unless mailbox.valid?
      flash[:error] = I18n.t 'empty.inbox_name'
      return redirect_back(fallback_location: root_path)
    end

    # Save the mailbox to the db, throw and error if it couldn't save
    unless mailbox.save
      flash[:error] = mailbox.errors
      return redirect_back(fallback_location: root_path)
    end

    # Tell the user the mailbox was created and refresh the page
    flash[:notice] = I18n.t 'success.success'

    # Refresh the page
    redirect_back(fallback_location: root_path)
  end

  # GET /email/delete_email
  # Deletes the email with the specified ID if it belongs to the user
  def delete_email
    id = params[:id]

    user = helpers.get_user_from_email(id)

    # Check if the current user is the same as the user who's email belongs to
    if user.id != current_user.id
      flash[:error] = I18n.t 'error.unauthorized'
      return redirect_to '/email/inbox'
    end

    # As we know de email exists and it belongs to the current user, we can now destroy it
    Email.delete(id)
    flash[:notice] = I18n.t 'success.success'
    redirect_to '/email/inbox'
  end

  private

  # Use strong params to prevent unexpected input from the user
  def email_params
    # These are all the values that are whitelisted
    params.permit(:to, :subject, :content, :authenticity_token, :commit)
  end

  def inbox_params
    # These are all the values that are whitelisted
    params.permit(:name, :authenticity_token, :commit)
  end

end