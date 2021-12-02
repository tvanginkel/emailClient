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

end
