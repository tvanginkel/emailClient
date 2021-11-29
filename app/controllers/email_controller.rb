class EmailController < ApplicationController
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

    # Check if the user the email is being sent to exists
    if @user_to.nil?
      flash[:error] = "User #{@to} not found "
      return redirect_back(fallback_location: root_path)
    end

    # Get the 'sent' mailbox of the current user
    @mailbox = MailBox.where(name: 'Sent', user_id: current_user.id).first

    # Check if the mailbox was found, if it wasn't create it
    @mailbox = MailBox.create(name: 'Sent', user_id: current_user.id) if @mailbox.nil?

    # Create an email and store it in the sender's mailbox
    @email = Email.new(subject: @subject, content: @content, to: @to, from: current_user.email,
                       mail_box_id: @mailbox.id)

    # Save the email to the db, if there's and error print the error and refresh the page
    unless @email.save
      flash[:error] = "Error creating email: #{@email.errors}"
      return redirect_back(fallback_location: root_path)
    end

    # Get the user the email is intended for
    @user_to = User.find_by_email(@to)

    # Get the 'received' mailbox of the user_to
    @mailbox_to = MailBox.where(name: 'Received', user_id: @user_to.id).first

    # Check if the mailbox exists, if it doesn't then create it
    @mailbox_to = MailBox.create(name: 'Received', user_id: @user_to.id) if @mailbox_to.nil?

    # Create the same email but put it in the receiver's mailbox
    @email_to = Email.new(subject: @subject, content: @content, to: @to, from: current_user.email,
                          mail_box_id: @mailbox_to.id)

    # Try to save the email to the db, if it doesn't work then throw and error
    unless @email_to.save
      flash[:error] = "Error creating email: #{@email_to.errors}"
      return redirect_back(fallback_location: root_path)
    end

    # Refresh the page and notify the user that the email was sent successfully
    flash[:notice] = 'Email sent'

    # Redirect to the inbox page
    redirect_to '/home/inbox'
  end

  # Get all the mailboxes the user has
  def inbox
    @mailboxes = MailBox.where(user_id: current_user.id)
  end

  # Creates an inbox for the given user
  def create_inbox
    # Get the params needed to create the inbox
    @name = params[:name]

    # Create the mailbox
    @mailbox = MailBox.new(name: @name, user_id: current_user.id)

    # Save the mailbox to the db, throw and error if it couldn't save
    unless @mailbox.save
      flash[:error] = @mailbox.errors
      return redirect_back(fallback_location: root_path)
    end

    # Tell the user the mailbox was created and refresh the page
    flash[:notice] = 'Mailbox created successfully'

    # Refresh the page
    redirect_back(fallback_location: root_path)
  end
end