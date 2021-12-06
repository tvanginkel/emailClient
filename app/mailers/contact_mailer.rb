class ContactMailer < ApplicationMailer
  default from: 'contact@emailClient.com'

  def contact_email(content, email, name, phone)
    @content = content
    @name = name
    @email = email
    @phone = phone
    mail(to: 'contact@emailClient.com', subject: 'Contact email')
  end
end