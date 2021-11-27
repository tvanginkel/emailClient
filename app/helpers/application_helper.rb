# Helpers used in the app
module ApplicationHelper

  # Get all the emails in a mailbox
  def get_emails(mail_box)
    @emails = Email.where(mail_box_id: mail_box.id)
  end
end
