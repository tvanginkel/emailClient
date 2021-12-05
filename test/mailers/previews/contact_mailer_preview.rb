# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview
  def contact_email
    ContactMailer.contact_email('This is the message that the user has sent', 'test@gmail.com', 'Toni van Ginkel', '01234567890')
  end
end
