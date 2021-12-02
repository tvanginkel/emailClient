# Helpers used in the app
module ApplicationHelper

  # Get all the emails in a mailbox
  def get_emails(mail_box)
    @emails = Email.where(mail_box_id: mail_box.id)
  end

  def get_mailboxes
    # Get all the mailboxes of the user
    mailboxes = MailBox.where(user_id: current_user.id)

    # Map the mailboxes to the names
    @mailboxes = mailboxes.map(&:name)
  end

  # Get the user that the email belongs to through the mailbox
  def get_user_from_email(email_id)
    # Find the email from the db using the id
    email = Email.find_by(id: email_id)

    # Check the email is not null
    return nil if email.nil?

    # Get the mailbox the email belongs to
    mailbox = MailBox.find_by(id: email.mail_box_id)

    # Check the mailbox exists
    return nil if mailbox.nil?

    user = User.find_by(id: mailbox.user_id)

    # Check the user exists
    return nil if user.nil?

    user
  end

end
